function axisinfo = plot_track(track)
persistent first_flag
if isempty(first_flag)
    first_flag = true;
end

if first_flag 
    first_flag = false;
    colors = 0.2*ones(track.nr_seg, 3); % <= Gray lanes
    lw = 3;
    arrowlen = 5000;
    textoffset = 3500;
    axisinfo = [inf -inf inf -inf];
    for i = fliplr(1:track.nr_seg)
        % reverse order
        curr_pos = track.seg{i}.startpos;
        curr_bd = track.seg{i}.bd;
        curr_type = track.seg{i}.type;
        curr_color = colors(i, :);
        ps = track.seg{i}.p;
        % Corners
        p1 = ps(1, :); p2 = ps(2, :); p3 = ps(3, :); p4 = ps(4, :);
        % Fiell
        fill(curr_bd(:, 1), curr_bd(:, 2), 0.6*[1 1 1]);
        % Lanes
        nr_lane = track.nr_lane;
        switch curr_type
            case 'straight'
                for j = 1:nr_lane - 1
                    a = j/(nr_lane)*p4 + (nr_lane-j)/(nr_lane)*p1;
                    b = j/(nr_lane)*p3 + (nr_lane-j)/(nr_lane)*p2;
                    xs = [a(1) a(2)]; ys = [b(1) b(2)];
                    plot([a(1) b(1)], [a(2) b(2)], '-', 'Color', 'y', 'LineWidth', 2);
                end
            case 'right_turn'
                l1 = track.seg{i}.l1;
                l2 = flipud(track.seg{i}.l2);
                for j = 1:nr_lane - 1
                    ltemp = j/(nr_lane)*l1 + (nr_lane-j)/(nr_lane)*l2;
                    xs = ltemp(:, 1); ys = ltemp(:, 2);
                    plot(ltemp(:, 1), ltemp(:, 2), '-', 'Color', 'y', 'LineWidth', 2);
                end
            case 'left_turn'
                l1 = track.seg{i}.l1;
                l2 = flipud(track.seg{i}.l2);
                for j = 1:nr_lane - 1
                    ltemp = j/(nr_lane)*l1 + (nr_lane-j)/(nr_lane)*l2;
                    plot(ltemp(:, 1), ltemp(:, 2), '-', 'Color', 'y', 'LineWidth', 2);
                end
        end
        % Start position
        plot_arrow(curr_pos(1:2), arrowlen/2, curr_pos(3), curr_color, 3);
        % Boudnary
        plot(curr_bd(:, 1), curr_bd(:, 2), '-', 'LineWidth', lw, 'Color', curr_color);
        % Center position for turn
        switch curr_type
            case 'straight'
            case 'right_turn'
                curr_centerpos = track.seg{i}.centerpos;
                plot(curr_centerpos(1), curr_centerpos(2), 'x', 'LineWidth', 2 ...
                    , 'MarkerSize', 15, 'Color', curr_color);
            case 'left_turn'
                curr_centerpos = track.seg{i}.centerpos;
                plot(curr_centerpos(1), curr_centerpos(2), 'x', 'LineWidth', 2 ...
                    , 'MarkerSize', 15, 'Color', curr_color);
        end
        % Get axis info from 'curr_bd'
        xs = curr_bd(:, 1);
        ys = curr_bd(:, 2);
        xmin = min(xs); xmax = max(xs);
        ymin = min(ys); ymax = max(ys);
        if xmin < axisinfo(1)
            axisinfo(1) = xmin;
        end
        if xmax > axisinfo(2)
            axisinfo(2) = xmax;
        end
        if ymin < axisinfo(3)
            axisinfo(3) = ymin;
        end
        if ymax > axisinfo(4)
            axisinfo(4) = ymax;
        end
    end
    
    % TEXT
    for i = fliplr(1:track.nr_seg)
        curr_pos = track.seg{i}.startpos;
        text_pos = curr_pos(1:2) + textoffset*[cos(curr_pos(3)*pi/180) sin(curr_pos(3)*pi/180)];
        if i == 1
            text(text_pos(1), text_pos(2), sprintf('Start'), 'FontSize', 18 ...
                , 'HorizontalAlignment', 'Left', 'Color', 'r');
        else
        end
    end
    % START LANE
    startp1 = track.seg{1}.p(1, :);
    startp4 = track.seg{1}.p(4, :);
    plot([startp1(1) startp4(1)], [startp1(2) startp4(2)], 'r-', 'LineWidth', 4);
else
    % DO NOTHING
end
function plot_demo_maketrack(track, mycar, info, tick, sec, emsec_total, mode)

persistent fist_flag h
if isempty(fist_flag)
    fist_flag = true;
end

if isequal(computer, 'MACI64')
    title_fs = 18; % Font Size
else
    title_fs = 14; % Font Size
end
mycar.postemp = mycar.pos;
car_traj = zeros(5, 3);
car_trajbd = cell(5, 1);
for i = 1:5
    mycar.postemp = update_pos(mycar.postemp, mycar.vel, 0.2);
    car_traj(i, :) = mycar.postemp;
    car_trajbd{i} = get_carshape(mycar.postemp, mycar.W, mycar.H);
end

% My car boundary
mycar_bd = get_carshape(mycar.pos, mycar.W, mycar.H);

% MY CAR GRID
rszwh  = [100 200];
carpos = mycar.pos;
carwh  = [mycar.W*1.5 mycar.H*1.3];
[xmesh_grid, ymesh_grid] = get_carmeshgred(carpos, carwh, rszwh);

set(gcf,'Color', [0.6, 0.9, 0.8]/4 );

% Title
info_str = sprintf('[%s] [%d] %.2fsec (%.2fms) %.1fkm/h %.1fdeg/s \n %d-Seg %d-Lane/ dev: %.2fm (%.2fm) / GeoD: %.2fm / deg: %.1fdeg \n ForwardBackward Left: (%.1fm, %.1fm) Center: (%.1fm, %.1fm) Right: (%.1fm, %.1fm)' ...
    , mode.str, tick, sec, emsec_total, mycar.vel(1)/1000/1000*60*60, mycar.vel(2) ...
    , info.seg_idx, info.lane_idx, info.dev/1000, info.lane_dev/1000, info.dist/1000, info.deg ...
    , info.left_fb_dists(1)/1000, info.left_fb_dists(2)/1000, info.center_fb_dists(1)/1000, info.center_fb_dists(2)/1000, info.right_fb_dists(1)/1000, info.right_fb_dists(2)/1000 ...
    );

% Plot
pred_hor = 5;
if fist_flag
    fist_flag = false;
    
    % Plot track
    axisinfo = plot_track(track);
    
    % Future pos of the robot
    h.cartraj = cell(pred_hor, 1);
    for i = 1:pred_hor
        [h1, h2, h3] = plot_arrow(car_traj(i, 1:2), 2000, car_traj(i, 3) , 'k', 1);
        h.cartraj{i} = [h1 h2 h3];
        h.cartrajbd{i} = plot(car_trajbd{i}(:, 1), car_trajbd{i}(:, 2), 'k', 'LineWidth', 1);
    end
    
    % CAR
    if 0
        h.carfill = fill(mycar_bd(:, 1), mycar_bd(:, 2), 'g');
        h.carbd = plot(mycar_bd(:, 1), mycar_bd(:, 2), 'k', 'LineWidth', 3);
        [h1, h2, h3] = plot_arrow(mycar.pos, 2000, mycar.pos(3), 'k', 3);
        h.cararrow = [h1 h2 h3];
    else
        [carimg, ~, cartr] = imread('imgs/bluecar.png');
        carrsz = imresize(carimg, rszwh);
        trrsz  = imresize(cartr, rszwh);
        h.carsurf = surf('xdata', xmesh_grid, 'ydata', ymesh_grid ...
            , 'zdata', zeros(rszwh(1), rszwh(2)) ...
            , 'cdata', carrsz, 'AlphaData', trrsz ...
            , 'FaceAlpha', 'texture' ...
            , 'FaceColor', 'texturemap' ...
            , 'EdgeColor','None', 'LineStyle', 'None');
    end
    
    % X, Y Axis
    xmin = axisinfo(1);
    ymin = axisinfo(3);
    plot([xmin xmin], [ymin ymin + 10000], 'w-', 'LineWidth', 3);
    plot([xmin xmin + 10000], [ymin ymin], 'w-', 'LineWidth', 3);
    text(xmin+12000, ymin-2000, 'X 10m', 'FontSize', 15, 'Color', 'w', 'HorizontalAlignment', 'Center')
    text(xmin, ymin+12000, 'Y 10m', 'FontSize', 15, 'Color', 'w', 'HorizontalAlignment', 'Center')
    
    % ETC
    switch mode.flag
        case 0
            h.title = title(sprintf('%s', info_str), 'FontSize', title_fs, 'Color', 'k');
        case 1
            h.title = title(sprintf('%s', info_str), 'FontSize', title_fs, 'Color', 'k');
    end
    axis equal; axis(axisinfo); % grid on;
    axis off;
    xlabel('X [mm]', 'FontSize', 15); ylabel('Y [mm]', 'FontSize', 15);
    
else
    % Future pos
    for i = 1:pred_hor
        [x1, y1, x2, y2, x3, y3] = get_arrow(car_traj(i, 1:2), 2000, car_traj(i, 3) , 'k', 1);
        h.cartraj{i}(1).XData = x1; h.cartraj{i}(1).YData = y1;
        h.cartraj{i}(2).XData = x2; h.cartraj{i}(2).YData = y2;
        h.cartraj{i}(3).XData = x3; h.cartraj{i}(3).YData = y3;
        h.cartrajbd{i}.XData = car_trajbd{i}(:, 1);
        h.cartrajbd{i}.YData = car_trajbd{i}(:, 2);
    end
    
    % CAR
    if 0
        h.carfill.Vertices = mycar_bd;
        h.carbd.XData = mycar_bd(:, 1); h.carbd.YData = mycar_bd(:, 2);
        [x1, y1, x2, y2, x3, y3] = get_arrow(mycar.pos, 2000, mycar.pos(3), 'k', 3);
        h.cararrow(1).XData = x1; h.cararrow(1).YData = y1;
        h.cararrow(2).XData = x2; h.cararrow(2).YData = y2;
        h.cararrow(3).XData = x3; h.cararrow(3).YData = y3;
    else
        h.carsurf.XData = xmesh_grid;
        h.carsurf.YData = ymesh_grid;
    end
    
    % ETC
    h.title.String = info_str;
    switch mode.flag
        case -1
            h.title.Color = 'r';
        case 0
            h.title.Color = 'y';
        case 1
            h.title.Color = 'w';
    end
end




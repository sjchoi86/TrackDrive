function ems = plot_axisinfo(axisinfo)
persistent first_flag
if isempty(first_flag)
    first_flag = true;
end

SHOW_AXIS = 1;

com = computer;
if isequal(com(1:3), 'MAC')
    fs = 24;
else
    fs = 15;
end
col = [0.7 0.9 0.7];

iclk = clock;
if first_flag
    first_flag = false;
    if SHOW_AXIS
        xmin = axisinfo(1);
        ymin = axisinfo(3);
        plot([xmin xmin], [ymin ymin + 10000], '-', 'LineWidth', 3, 'Color', col);
        plot([xmin xmin + 10000], [ymin ymin], '-', 'LineWidth', 3, 'Color', col);
        text(xmin+8300, ymin-1000, 'X 10m', 'FontSize', fs, 'Color', col ...
            , 'HorizontalAlignment', 'Center')
        h = text(xmin-1000, ymin+8000, 'Y 10m', 'FontSize', fs, 'Color', col ...
            , 'HorizontalAlignment', 'Center');
        set(h, 'rotation', 90)
    end
    axis equal; axis(axisinfo); axis off;
else
    % DO NOTHING
end
ems = etime(clock, iclk)*1000;

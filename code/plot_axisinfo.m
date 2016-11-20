function plot_axisinfo(axisinfo)
persistent first_flag
if isempty(first_flag)
    first_flag = true;
end

if first_flag
    first_flag = false;
    xmin = axisinfo(1);
    ymin = axisinfo(3);
    plot([xmin xmin], [ymin ymin + 10000], 'w-', 'LineWidth', 3);
    plot([xmin xmin + 10000], [ymin ymin], 'w-', 'LineWidth', 3);
    text(xmin+12000, ymin-2000, 'X 10m', 'FontSize', 15, 'Color', 'w', 'HorizontalAlignment', 'Center')
    text(xmin, ymin+12000, 'Y 10m', 'FontSize', 15, 'Color', 'w', 'HorizontalAlignment', 'Center')
    axis equal; axis(axisinfo); axis off;
    xlabel('X [mm]', 'FontSize', 15); ylabel('Y [mm]', 'FontSize', 15);
else
    % DO NOTHING
end

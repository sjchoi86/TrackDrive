function [x1, y1, x2, y2, x3, y3] = get_arrow(fr, dist, deg, color, thick)

if nargin == 3
    color = 'k';
    thick = 2;
end
if nargin == 4
    thick = 2;
end

arrow_rate = 1/3;

rad  = deg * pi / 180;
fr_x = fr(1);
fr_y = fr(2);
to_x = fr_x + dist*cos(rad);
to_y = fr_y + dist*sin(rad);

c_x = fr_x + (1-arrow_rate)*dist*cos(rad);
c_y = fr_y + (1-arrow_rate)*dist*sin(rad);

l_x = c_x + arrow_rate*dist*cos(rad+pi/2);
l_y = c_y + arrow_rate*dist*sin(rad+pi/2);
r_x = c_x + arrow_rate*dist*cos(rad-pi/2);
r_y = c_y + arrow_rate*dist*sin(rad-pi/2);

% h1 = plot([fr_x to_x], [fr_y to_y], 'LineWidth', thick ...
%     , 'Color', color);
% h2 = plot([l_x to_x], [l_y to_y], 'LineWidth', thick ...
%     , 'Color', color);
% h3 = plot([r_x to_x], [r_y to_y], 'LineWidth', thick ...
%     , 'Color', color);

x1 = [fr_x to_x];
y1 = [fr_y to_y];
x2 = [l_x to_x];
y2 = [l_y to_y];
x3 = [r_x to_x];
y3 = [r_y to_y];


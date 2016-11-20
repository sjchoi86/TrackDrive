function plot_saver(saver)
persistent first_flag h
if isempty(first_flag)
    first_flag = 1;
end
% PREPROCESS PLOT
carpos = zeros(saver.n, 2);
for i = 1:saver.n
    carpos(i, :) = saver.mycar{i}.pos(1:2);
end
% ACTUAL PLOT
if first_flag || isempty(h.carpos)
    first_flag = 0;
    h.carpos = plot(carpos(:, 1), carpos(:, 2), 'bo' ...
        , 'MarkerSize', 8, 'LineWidth', 2);
else
    h.carpos.XData = carpos(:, 1);
    h.carpos.YData = carpos(:, 2);
end

function plot_traj(traj)
% PLOT SAVED TRAJECTORIES
persistent fist_flag h
if isempty(fist_flag)
    fist_flag = true;
end

n = traj.data.n;
poslist = zeros(n, 3);
for i = 1:n
    poslist(i, :) = traj.data.mycar{i}.pos;
end
xs = poslist(:, 1);
ys = poslist(:, 2);

if fist_flag
    fist_flag = false;
    h.plot = plot(xs, ys, 'o', 'MarkerSize', 13, 'Color', 'w');
else 
    h.plot.XData = xs;
    h.plot.YData = ys;
end

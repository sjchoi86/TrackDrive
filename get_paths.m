function [paths, ctrls] = get_paths(pos, n, K, vrange, wrange, T)

paths = zeros(3*n, K);
ctrls = zeros(n, 2);
for i = 1:n % for each path
    path = zeros(3, K);
    path(:, 1) = pos';
    v = vrange(1) + (vrange(2)-vrange(1))*rand;
    w = wrange(1) + (wrange(2)-wrange(1))*rand;
    ctrls(i, :) = [v w];
    for j = 2:K
        x = path(1, j-1); y = path(2, j-1); d = path(3, j-1);
        c = cos(d*pi/180); s = sin(d*pi/180);
        path(1, j) = x + T*v*c; 
        path(2, j) = y + T*v*s; 
        path(3, j) = d + T*w;
    end
    paths(3*i-2:3*i, :) = path(1:3, :);
end


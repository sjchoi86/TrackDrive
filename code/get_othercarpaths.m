function [paths, ctrls] = get_othercarpaths(pos, N, K, vrange, wrange, T)

paths = zeros(3*N, K);
ctrls = zeros(2*N, K);
for i = 1:N % for each path
    ctrl = zeros(2, K);
    path = zeros(3, K);
    
    if i == 1
        v = vrange(2);
        w = 0;
    else
        v = vrange(1) + (vrange(2)-vrange(1))*rand;
        w = wrange(1) + (wrange(2)-wrange(1))*rand;
    end
    
    ctrl(:, 1) = [v w]';
    path(:, 1) = pos';
    
    for j = 2:K
        x = path(1, j-1); y = path(2, j-1); d = path(3, j-1);
        c = cos(d*pi/180); s = sin(d*pi/180);
        path(1, j) = x + T*v*c;
        path(2, j) = y + T*v*s;
        path(3, j) = d + T*w;
        
        ctrl(1, j) = v;
        ctrl(2, j) = w;
    end
    
    ctrls(2*i-1:2*i, :) = ctrl;
    paths(3*i-2:3*i, :) = path(1:3, :);
end


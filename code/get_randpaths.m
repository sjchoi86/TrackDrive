function [paths, ctrls, N, K] = get_randpaths(pos)

v1 = 15000; % 36  km/h

K     = 30;   % 50 
Tbase = 0.01; 
w1    = 40*rand;
w2    = 40 + 50*rand;
w3    = 120 + 50*rand;
w4    = 150 + 30*rand;
ctrllist = { [v1 0] ...
      [v1 w1], [v1 -w1], [v1 w2], [v1 -w2] ...
    , [v1 w3], [v1 -w3], [v1 w4], [v1 -w4] ...
    , [v1 w1 ; v1 -w1], [v1 -w1 ; v1 w1] ... 
    , [v1 w2 ; v1 -w2], [v1 -w2 ; v1 w2] ...
    , [v1 w3 ; v1 -w3], [v1 -w3 ; v1 w3] ... 
    , [v1 w4 ; v1 -w4], [v1 -w4 ; v1 w4] ... 
    }; 

N = length(ctrllist);
for i = 1:N % FOR EACH RANDOM PATH
    ctrl = zeros(2, K);
    path = zeros(3, K);
    
    currctrl = ctrllist{i};
    nctrl = size(currctrl, 1);
    v = currctrl(1, 1);
    w = currctrl(1, 2);
    
    if v <= v1, T = Tbase;
    else T = Tbase/2; end;
    
    ctrl(:, 1) = [v w]';
    path(:, 1) = pos';
    for j = 2:K 
        if nctrl == 2 && j == round(K/2)
            v = currctrl(2, 1);
            w = currctrl(2, 2);
        end
        x = path(1, j-1); y = path(2, j-1); d = path(3, j-1);
        c = cos(d*pi/180); s = sin(d*pi/180);
        path(1, j) = x + T*v*c;
        path(2, j) = y + T*v*s;
        path(3, j) = d + T*w;
        
        ctrl(1, j) = v;
        ctrl(2, j) = w;
    end
    
    % Save
    ctrls(2*i-1:2*i, :) = ctrl;
    paths(3*i-2:3*i, :) = path(1:3, :);
end

function [paths, ctrls, N, K] = get_predefinedpaths(pos)

v1 = 10000; % 36  km/h
v2 = 20000; % 72  km/h
v3 = 30000; % 108 km/h

w1 = 40;
w2 = 60;
w3 = 100;
K  = 40;

ctrllist = {[0 0], [v1 0], [v2 0], [v3 0] ...
    , [v1 w1], [v1 -w1], [v1 w2], [v1 -w2], [v1 w3], [v1 -w3] ...
    , [v2 w3], [v2 -w3], [v3 w3], [v3 -w3] ...
    , [v1 w1 ; v1 -w1], [v1 -w1 ; v1 w1] ...
    , [v1 w2 ; v1 -w2], [v1 -w2 ; v1 w2] ...
    , [v1 w3 ; v1 -w3], [v1 -w3 ; v1 w3] ... 
    , [v2 w1], [v2 -w1], [v2 w2], [v2 -w2], [v2 w3], [v2 -w3] ...   
    , [v2 w1 ; v2 -w1], [v2 -w1 ; v2 w1] ...
    , [v2 w2 ; v2 -w2], [v2 -w2 ; v2 w2] ...
    , [v2 w3 ; v2 -w3], [v2 -w3 ; v2 w3] ...'
    , [v3 w3 ; v3 -w3], [v3 -w3 ; v3 w3] ... 
    }; 

N = length(ctrllist);
Tbase = 0.02;
for i = 1:N
    ctrl = zeros(2, K);
    path = zeros(3, K);
    
    currctrl = ctrllist{i};
    nctrl = size(currctrl, 1);
    v = currctrl(1, 1);
    w = currctrl(1, 2);
    if w~= 0, w = w+10*rand; end;
    
    if v <= v1, T = Tbase;
    else T = Tbase/2; end;
    
    ctrl(:, 1) = [v w]';
    path(:, 1) = pos';
    for j = 2:K
        if nctrl == 2 && j == round(K/2)
            v = currctrl(2, 1);
            w = currctrl(2, 2);
            if w~= 0, w = w+10*rand; end;
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

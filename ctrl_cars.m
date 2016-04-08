function [othercars, emsec] = ctrl_cars(othercars, track)
iclk = clock;

for i = 1:othercars.n
    ctrlmode = othercars.car{i}.ctrlmode;
    carpos   = othercars.car{i}.pos;
    switch ctrlmode
        case 'normal'
            forv = 5000; % <= Forward veloicty [mm/s]
            % Random paths
            N = 5; K = 4; T = 0.3;
            [paths, ctrls] = get_paths(carpos, N, K, [forv/2 forv], [-50 50], T);
            % Compute cost of each path
            npath = size(paths, 1)/3;
            costs = zeros(npath, 1);
            for j = 1:npath
                cpath = paths(3*j-2:3*j, :)';
                cost = 0;
                for k = 4:K
                    cpos  = cpath(k, :);
                    cinfo = get_trackinfo(track, cpos); 
                    cost  = cost + cinfo.lane_dev^2;
                end
                costs(j) = cost;
            end
            [~, minidx] = min(costs);
            optpath = paths(3*minidx-2:3*minidx, :);
            othercars.car{i}.paths = []; % paths: all paths / optpath: optimal path / []: none
            
            % Velocity
            othercars.car{i}.vel = ctrls(minidx, :);
    end
end

emsec = etime(clock, iclk)*1000;

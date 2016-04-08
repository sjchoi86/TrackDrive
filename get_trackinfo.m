function [info, emsec] = get_trackinfo(track, car_pos, othercars)

iclk = clock;
maxdist2car = 100*1000; % <= maximum distance we will care about (100m)

seg_idx = -1;
for i = 1:track.nr_seg
    curr_bd = track.seg{i}.bd;
    if inpolygon(car_pos(1), car_pos(2), curr_bd(:, 1), curr_bd(:, 2))
        seg_idx = i;
        break;
    end
end

info.seg_idx = seg_idx;

% If car_pos is inside the track,
% 1) compute dist from center / 2) compute geodesic dist
if seg_idx > 0
    seg = track.seg{seg_idx};
    info.seg = seg;
    info.type = seg.type;
    info.startpos = seg.startpos;
    prev_dist = 0;
    for i = 1:seg_idx - 1
        prev_dist = prev_dist + track.seg{i}.len;
    end
    switch info.type
        case 'straight'
            % deviation
            a = seg.startpos(1:2);
            b = seg.endpos(1:2);
            x = car_pos(1:2);
            info.dev = get_distfrpnt2line(x, a, b);
            % distance
            a = seg.p(1, :);
            b = seg.p(4, :);
            info.dist = prev_dist + get_distfrpnt2line(x, a, b);
            % degree
            car_d = car_pos(3);
            seg_d = seg.startpos(3);
            info.deg = mod(car_d - seg_d + 180, 360) - 180;
        case 'right_turn'
            org = seg.centerpos(1:2);
            pntA = seg.startpos(1:2);
            pntB = car_pos(1:2);
            deg_diff = get_degbtwlines(org, pntA, pntB);
            info.deg = mod(seg.startpos(3) + 90 + deg_diff, 360); % wrt seg.centerpos
            info.r   = norm(org - car_pos(1:2));
            info.dev = seg.d - info.r;
            % distance
            curr_dist = 2*pi*seg.d*abs(deg_diff)/360;
            info.dist = prev_dist + curr_dist;
            % degree
            car_d = car_pos(3);
            seg_d = seg.startpos(3) - abs(deg_diff);
            info.deg = mod(car_d - seg_d + 180, 360) - 180;
        case 'left_turn'
            org = seg.centerpos(1:2);
            pntA = seg.startpos(1:2);
            pntB = car_pos(1:2);
            deg_diff = get_degbtwlines(org, pntA, pntB);
            info.deg = mod(seg.startpos(3) - 90 + deg_diff, 360); % wrt seg.centerpos
            info.r   = norm(org - car_pos(1:2));
            info.dev = info.r - seg.d;
            % distance
            info.dist = prev_dist + 2*pi*seg.d*abs(deg_diff)/360;
            % degree
            car_d = car_pos(3);
            seg_d = seg.startpos(3) + abs(deg_diff);
            info.deg = mod(car_d - seg_d + 180, 360) - 180;
    end
    
    % Lane idx
    nr_lane = track.nr_lane;
    width = seg.width;
    dev = info.dev;
    unit_len = width / nr_lane;
    lane_idx = ceil( (dev+width/2) / unit_len);
    info.lane_idx = lane_idx;
    
    % Lane deviation
    temp = info.dev + width/2;
    temp2 = mod(temp, unit_len);
    temp3 = temp2 - unit_len/2;
    info.lane_dev = temp3;
    
    if nargin == 3  % <= This is for get info of mycar!!
        % To other cars
        curr_lane = info.lane_idx;
        left_lane = curr_lane  - 1;
        right_lane = curr_lane + 1;
        cars_in_left_dists   = [];
        cars_in_left_idxs    = [];
        cars_in_right_dists  = [];
        cars_in_right_idxs   = [];
        cars_in_center_dists = [];
        cars_in_center_idxs  = [];
        
        total_track_dist = 0;
        for i = 1:track.nr_seg
            total_track_dist = total_track_dist + track.seg{i}.len;
        end
        
        for i = 1:othercars.n
            % For all other cars, check which lane they are at
            othercarpos = othercars.car{i}.pos;
            othercarinfo = get_trackinfo(track, othercarpos); % <= recursive function / not that readable..
            othercarlane = othercarinfo.lane_idx;
            othercardist = othercarinfo.dist;
            dist_diff = othercardist  - info.dist ;
            dist_diff2 = mod(dist_diff + total_track_dist/2, total_track_dist) -total_track_dist/2;
            switch othercarlane
                case curr_lane
                    cars_in_center_idxs  = [cars_in_center_idxs ; i];
                    cars_in_center_dists = [cars_in_center_dists ; dist_diff2];
                case left_lane
                    cars_in_left_idxs  = [cars_in_left_idxs ; i];
                    cars_in_left_dists = [cars_in_left_dists ; dist_diff2];
                case right_lane
                    cars_in_right_idxs  = [cars_in_right_idxs ; i];
                    cars_in_right_dists = [cars_in_right_dists ; dist_diff2];
            end
        end
        % Center lane
        temp = cars_in_center_dists;
        temp(temp < 0) = inf;
        centerfw = min(min(temp), maxdist2car);
        temp = cars_in_center_dists;
        temp(temp > 0) = -inf;
        centerbw = min(min(-temp), maxdist2car);
        
        % Left lane
        temp = cars_in_left_dists;
        temp(temp < 0) = inf;
        leftfw = min(min(temp), maxdist2car);
        temp = cars_in_left_dists;
        temp(temp > 0) = -inf;
        leftbw = min(min(-temp), maxdist2car);
        
        % Right lane
        temp = cars_in_right_dists;
        temp(temp < 0) = inf;
        rightfw = min(min(temp), maxdist2car);
        temp = cars_in_right_dists;
        temp(temp > 0) = -inf;
        rightbw = min(min(-temp), maxdist2car);
        
        if isempty(centerfw), centerfw = maxdist2car; end;
        if isempty(centerbw), centerbw = maxdist2car; end;
        if isempty(leftfw), leftfw = maxdist2car; end;
        if isempty(leftbw), leftbw = maxdist2car; end;
        if isempty(rightfw), rightfw = maxdist2car; end;
        if isempty(rightbw), rightbw = maxdist2car; end;
        
        info.center_fb_dists = [centerfw centerbw];
        info.left_fb_dists = [leftfw leftbw];
        info.right_fb_dists = [rightfw rightbw];
    end
    
    
else
    info.lane_idx = -1;
    info.dev  = nan;
    info.dist = nan;
    info.deg  = nan;
    info.lane_dev = nan;
    
    info.center_fb_dists = [maxdist2car maxdist2car];
    info.left_fb_dists = [maxdist2car maxdist2car];
    info.right_fb_dists = [maxdist2car maxdist2car];
end

% Time
emsec = etime(clock, iclk)*1000;
info.emsec = emsec;



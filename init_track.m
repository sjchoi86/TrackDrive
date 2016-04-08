function track = init_track(nr_lane) 

if nargin == 0
    nr_lane = 4;
end

max_seg = 100;
track.nr_seg = 0;
track.nr_lane = nr_lane;
track.seg = cell(max_seg, 1);
for i = 1:max_seg
    track.seg{i}.type = '';           % straight, right_turn, left_turn
    track.seg{i}.width = 0;           % width [mm]
    track.seg{i}.startpos = [0 0 0];  % start position
    track.seg{i}.endpos = [0 0 0];    % end position
    track.seg{i}.d = 0;               % straight: segment distance / turn: radius
    track.seg{i}.bd = [];             % boundary
end

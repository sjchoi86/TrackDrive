function track = init_track(nr_lane, width, type)

max_seg = 100;
track.nr_seg = 0;
track.nr_lane = nr_lane;
track.width = width;
track.lane_width = width/nr_lane;
track.seg = cell(max_seg, 1);
for i = 1:max_seg
    track.seg{i}.type = '';           % straight, right_turn, left_turn
    track.seg{i}.width = 0;           % width [mm]
    track.seg{i}.startpos = [0 0 0];  % start position
    track.seg{i}.endpos = [0 0 0];    % end position
    track.seg{i}.d = 0;               % straight: segment distance / turn: radius
    track.seg{i}.bd = [];             % boundary
end

track.xmin = inf;
track.ymin = inf;
track.xmax = -inf;
track.ymax = -inf;

switch type
    case 'empty'
        
    case 'simple'
        track  = add_segment(track, 'straight', track.width, 30000);
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 10000);
    case 'complex'
        track  = add_segment(track, 'straight', track.width, 40000);
        track  = add_segment(track, 'right_turn', track.width, 20000);
        track  = add_segment(track, 'right_turn', track.width, 20000);
        track  = add_segment(track, 'left_turn', track.width, 20000);
        track  = add_segment(track, 'right_turn', track.width, 20000);
        track  = add_segment(track, 'right_turn', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 40000);
        track  = add_segment(track, 'right_turn', track.width, 20000);
    otherwise
        
end

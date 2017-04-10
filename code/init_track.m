function track = init_track(nr_lane, lane_width, tracktype)
% INITIALIZE TRACK
max_seg = 100;
track.nr_seg     = 0;
track.nr_lane    = nr_lane;
track.lane_width = lane_width;
track.width      = lane_width*nr_lane;
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

% ADD LANES
switch lower(tracktype)
    case ''
        % DO NOTHING
    case 'simple'
        % CURVED TRACK
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'right_turn', track.width, 10000);
        track  = add_segment(track, 'right_turn', track.width, 10000);
        track  = add_segment(track, 'left_turn', track.width, 10000);
        track  = add_segment(track, 'right_turn', track.width, 10000);
        track  = add_segment(track, 'right_turn', track.width, 10000);
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'right_turn', track.width, 10000);
    case 'manual_collect'
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 20000);
        track  = add_segment(track, 'straight', track.width, 20000);
    case 'test'
        % CURVED TRACK
        track  = add_segment(track, 'straight', track.width, 30000);
        track  = add_segment(track, 'right_turn', track.width, 15000);
        track  = add_segment(track, 'right_turn', track.width, 15000);
        track  = add_segment(track, 'left_turn', track.width, 15000);
        track  = add_segment(track, 'right_turn', track.width, 15000);
        track  = add_segment(track, 'right_turn', track.width, 15000);
        track  = add_segment(track, 'straight', track.width, 30000);
        track  = add_segment(track, 'right_turn', track.width, 15000);
    otherwise
        fprintf(2, 'TRACKTYPE [%s] IS NOT DEFINED.n', upper(tracktype));
end

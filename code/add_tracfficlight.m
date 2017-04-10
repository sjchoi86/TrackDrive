function track = add_tracfficlight(track, tl_lane_idx, tf_period)


if isequal(track.seg{tl_lane_idx}.type, 'straight')
    
    p2 = track.seg{tl_lane_idx}.p(2, :);
    p3 = track.seg{tl_lane_idx}.p(3, :);
    mid = 0.5*p2 + 0.5*p3;
    tl_feat = get_trackinfo(track, [mid 0]);
    
    
    track.traffic.lane_idx = tl_lane_idx;
    track.traffic.period   = tf_period;
    track.traffic.type = 'g'; % 'g' / 'y' / 'r'
    track.traffic.dist = tl_feat.dist;
else
    fprintf(2, 'CURRENT TRAFFIC LIGHT CAN ONLY BE ADDED TO STRAIGHT LANES. \n');
end

function feat = get_feat(info, ctrl)

if nargin == 0
     feat = 5;
     return
end

lf_dist = info.left_fb_dists(1);
cf_dist = info.center_fb_dists(1);
rf_dist = info.right_fb_dists(1);

feat = [info.lane_dev, info.deg, lf_dist, cf_dist, rf_dist];

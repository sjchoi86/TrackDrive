function feat = get_feat(myinfo)

lf_dist = myinfo.left_fb_dists(1);
cf_dist = myinfo.center_fb_dists(1);
rf_dist = myinfo.right_fb_dists(1);
lane_devdeg  = myinfo.deg;
lane_devdist = myinfo.lane_dev;

feat = [lf_dist, cf_dist, rf_dist, lane_devdeg, lane_devdist];


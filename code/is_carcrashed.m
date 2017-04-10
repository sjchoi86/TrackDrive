function flag = is_carcrashed(myinfo)

dists = [ ...
    myinfo.center_fb_dists(1), ...
    ];
dists(dists==0) = 10000;
mindist = min(dists);

if mindist < 2500
    flag = 1;
else
    flag = 0;
end

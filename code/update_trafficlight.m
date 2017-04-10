function track = update_trafficlight(track, sim)

tl_period = track.traffic.period;
sumperiod = sum(tl_period);
sec = mod(sim.sec, sumperiod);

if sec < tl_period(1)
    track.traffic.type = 'g';
elseif sec < (tl_period(1)+tl_period(2))
    track.traffic.type = 'y';
else
    track.traffic.type = 'r';
end
function pos = get_posintrack(track, nseg, distoff, nlane, offdeg)

prev_dist = 0;
for i = 1:nseg
     prev_dist = prev_dist + track.seg{i}.len;
end

% Center of lane
pos = track.seg{nseg}.startpos;

% Offset to Lane center 
cseg = track.seg{nseg};
width = cseg.width;
unitwidth = width / track.nr_lane;

temp = -width/2 + unitwidth*(nlane-1) + unitwidth/2;
temp = -temp;

lane_deg = pos(3); c = cos(lane_deg*pi/180); s = sin(lane_deg*pi/180);
pos(1) = pos(1) - temp*s;
pos(2) = pos(2) + temp*c;

% Add offset degree
pos(3) = pos(3) + offdeg;

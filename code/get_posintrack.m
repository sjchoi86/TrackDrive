function pos = get_posintrack(track, nseg, distoff, nlane, offdeg)

prev_dist = 0;
for i = 1:nseg
     prev_dist = prev_dist + track.seg{i}.len;
end

% Offset to Lane center 
cseg = track.seg{nseg};
width = cseg.width;
unitwidth = width / track.nr_lane;

% ADD DIST OFFSET
switch cseg.type
    case 'straight'
        pos = track.seg{nseg}.startpos;
        cseg = track.seg{nseg};
        width = cseg.width;
        unitwidth = width / track.nr_lane;
        temp = width/2 - unitwidth*(nlane-1) - unitwidth/2;
        lane_deg = pos(3); c = cos(lane_deg*pi/180); s = sin(lane_deg*pi/180);
        pos(1) = pos(1) - temp*s;
        pos(2) = pos(2) + temp*c;  
        % ---------------------
        c = cos(cseg.startpos(3)*pi/180);
        s = sin(cseg.startpos(3)*pi/180);
        dir_vector = [c s];
        pos(1:2) = pos(1:2) + distoff*dir_vector;
        pos(3) = pos(3) + offdeg; 
    case 'right_turn'
        centerpos = cseg.centerpos;
        real_r = cseg.d + cseg.width/2 - unitwidth/2 - unitwidth*(nlane-1);
        offset_deg = 360*distoff/(2*pi*real_r);
        
        if offset_deg > 90, offset_deg = 90;
        elseif offset_deg < -90, offset_deg = -90; 
        end
        start_deg = -270 + cseg.startpos(3);
        next_deg = start_deg - offset_deg;
        next_c = cos(next_deg*pi/180);
        next_s = sin(next_deg*pi/180);
        pos(1:2) = centerpos + real_r*[next_c next_s];
        pos(3) = cseg.startpos(3) - offset_deg + offdeg; 
    case 'left_turn' 
        centerpos = cseg.centerpos;
        real_r = cseg.d - cseg.width/2 + unitwidth/2 + unitwidth*(nlane-1);
        offset_deg = 360*distoff/(2*pi*real_r);
        start_deg = -90 - cseg.startpos(3);
        next_deg = start_deg + offset_deg;
        next_c = cos(next_deg*pi/180);
        next_s = sin(next_deg*pi/180);
        pos(1:2) = centerpos + real_r*[next_c next_s];
        pos(3) = cseg.startpos(3) + offset_deg + offdeg;
end

% ADD A SMALL OFFSET TO X AXIS FOR ENSURING THE CAR TO BE INSIDE THE TRACK
eps = 1E-2;
pos(1) = pos(1) + eps;





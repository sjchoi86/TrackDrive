function lane = add_segment(lane, type, width, d)

n = lane.nr_seg + 1;
lane.nr_seg = n;

if n == 1
    prev_pos = [0 0 0];
else
    prev_pos = lane.seg{n-1}.endpos;
end

switch type
    case 'straight'
        lane.seg{n}.type     = type;
        lane.seg{n}.width    = width;
        lane.seg{n}.d        = d;
        lane.seg{n}.startpos = prev_pos;
        % Compute end position
        startpos = lane.seg{n}.startpos;
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        nextxy = currxy + d*[c s]; nextdeg = currdeg;
        lane.seg{n}.endpos = [nextxy nextdeg];
        % Compute boundary
        [lane.seg{n}.bd, p1, p2, p3, p4] = get_bd4straight(startpos, width, d);
        lane.seg{n}.p = [p1 ; p2 ; p3 ; p4];
        % Compute geodesic length
        lane.seg{n}.len = d;
        
    case 'right_turn'
        lane.seg{n}.type     = type;
        lane.seg{n}.width    = width;
        lane.seg{n}.d        = d;
        lane.seg{n}.startpos = prev_pos;
        % Compute center pos
        startpos = lane.seg{n}.startpos;
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        lane.seg{n}.centerpos = currxy + d*[s -c];
        % Compute end position
        endxy = currxy + d*[s+c -c+s];
        enddeg = currdeg - 90;
        lane.seg{n}.endpos = [endxy enddeg];
        % Compute boundary
        [lane.seg{n}.bd, p1, p2, p3, p4, l1, l2] = get_bd4turn(startpos, width, d, type);
        lane.seg{n}.p = [p1 ; p2 ; p3 ; p4];
        lane.seg{n}.l1 = l1;
        lane.seg{n}.l2 = l2;
        % Compute geodesic length
        lane.seg{n}.len = 0.5*pi*d;
        
    case 'left_turn'
        lane.seg{n}.type     = type;
        lane.seg{n}.width    = width;
        lane.seg{n}.d        = d;
        lane.seg{n}.startpos = prev_pos;
        % Compute center pos
        startpos = lane.seg{n}.startpos;
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        lane.seg{n}.centerpos = currxy + d*[-s +c];
        % Compute end position
        endxy = currxy + d*[-s+c +c+s];
        enddeg = currdeg + 90;
        lane.seg{n}.endpos = [endxy enddeg];
        % Compute boundary
        [lane.seg{n}.bd, p1, p2, p3, p4, l1, l2] = get_bd4turn(startpos, width, d, type);
        lane.seg{n}.p = [p1 ; p2 ; p3 ; p4];
        lane.seg{n}.l1 = l1;
        lane.seg{n}.l2 = l2;
        % Compute geodesic length
        lane.seg{n}.len = 0.5*pi*d;
        
        
end








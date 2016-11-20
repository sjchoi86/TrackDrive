function track = add_segment(track, type, width, d)

n = track.nr_seg + 1;
track.nr_seg = n;

if n == 1
    prev_pos = [0 0 0];
else
    prev_pos = track.seg{n-1}.endpos;
end

switch type
    case 'straight'
        track.seg{n}.type     = type;
        track.seg{n}.width    = width;
        track.seg{n}.d        = d;
        track.seg{n}.startpos = prev_pos;
        % Compute end position
        startpos = track.seg{n}.startpos;
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        nextxy = currxy + d*[c s]; nextdeg = currdeg;
        track.seg{n}.endpos = [nextxy nextdeg];
        % Compute boundary
        [track.seg{n}.bd, p1, p2, p3, p4] = get_bd4straight(startpos, width, d);
        track.seg{n}.p = [p1 ; p2 ; p3 ; p4];
        % Compute geodesic length
        track.seg{n}.len = d;
        
    case 'right_turn'
        track.seg{n}.type     = type;
        track.seg{n}.width    = width;
        track.seg{n}.d        = d;
        track.seg{n}.startpos = prev_pos;
        % Compute center pos
        startpos = track.seg{n}.startpos;
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        track.seg{n}.centerpos = currxy + d*[s -c];
        % Compute end position
        endxy = currxy + d*[s+c -c+s];
        enddeg = currdeg - 90;
        track.seg{n}.endpos = [endxy enddeg];
        % Compute boundary
        [track.seg{n}.bd, p1, p2, p3, p4, l1, l2] = get_bd4turn(startpos, width, d, type);
        track.seg{n}.p = [p1 ; p2 ; p3 ; p4];
        track.seg{n}.l1 = l1;
        track.seg{n}.l2 = l2;
        % Compute geodesic length
        track.seg{n}.len = 0.5*pi*d;
        
    case 'left_turn'
        track.seg{n}.type     = type;
        track.seg{n}.width    = width;
        track.seg{n}.d        = d;
        track.seg{n}.startpos = prev_pos;
        % Compute center pos
        startpos = track.seg{n}.startpos;
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        track.seg{n}.centerpos = currxy + d*[-s +c];
        % Compute end position
        endxy = currxy + d*[-s+c +c+s];
        enddeg = currdeg + 90;
        track.seg{n}.endpos = [endxy enddeg];
        % Compute boundary
        [track.seg{n}.bd, p1, p2, p3, p4, l1, l2] = get_bd4turn(startpos, width, d, type);
        track.seg{n}.p = [p1 ; p2 ; p3 ; p4];
        track.seg{n}.l1 = l1;
        track.seg{n}.l2 = l2;
        % Compute geodesic length
        track.seg{n}.len = 0.5*pi*d;
        
end

xymin = min(track.seg{n}.p);
xymax = max(track.seg{n}.p);
xmin = xymin(1);
ymin = xymin(2);
xmax = xymax(1);
ymax = xymax(2);

if track.xmin > xmin
    track.xmin = xmin;
end
if track.xmax < xmax
    track.xmax = xmax;
end
if track.ymin > ymin
    track.ymin = ymin;
end
if track.ymax < ymax
    track.ymax = ymax;
end




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
        [track.seg{n}.bd, p1, p2, p3, p4] ...
            = get_bd4straight(startpos, width, d);
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


% ============================================================= %
%            1. GET BOUNDARIES FOR STRAIGHT LANES
% ============================================================= %
function [bd, p1, p2, p3, p4] ...
    = get_bd4straight(startpos, width, d)
currxy = startpos(1:2); currdeg = startpos(3);
c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
p1 = currxy + width/2*[s -c];
p2 = p1 + d*[c s];
p3 = p2 + width*[-s c];
p4 = currxy + width/2*[-s c];
bd = [p1 ; p2 ; p3 ; p4 ; p1];


% ============================================================= %
%              2. GET BOUNDARIES FOR CURVED LANES
% ============================================================= %
function [bd, p1, p2, p3, p4, l1, l2] ...
    = get_bd4turn(startpos, width, d, type)
res = 30;
switch type
    case 'right_turn'
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        centerpos = currxy + d*[s -c];
        p1 = currxy + width/2*[s -c];
        r = d - width/2;
        init_deg = 0 + currdeg;
        degs = init_deg + linspace(90, 0, res)';
        cs = cos(degs*pi/180);
        ss = sin(degs*pi/180);
        l1 = repmat(centerpos, res, 1) + r*[cs ss];
        p2 = l1(end, :);
        p3 = p2 + width*[c s];
        init_deg2 = currdeg;
        r2 = d + width/2;
        degs2 = init_deg2 + linspace(0, 90, res)';
        cs2 = cos(degs2*pi/180);
        ss2 = sin(degs2*pi/180);
        l2 = repmat(centerpos, res, 1) + r2*[cs2 ss2];
        p4 = l2(end, :);
        bd = [p1 ; l1 ; p2 ; p3 ; l2 ; p4 ; p1];
    case 'left_turn'
        currxy = startpos(1:2); currdeg = startpos(3);
        c = cos(currdeg*pi/180); s = sin(currdeg*pi/180);
        centerpos = currxy + d*[-s +c];
        p1 = currxy + width/2*[-s +c];
        r = d - width/2;
        init_deg = currdeg - 90;
        degs = init_deg + linspace(0, 90, res)';
        cs = cos(degs*pi/180);
        ss = sin(degs*pi/180);
        l1 = repmat(centerpos, res, 1) + r*[cs ss];
        p2 = l1(end, :);
        p3 = p2 + width*[c s];
        init_deg2 = currdeg;
        r2 = d + width/2;
        degs2 = init_deg2 + linspace(0, -90, res)';
        cs2 = cos(degs2*pi/180);
        ss2 = sin(degs2*pi/180);
        l2 = repmat(centerpos, res, 1) + r2*[cs2 ss2];
        p4 = l2(end, :);
        bd = [p1 ; l1 ; p2 ; p3 ; l2 ; p4 ; p1];
    otherwise
        bd = [];
        fprintf(2, '%s?? \n', type);
end



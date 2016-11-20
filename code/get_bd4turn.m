function [bd, p1, p2, p3, p4, l1, l2] = get_bd4turn(startpos, width, d, type)

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
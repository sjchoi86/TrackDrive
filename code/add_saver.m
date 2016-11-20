function saver = add_saver(saver, mycar, myinfo, forceadd)

if nargin == 3
    forceadd  = 0;
end

dist2prev = norm(mycar.pos(1:2) - saver.pos(1:2));
degdiff = abs(mycar.pos(3)-saver.pos(3));

if dist2prev > saver.distth ...
        || degdiff > saver.degth ...
        || forceadd
    saver.pos = mycar.pos;
    
    % APPEND
    if myinfo.seg_idx > 0
        saver.n = saver.n + 1; n = saver.n;
        saver.myinfo{n} = myinfo;
        saver.mycar{n}  = mycar;
    end
end

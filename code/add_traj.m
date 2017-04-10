function traj = add_traj(traj, mycar, myinfo)

n = traj.data.n;
n = n + 1;

% ADD
if n == 1
    traj.data.mycar{n}  = mycar;
    traj.data.myinfo{n} = myinfo;
    traj.data.n         = n;
elseif myinfo.lane_idx > 0 
    prevpos  = traj.data.mycar{n-1}.pos;
    currpos  = mycar.pos;
    distdiff = norm(prevpos(1:2)-currpos(1:2));
    degdiff  = abs(prevpos(3)-currpos(3));
    if distdiff > traj.data.distth ...
            || degdiff > traj.data.degth
        traj.data.mycar{n}  = mycar;
        traj.data.myinfo{n} = myinfo;
        traj.data.n         = n;
    end
end

if n > traj.data.MAX_NR_DATA
    fprintf(2, 'NUMBER OF TRAJ EXCEEDS MAX_NR_DATA. \n');
end

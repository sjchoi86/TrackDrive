function trajs = remove_traj2trajs(trajs)
% REMOVE A TRAJ FROM TRAJS

trajs.n = trajs.n - 1;
if trajs.n < 0
    trajs.n = 0;
end
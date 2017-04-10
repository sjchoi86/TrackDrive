function trajs = add_traj2trajs(trajs, traj)
% ADD A TRAJ TO TRAJS

trajs.n = trajs.n + 1;
trajs.data{trajs.n} = traj;

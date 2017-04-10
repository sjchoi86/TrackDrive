function traj = init_traj(track, mycar, othercars)
% INITILAIZE TRAJECTORY: SEQUENCE OF FEATURES + ENVIRONMENT

traj.track     = track;
traj.othercars = othercars;
traj.mycar     = mycar;

MAX_NR_DATA = 1000;
traj.data.MAX_NR_DATA = MAX_NR_DATA;
traj.data.n      = 0;
traj.data.mycar  = cell(MAX_NR_DATA, 1);
traj.data.myinfo = cell(MAX_NR_DATA, 1);

traj.data.distth = 1000;
traj.data.degth  = 10;

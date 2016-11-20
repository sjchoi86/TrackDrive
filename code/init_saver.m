function  saver = init_saver(track, othercars)

saver.track  = track;
saver.othercars = othercars;
saver.n      = 0;
saver.pos    = [0 0 0];
saver.myinfo = cell(1E4, 1);
saver.mycar  = cell(1E4, 1);

saver.distth = 3000; % SAVE EVERY 3[M]
saver.degth  = 5; % SAVE EVERY 2[DEG]

saver.label  = 1; % 1: POSITIVE / -1: NEGATIVE

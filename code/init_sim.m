function sim = init_sim(T)

sim.flag = 1;
sim.tick = 0;
sim.T    = T;
sim.sec  = sim.tick*sim.T;
sim.mode = 'RUN';

sim.iclk = clock;
sim.ems  = 0;

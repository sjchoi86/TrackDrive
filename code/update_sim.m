function sim = update_sim(sim)

sim.tick = sim.tick + 1;
sim.sec  = sim.tick*sim.T;

sim.ems  = etime(clock, sim.iclk)*1000;
sim.iclk = clock;
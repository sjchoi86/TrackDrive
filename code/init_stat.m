function [ems, iclk] = init_stat()

ems.total = 0;
ems.plot = 0;
ems.ctrl = 0;

iclk.total = clock;

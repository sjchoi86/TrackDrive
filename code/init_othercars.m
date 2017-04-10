function othercars = init_othercars()
% INITIALIZE OTHER CARS

MAX_NRCAR = 10;
othercars.MAX_NRCAR = MAX_NRCAR;
othercars.n    = 0;
othercars.car  = cell(100, 1);
[W, H]    = get_carsize();
for i = 1:MAX_NRCAR
    othercars.car{i}.pos = [1E10 1E10 0]; 
    othercars.car{i}.vel = [0 0]; 
    othercars.car{i}.W   = W;
    othercars.car{i}.H   = H;
    othercars.car{i}.bd  = get_carshape(othercars.car{i}.pos, W, H);
    
    othercars.car{i}.paths = [];
end

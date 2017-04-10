function othercars = reset_othercars(othercars)
% RESET OTHERCARS

othercars.n = 0;
for i = 1:othercars.MAX_NRCAR
    othercars.car{i}.pos = [1E10 1E10 0]; 
end
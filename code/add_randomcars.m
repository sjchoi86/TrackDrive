function othercars = add_randomcars(othercars, track, nr_cars)
% ADD CARS IN RANDOM POSTIONS
VERBOSE = 0;

randtemp = randperm((track.nr_seg-1)*track.nr_lane);
carposlist = randtemp(1:nr_cars);
for posidx = carposlist
    segidx = ceil(posidx / track.nr_lane)+1;
    laneidx = mod(posidx, track.nr_lane)+1;
    
    if VERBOSE
        fprintf('posidx: %2d segidx: %2d laneidx: %2d \n' ...
            , posidx, segidx, laneidx);
    end
    
    % RANDOM OFFSET
    seglen = track.seg{segidx}.d;
    randoffset = seglen*rand;
    
    % SET POSITION
    carpos = get_posintrack(track, segidx, randoffset, laneidx, 0);
    othercars = add_othercars(othercars, carpos, [0 0], 'normal');
end


function othercars = add_othercars(othercars, pos, vel, ctrlmode)
if nargin == 3
    ctrlmode = 'normal';
end
othercars.n = othercars.n + 1;
othercars.car{othercars.n}.pos = pos;
othercars.car{othercars.n}.vel = vel;
othercars.car{othercars.n}.ctrlmode = ctrlmode;
othercars.car{othercars.n}.paths = [];


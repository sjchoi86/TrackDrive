function othercars = init_othercars(nothercars, track)

othercars = init_cars(5000, 3200);
setrange = [2 track.nr_seg]; lanerange = [1 track.nr_lane];
randposlist = [];
n = 0;
while n < nothercars
     randpos =  get_posintrack(track, randi(setrange), 0, randi(lanerange), 0);
     randposlist = [randposlist ; randpos];
     temp = randposlist - repmat(randpos, size(randposlist, 1), 1);
     temp2 = temp(:, 1)+temp(:, 2)+temp(:, 3);
     if length(find(abs(temp2) < 1E-5)) ~= 1, continue; end;
     % Actual appending is done here,
     othercars = add_car(othercars, randpos, [0 0], 'normal');
     n = n + 1;
end
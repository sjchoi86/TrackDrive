function [mycar, track, othercars, mode, key_pressed, saver, saverlist] ...
    = keybd_handler_collectdemo(mycar, othercars, track, mode ...
    , saver, saverlist ...
    , algname, key_pressed)

if isequal(key_pressed, '') == 0
    switch key_pressed
        case 'uparrow'
            mycar.vel(1) = mycar.vel(1) + 10000;
        case 'downarrow'
            mycar.vel(1) = mycar.vel(1) - 10000;
        case 'leftarrow'
            mycar.vel(2) = mycar.vel(2) + 20;
        case 'rightarrow'
            mycar.vel(2) = mycar.vel(2) - 20;
        case 'space' % STOP
            mycar.vel = [0 0];
        case 's' % MAKE CAR GO STRAIGHT
            mycar.pos(3) = 0;
            mycar.vel(2) = 0;
            % ====== MOVE CAR INTO DESIRED LANE ======
        case '1'
            mycar.pos = get_posintrack(track, 1, 0, 1, 0);
            mycar.vel = [0 0];
            mode.flag = 1;
            saver = init_saver(track, othercars);
        case '2'
            mycar.pos = get_posintrack(track, 1, 0, 2, 0);
            mycar.vel = [0 0];
            mode.flag = 1;
            saver = init_saver(track, othercars);
        case '3'
            mycar.pos = get_posintrack(track, 1, 0, 3, 0);
            mycar.vel = [0 0];
            mode.flag = 1;
            saver = init_saver(track, othercars);
        case '4'
            mycar.pos = get_posintrack(track, 1, 0, 4, 0);
            mycar.vel = [0 0];
            mode.flag = 1;
            saver = init_saver(track, othercars);
        case '5'
            mycar.pos = get_posintrack(track, 1, 0, 5, 0);
            mycar.vel = [0 0];
            mode.flag = 1;
            saver = init_saver(track, othercars);
        case 'p' % POSITIVE SAVE
            if saver.n >= 5
                saver.label = 1;
                saverlist = add2saverlist(saverlist, saver, othercars);
            end
            saver = init_saver(track, othercars);
            mycar.pos = get_posintrack(track, 1, 0, randi([1 track.nr_lane]), 0);
            mycar.vel = [0 0];
            fprintf('[%d] POSITIVE SAVED. \n', saverlist.n);
        case 'n' % NEGATIVE SAVE
            if saver.n >= 5
                saver.label = -1;
                saverlist = add2saverlist(saverlist, saver, othercars);
            end
            saver = init_saver(track, othercars);
            mycar.pos = get_posintrack(track, 1, 0, randi([1 track.nr_lane]), 0);
            mycar.vel = [0 0];
            fprintf(2, '[%d] NEGATIVE SAVED. \n', saverlist.n);
        case 'r' % RESET
            nr_cars = randi([3 5]);
            othercars = init_othercars(nr_cars, track);
            saver = init_saver(track, othercars);
            mycar.pos = get_posintrack(track, 1, 0, 1, 0);
            mycar.vel = [0 0];
            mode.flag = 1;
            fprintf('[%d] RESET. \n', saverlist.n);
        case 'd' % DISCARD CURRENT SAVINGS
            saver = init_saver(track, othercars);
            mycar.pos = get_posintrack(track, 1, 0, 1, 0);
            mycar.vel = [0 0];
            fprintf('[%d] DISCARD. \n', saverlist.n);
        case 'z' % REMOVE PREVIOUSLY SAVED ONE
            saver = init_saver(track, othercars);
            mycar.pos = get_posintrack(track, 1, 0, 1, 0);
            mycar.vel = [0 0];
            saverlist.n = saverlist.n -1;
            fprintf('[%d] UNDO PREVIOUS SAVING. \n', saverlist.n);
        case 'w' % SAVE AND QUIT
            if saverlist.n > 0
                answer = inputdlg('TYPE CURRENT MODE AND PRESEE OK');
                matname = sprintf('%s/demo@%s_%s.mat' ...
                    , algname, answer{1}, datestr(now, 'yymmdd_HHMM'));
                save(matname, 'saverlist');
                fprintf('[%d] saverlist saved to %s. \n', saverlist.n, matname);
            end
            mode.flag = -1;
        case 'q' % QUIT WITHOUT SAVE
            mode.flag = -1;
    end
end
key_pressed = '';

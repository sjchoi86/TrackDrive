%%
%
% Track driving simulator
% Sungjoon Choi (sungjoon.choi@cpslab.snu.ac.kr)
%
ccc

%%
ccc
global key_pressed; key_pressed = '';
rng(1)

% Init lane
nr_lane = 5;
width   = 30000;
track  = init_track(nr_lane);
track  = add_segment(track, 'straight', width, 20000);
track  = add_segment(track, 'right_turn', width, 20000);
track  = add_segment(track, 'right_turn', width, 20000);
track  = add_segment(track, 'left_turn', width, 20000);
track  = add_segment(track, 'right_turn', width, 20000);
track  = add_segment(track, 'right_turn', width, 20000);
track  = add_segment(track, 'straight', width, 40000);
track  = add_segment(track, 'right_turn', width, 20000);
track  = add_segment(track, 'straight', width, 20000);


% Car pos
mycar.pos = [0 0 0]; mycar.vel = [0 0];

% Other cars (obstacles)
nothercars = 7;
othercars = init_cars();
setrange = [2 track.nr_seg]; lanerange = [1 nr_lane];
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

% Simulation
T    = 0.1;
tick = 0; 
% Figure
fig = figure(1);
set(fig, 'KeyPressFcn', @keyDownListener, 'Position', [200 300 900 800] ...
     , 'MenuBar', 'none', 'NumberTitle', 'off', 'Name', 'Track Driving Simulator');
flag = 1; mode.flag = 1; emsec_total = 0;
while flag
    iclk = clock;
    if isequal(key_pressed, '') == 0
        switch key_pressed
            case 'uparrow'
                mycar.vel(1) = mycar.vel(1) + 2000;
            case 'downarrow'
                mycar.vel(1) = mycar.vel(1) - 2000;
            case 'leftarrow'
                mycar.vel(2) = mycar.vel(2) + 20;
            case 'rightarrow'
                mycar.vel(2) = mycar.vel(2) - 20;
            case 'space'
                mycar.vel = [0 0];
            case 'q' % Quit
                flag = 0;
            case 'p' % Pause
                mode.flag = ~mode.flag;
        end
        key_pressed = '';
    end
    switch mode.flag
        case 0 % PAUSE
            % Mode
            mode_str = 'PAUSE';
        case 1 % RUN
            % Update
            tick = tick + 1; sec = tick * T;
            mycar.pos = update_pos(mycar.pos, mycar.vel, T);
            for i = 1:othercars.n, othercars.car{i}.pos = update_pos(othercars.car{i}.pos, othercars.car{i}.vel, T); end
            
            % Control other carsqq
            [othercars, emsec_ctrl] = ctrl_cars(othercars, track);
            
            % Get features
            [myinfo, emsec_info] = get_trackinfo(track, mycar.pos, othercars);
            
            % Useful features in meters and degrees
            geod      = myinfo.dist/1E3;
            dev       = myinfo.dev/1E3;
            ldev      = myinfo.lane_dev/1E3;
            ldeg      = myinfo.deg;
            fb_left   = myinfo.left_fb_dists/1E3;
            fb_right  = myinfo.right_fb_dists/1E3;
            fb_center = myinfo.center_fb_dists/1E3;
            if 0
                 fprintf('GeodDist: %.2fm Dev: %.2fm LaneDev: %.2fm LaneDeg: %.2fdeg ' ...
                      , geod, dev, ldev, ldeg);
                 fprintf('left: %.2fm %.2fm right: %.2fm %.2fm center: %.2fm %.2fm \n' ...
                      , fb_left(1), fb_left(2), fb_right(1), fb_right(2), fb_center(1), fb_center(2));
            end
            % Mode
            mode.str = 'RUN';
    end
    
    % Plot
    plot_demo_maketrack(track, mycar, myinfo, tick, sec, emsec_total, mode);
    plot_demo_othercars(track, othercars)
    drawnow;
    
    emsec_total = etime(clock, iclk)*1000;
end
title('Terminated', 'FontSize', 20, 'Color', 'r');
fprintf(2, 'Terminated. \n');


%%


ccc
%% TRACK DRIVING DEMO
ccc
global key_pressed; key_pressed = '';
% INITIALIZE LANE, CARS, SIMULATIONS
track     = init_track(4, 30000, 'complex');
mycar     = init_mycar(get_posintrack(track, 1, 0, 1, 0));
othercars = init_othercars(4, track);
sim       = init_sim(0.1);
% FIGURE
fig = figure(1); hold on;
sz = get( 0, 'ScreenSize');
set(fig, 'KeyPressFcn', @keyDownListener ...
    , 'Position', [2*sz(3)/8 sz(4)/8 2*sz(3)/4 3*sz(4)/4] ...
    , 'MenuBar', 'none', 'NumberTitle', 'off', 'Name', 'Track Simulator');
emsec_total = 0;
while sim.flag >= 0 && ishandle(fig)
    iclk_total = clock;
    % KEYBOARD HANDLER
    [key_pressed, mycar, sim] ...
        = keybd_handler_trackusage(key_pressed, mycar, sim); 
    % SIMULATE
    switch sim.flag
        case 0 % PAUSE
            mode_str = 'PAUSE';
        case 1 % RUN
            sim = update_sim(sim);
            mycar.pos = update_pos(mycar.pos, mycar.vel, sim.T);
            for i = 1:othercars.n, othercars.car{i}.pos ...
                    = update_pos(othercars.car{i}.pos, othercars.car{i}.vel, sim.T);
            end
            [othercars, emsec_ctrl] = ctrl_cars(othercars, track);
            [myinfo, emsec_info] = get_trackinfo(track, mycar.pos, othercars);
            sim.str = 'RUN';
    end
    % PLOT
    iclk_plot = clock;
    plot_demo_maketrack(track, mycar, myinfo, sim.tick, sim.sec, emsec_total, sim);
    plot_demo_othercars(othercars)
    drawnow;
    emsec_plot = etime(clock, iclk_plot)*1000;
    emsec_total = etime(clock, iclk_total)*1000;
end
if ishandle(fig)
    title(sprintf('\nTerminated\n'), 'FontSize', 14, 'Color', 'r');
end
fprintf(2, 'Terminated. \n');

%%

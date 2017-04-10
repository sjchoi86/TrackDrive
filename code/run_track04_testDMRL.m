ccc
%% TEST THE PERFORMANCE OF DMRL
ccc
% LOAD KDMRL
loadname = 'data/kdmrl/kdmrl.mat';
l = load(loadname); kdmrl = l.kdmrl;

% INITIALIZE ENVIRONMENT
NR_LANE    = 4;
LANE_WIDTH = 3500; % LANE WIDTH IS FIXED TO 3.5M
TRACK_TYPE = 'TEST';
track      = init_track(NR_LANE, LANE_WIDTH, TRACK_TYPE);
sim        = init_sim(0.05);
othercars  = init_othercars();
nr_cars    = 10;
othercars  = add_randomcars(othercars, track, nr_cars);
mycar      = init_mycar(get_posintrack(track, 1, 0, 1, 0));

% INITIALIZE FIGURE
figsz     = [2 1 5 8]/10;
figtitle  = 'TEST KDMRL';
axespos   = [0.03, 0.05, 0.95, 0.8];
fig       = get_fig(figsz, figtitle, axespos);
set(gcf,'Color', [0.1, 0.25, 0.2] ); hold on;
ms_update = 0; ms_plot = 0;

while sim.flag 
    % KEYBOARD CONSTROLLER
    switch key_pressed
        case ''
        case {'1', '2', '3', '4', '5', '6'}
            nr_lane = str2num(key_pressed);
            mycar = set_mycar(mycar, get_posintrack(track, 1, 0, nr_lane, 0), [0 0]);
        case 'r'
            % RESET CAR CONFIGURATIONS
            othercars  = reset_othercars(othercars);
            othercars  = add_randomcars(othercars, track, nr_cars);
            mycar = set_mycar(mycar, get_posintrack(track, 1, 0, 1, 0), [0 0]);
        case 'p'
            if isequal(sim.mode, 'RUN'), sim.mode = 'PAUSE';
            elseif isequal(sim.mode, 'PAUSE'), sim.mode = 'RUN'; end
        case 'q'
            sim.mode = 'QUIT';
        otherwise
            fprintf(2, 'KEY[%s] UNDEFINED. \n', key_pressed);
    end
    key_pressed = '';
    clk_update = clock;
    switch sim.mode
        case 'RUN'
            % UPDATE
            sim        = update_sim(sim);
            othercars  = ctrl_cars(othercars, track);
            othercars  = update_othercars(othercars, sim);
            mycar      = update_mycar(mycar, sim, othercars);
            myinfo     = get_trackinfo(track, mycar.pos, othercars);
            % CONTROL
            % opt = struct('ctrl_mode', 'NORMAL');
            opt = struct('ctrl_mode', 'KDMRL', 'kdmrl', kdmrl);
            mycar = ctrl_mycar(mycar, othercars, track, opt);
            titlecol = 'w';
        case 'PAUSE'
            titlecol = 'c';
        case 'QUIT'
            sim.flag = 0;
            titlecol = 'r';
    end
    ms_update  = etime(clock, clk_update)*1000;
    % PLOT
    clk_plot   = clock;
    FILL_LANES = 1;
    axisinfo   = plot_track(track, FILL_LANES);
    plot_axisinfo(axisinfo);
    SIMPLECARSHAPE = 0;
    REALCARSHAPE   = 1;
    plot_othercars(othercars, SIMPLECARSHAPE, REALCARSHAPE);
    PLOT_FUTURE_CARPOSES = 0;
    PLOT_CAR_PATHS       = 0;
    SIMPLECARSHAPE       = 0;
    PLOT_RFS             = 0;
    plot_mycar(mycar ...
        , PLOT_FUTURE_CARPOSES, PLOT_CAR_PATHS, SIMPLECARSHAPE, PLOT_RFS);
    strtemp = ['[%.1fSEC][UPDATE:%.1fms+PLOT:%.1fms] ' ...
        '[VEL: %.2fkm/h %.1fdeg/s] \n' ...
        '[%dseg-%dlane][LANE-DEV DIST:%.2fm DEG:%.1fdeg][DIST:%.1fm] \n' ...
        '[LEFT:%.2fm-CENTER:%.2fm-RIGHT:%.2fm]\n'];
    titlestr = sprintf(strtemp, sim.sec, ms_update, ms_plot ...
        , mycar.vel(1)/10000*36, mycar.vel(2) ...
        , myinfo.seg_idx, myinfo.lane_idx, myinfo.lane_dev/1000, myinfo.deg ...
        , myinfo.dist/1000 ...
        , myinfo.left_fb_dists(1)/1000, myinfo.center_fb_dists(1)/1000 ...
        , myinfo.right_fb_dists(1)/1000);
    plot_title(titlestr, titlecol, get_fontsize());
    drawnow;
    ms_plot = etime(clock, clk_plot)*1000;
end
fprintf(2, 'SIMULATION TERMINATED \n');

%%
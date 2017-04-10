ccc
%% BASIC TRACK USAGE
ccc
rng(0);

% INITIALIZE ENVIRONMENT
NR_LANE    = 4;
LANE_WIDTH = 3500; % LANE WIDTH IS FIXED TO 3.5M
TRACK_TYPE = 'SIMPLE';
track      = init_track(NR_LANE, LANE_WIDTH, TRACK_TYPE);
sim        = init_sim(0.1);
othercars  = init_othercars();
nr_cars    = 4;
othercars  = add_randomcars(othercars, track, nr_cars);
mycar      = init_mycar(get_posintrack(track, 1, 0, 1, 0));

% ADD TRAFFIC LIGHT
tl_lane_idx = 1;
tl_period   = [12 3 10];
track       = add_tracfficlight(track, tl_lane_idx, tl_period);

% INITIALIZE FIGURE
figsz     = [2 1 4 6]/10;
figtitle  = 'BASIC TRACK USAGE';
axespos   = [0.03, 0.05, 0.95, 0.8]; 
fig       = get_fig(figsz, figtitle, axespos);
set(gcf,'Color', [0.1, 0.25, 0.2] ); hold on;
ms_update = 0; ms_plot = 0;

while sim.flag
    % KEYBOARD CONSTROLLER
    switch key_pressed
        case ''
        case 'leftarrow'
            mycar.vel(2) = mycar.vel(2)+20;
        case 'rightarrow'
            mycar.vel(2) = mycar.vel(2)-20;
        case 'uparrow' 
            mycar.vel(1) = mycar.vel(1)+10000;
        case 'downarrow'
            mycar.vel(1) = mycar.vel(1)-10000;
        case 'space'
            mycar.vel = [0 0];
        case 'p'
            if isequal(sim.mode, 'RUN'), sim.mode = 'PAUSE'; 
            elseif isequal(sim.mode, 'PAUSE'), sim.mode = 'RUN'; end
        case 'q'
            sim.mode = 'QUIT';
        otherwise
            fprintf(2, 'KEY[%s] UNDEFINED. \n', key_pressed);
    end
    key_pressed = '';
    switch sim.mode
        case 'RUN'
            % UPDATE
            clk_update = clock;
            sim        = update_sim(sim);
            othercars  = ctrl_cars(othercars, track);
            othercars  = update_othercars(othercars, sim);
            mycar      = update_mycar(mycar, sim, othercars);
            track      = update_trafficlight(track, sim);
            myinfo     = get_trackinfo(track, mycar.pos, othercars);
            ms_update  = etime(clock, clk_update)*1000;
            % CONTROL
            opt = struct('ctrl_mode', 'NORMAL');
            mycar      = ctrl_mycar(mycar, othercars, track, opt);
            titlecol = 'w'; 
        case 'PAUSE'
            titlecol = 'c';
        case 'QUIT'
            sim.flag = 0;
            titlecol = 'r';
    end
    % PLOT
    clk_plot   = clock;
    FILL_LANES = 1;
    axisinfo   = plot_track(track, FILL_LANES);
    plot_axisinfo(axisinfo);
    SIMPLECARSHAPE = 0;
    REALCARSHAPE   = 1;
    plot_othercars(othercars, SIMPLECARSHAPE, REALCARSHAPE);
    PLOT_FUTURE_CARPOSES = 1;
    PLOT_CAR_PATHS       = 1;
    SIMPLECARSHAPE       = 0;
    PLOT_RFS             = 1;
    plot_mycar(mycar ... 
        , PLOT_FUTURE_CARPOSES, PLOT_CAR_PATHS, SIMPLECARSHAPE, PLOT_RFS);
    strtemp = ['[%.1fSEC][UPDATE:%.1fms+PLOT:%.1fms] ' ...
        '[VEL: %.2fkm/h %.1fdeg/s] \n' ...
        '[%dseg-%dlane][LANE-DEV DIST:%.1fmm DEG:%.1fdeg][DIST:%.1fmm] \n' ...
        '[LEFT:%.2fm-CENTER:%.2fm-RIGHT:%.2fm][TL-DIST: %.2fm(%s)]\n'];
    titlestr = sprintf(strtemp, sim.sec, ms_update, ms_plot ...
        , mycar.vel(1)/1000*36, mycar.vel(2) ...
        , myinfo.seg_idx, myinfo.lane_idx, myinfo.lane_dev, myinfo.deg ...
        , myinfo.dist ...
        , myinfo.left_fb_dists(1)/1000, myinfo.center_fb_dists(1)/1000 ...
        , myinfo.right_fb_dists(1)/1000, myinfo.tlinfo.dist2tf/1000 ...
        , upper(myinfo.tlinfo.type));
    plot_title(titlestr, titlecol, get_fontsize());
    drawnow;
    ms_plot = etime(clock, clk_plot)*1000;
end
fprintf(2, 'SIMULATION TERMINATED \n');

%%



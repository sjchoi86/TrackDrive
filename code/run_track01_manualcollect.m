ccc
%% MANUALLY COLLECT DRIVING DEMONSTRATIONS
ccc; 

% INITIALIZE ENVIRONMENT
TRACK_TYPE = 'MANUAL_COLLECT';
NR_LANE    = 4;
LANE_WIDTH = 3500; % LANE WIDTH IS FIXED TO 3.5M
track      = init_track(NR_LANE, LANE_WIDTH, TRACK_TYPE);
sim        = init_sim(0.02);
othercars  = init_othercars();
nr_cars    = randi([1 4]);
othercars  = add_randomcars(othercars, track, nr_cars);
mycar      = init_mycar(get_posintrack(track, 1, 0, 1, 0));

% INITIALIZE FIGURE
figsz     = [1 4 8 4]/10;
figtitle  = 'MANUAL COLLECT DEMO';
axespos   = [0.03, 0.02, 0.95, 0.84]; 
fig       = get_fig(figsz, figtitle, axespos);
set(gcf,'Color', [0.1, 0.25, 0.2] ); hold on;
ms_update = 0; ms_plot = 0;

% RUN
% INITIALIZE SAVER
traj = init_traj(track, mycar, othercars);
while sim.flag && ishandle(fig)
    % KEYBOARD CONTROLLER
    switch key_pressed 
        case ''
        case {'leftarrow', 'semicolon'}
            mycar.vel(2) = mycar.vel(2)+20;
        case {'rightarrow', 'quote'}
            mycar.vel(2) = mycar.vel(2)-20;
        case {'uparrow', 'leftbracket'}
            mycar.vel(1) = mycar.vel(1)+10000;
        case {'downarrow', 'slash'}
            mycar.vel(1) = mycar.vel(1)-10000;
        case 'space'
            mycar.vel = [0 0];
        case {'1', '2', '3', '4', '5', '6'}
            nr_lane = str2num(key_pressed);
            mycar = set_mycar(mycar, get_posintrack(track, 1, 0, nr_lane, 0), [0 0]);
        case 's' % MAKE A CAR GO STRAIGHT
            mycar.pos(3) = 0; mycar.vel(2) = 0;
        case 'p'
            if isequal(sim.mode, 'RUN'), sim.mode = 'PAUSE'; 
            elseif isequal(sim.mode, 'PAUSE'), sim.mode = 'RUN'; end
        case 'q' 
            sim.mode = 'QUIT';
        case 'r'
            % RESET CAR CONFIGURATIONS
            othercars  = reset_othercars(othercars);
            nr_cars = randi([1 4]);
            othercars  = add_randomcars(othercars, track, nr_cars);
            mycar = set_mycar(mycar, get_posintrack(track, 1, 0, 1, 0), [0 0]);
            % RESET TRAJ AS CAR CONFIGURATIONS ARE CHANGED
            traj = init_traj(track, mycar, othercars);
        case 'w'
            % SAVE TO FILE
            savename = sprintf('data/raw_trajs/traj_%s.mat' ...
                , datestr(datenum(clock),'yyyymmdd_HHMM'));
            save(savename, 'traj');
            fprintf(2, 'TRAJ SAVE TO [%s]. \n', savename);
            sim.mode = 'QUIT';
        otherwise 
            fprintf(2, 'KEY[%s] UNDEFINED. \n', key_pressed);
    end
    key_pressed = ''; 
    
    % SIMULATE 
    switch sim.mode 
        case 'RUN'
            % UPDATE
            clk_update = clock;
            sim        = update_sim(sim);
            othercars  = update_othercars(othercars, sim);
            mycar      = update_mycar(mycar, sim, othercars);
            myinfo     = get_trackinfo(track, mycar.pos, othercars);
            ms_update  = etime(clock, clk_update)*1000;
            titlecol = 'w';
            
            % SAVE TRAJ
            traj = add_traj(traj, mycar, myinfo);
            
            % TERMINATE CONDITIONS            
            if is_insidetrack(myinfo) == 0
                fprintf(2, 'OUTSIDE THE TRACK. \n');
                mycar = init_mycar(get_posintrack(track, 1, 0, 1, 0));
            end
            if is_carcrashed(myinfo)
                fprintf(2, 'COLLISION OCCURRED. \n');
                mycar.vel = [0 0];
                mycar = init_mycar(get_posintrack(track, 1, 0, 1, 0));
            end
        case 'PAUSE'
            titlecol = 'c';
        case 'QUIT'
            sim.flag = 0;
            titlecol = 'r';
    end
    
    % PLOT
    clk_plot = clock;
    FILL_LANES           = 1;
    SIMPLECARSHAPE       = 0;
    REALCARSHAPE         = 1; 
    PLOT_FUTURE_CARPOSES = 1;
    PLOT_CAR_PATHS       = 1;
    PLOT_RFS             = 1;
    strtemp = ['[%.1fSEC][UPDATE:%.1fMS+PLOT:%.1fMS] ' ...
        '[VEL: %.1fKM/H %.1fDEG/S] \n' ...
        '[%dSEG-%dLANE] / [LANE-DEV DIST:%.1fMM DEG:%.1fDEG] \n' ...
        '[LEFT:%.2fM-CENTER:%.2fM-RIGHT:%.2fM]\n' ...
        '[#SAVE: %d]'];
    titlestr = sprintf(strtemp, sim.sec, ms_update, ms_plot ...
        , mycar.vel(1)/10000*36, mycar.vel(2) ...
        , myinfo.seg_idx, myinfo.lane_idx, myinfo.lane_dev, myinfo.deg ...
        , myinfo.left_fb_dists(1)/1000, myinfo.center_fb_dists(1)/1000 ...
        , myinfo.right_fb_dists(1)/1000 ...
        , traj.data.n);
    titlefontsize = get_fontsize();
    axisinfo = plot_track(track, FILL_LANES);
    plot_axisinfo(axisinfo);
    plot_othercars(othercars, SIMPLECARSHAPE, REALCARSHAPE);
    plot_mycar(mycar, PLOT_FUTURE_CARPOSES, PLOT_CAR_PATHS, SIMPLECARSHAPE, PLOT_RFS);
    plot_traj(traj);
    plot_title(titlestr, titlecol, titlefontsize);
    drawnow;
    ms_plot = etime(clock, clk_plot)*1000;
end
fprintf(2, 'SIMULATION TERMINATED \n');

%%





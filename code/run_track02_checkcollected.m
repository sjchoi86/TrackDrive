ccc
%% CHECK COLLECTED DEMONSTRATIONS
ccc
% LOAD MATS
dirpath = 'data/raw_trajs';
mats  = dir([dirpath '/*.mat']);
nmats = length(mats);
fprintf('WE HAVE %d MAT FILES. \n', nmats);

% INITIALIZE FIGURE
figsz     = [1 4 8 3]/10;
figtitle  = 'MANUAL COLLECT DEMO';
axespos   = [0.03, 0.02, 0.95, 0.9];
fig       = get_fig(figsz, figtitle, axespos);
set(gcf,'Color', [0.1, 0.25, 0.2] ); hold on;

for matidx = 1:nmats
    l = load([dirpath '/' mats(matidx).name]);
    data      = l.traj.data;
    othercars = l.traj.othercars;
    track     = l.traj.track;
    ndata     = data.n;
    for t = 1:ndata
        % KEYBD HANDLER
        switch key_pressed
            case 'q'
                break;
        end
        key_pressed = '';
        
        % PLOT 
        mycar = data.mycar{t}; 
        FILL_LANES = 1;
        SIMPLECARSHAPE = 0;
        REALCARSHAPE = 1;
        PLOT_FUTURE_CARPOSES = 1;
        PLOT_CAR_PATHS = 0;
        PLOT_RFS = 1;
        titlestr = sprintf('[%d/%d][%d/%d]' ...
            , matidx, nmats, t, ndata);
        
        axisinfo = plot_track(track, FILL_LANES);
        plot_axisinfo(axisinfo);
        plot_othercars(othercars, SIMPLECARSHAPE, REALCARSHAPE);
        plot_mycar(mycar, PLOT_FUTURE_CARPOSES, PLOT_CAR_PATHS, SIMPLECARSHAPE, PLOT_RFS);
        plot_title(titlestr, 'w', get_fontsize());
        drawnow;
    end
end
fprintf(2, 'TERMINATED. \n');

%%

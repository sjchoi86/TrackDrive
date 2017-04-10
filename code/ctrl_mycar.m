function mycar = ctrl_mycar(mycar, othercars, track, opt)
%% CONTROL MYCAR
ctrl_mode = opt.ctrl_mode;

switch ctrl_mode
    case 'NORMAL'
        mycar = get_normalctrl(mycar, othercars, track);
    case 'KDMRL'
        kdmrl = opt.kdmrl;
        mycar = get_kdmrlctrl(mycar, othercars, track, kdmrl);
    otherwise
        fprintf(2, '[%s]Undefined. \n', upper(ctrl_mode));
end


function mycar = get_kdmrlctrl(mycar, othercars, track, kdmrl)
%% 1. KDMRL CONTROLLER
carpos = mycar.pos;
% SAMPLE RANDOM PATHS
[mycarpaths, ctrls, N, Kres] = get_randpaths(carpos);
costs = zeros(N, 1);
ntest = 5;
feats = [];
for j = 1:N % For all paths
    cpath = mycarpaths(3*j-2:3*j, :)';
    for k = round(linspace(Kres/2, Kres, ntest))
        cinfo = get_trackinfo(track, cpath(k, :), othercars);
        feat  = get_feat(cinfo);
        feats = [feats ; feat];
    end
end
temps = get_kdmrl(kdmrl, feats);
temps(isnan(temps)) = 0;
for j = 1:N % For all paths
    costs(j) = max(temps((j-1)*ntest+1:j*ntest));
end

[~, maxidx] = max(costs);
opt_vel = ctrls(2*maxidx-1:2*maxidx, 1);
mycar.vel = [20000 opt_vel(2)];
mycar.paths = mycarpaths;


function mycar = get_normalctrl(mycar, othercars, track)
%% 2. NORMAL CONTROLLER
carpos = mycar.pos;
dinfo = get_trackinfo(track, [carpos(1:2) 0]);
hinfo = get_trackinfo(track, carpos, othercars);
% SET DIRECTIONAL VELOCITY
dirvel = 10000;
fdist = hinfo.center_fb_dists(1);
% SET DIRECTIONAL VELOCITY
if isfield(hinfo, 'tlinfo') % IF TRRAFFIC LIGHT EXISTS
    % SLOW DOWN IN THE YELLOW OR RED LIGHT
    if (isequal(hinfo.tlinfo.type, 'y') || ...
            isequal(hinfo.tlinfo.type, 'r'))...
            && hinfo.tlinfo.dist2tf < 15000
        dirvel = 5000;
    end
    % STOP IN FRONT OF THE RED LIGHT
    if isequal(hinfo.tlinfo.type, 'r') ...
            && hinfo.tlinfo.dist2tf < 4000
        dirvel = 0;
    end
end
if fdist < 7000 % IF ANOTHER CAR IS INFRONT
    dirvel = 0;
end
% SET ANGULAR VELOCITY
lanedeg = -dinfo.deg;
degdiff = carpos(3) - lanedeg;
if degdiff >= 180, degdiff = degdiff - 360; end;
if degdiff <= -180, degdiff = degdiff + 360; end;
w = -degdiff*15 + hinfo.lane_dev * 0.3;
wmax = 200;
w = max(min(w, wmax), -wmax);
vel = [dirvel, w];
mycar.vel = vel;
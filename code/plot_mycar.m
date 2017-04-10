function ems = plot_mycar(mycar ...
    , PLOT_FUTURE_CARPOSES, PLOT_CAR_PATHS, SIMPLECARSHAPE, PLOT_RFS)
% PLOT MYCAR
persistent first_flag h
if isempty(first_flag)
    first_flag = true;
end
iclk = clock;
% PLOT FUTURE POSITINOS
pred_hor = 3;
mycar.postemp = mycar.pos;
car_traj = zeros(pred_hor, 3);
car_trajbd = cell(pred_hor, 1);
for i = 1:pred_hor
    for j = 1:2
        mycar.postemp  = update_pos(mycar.postemp, mycar.vel, 0.1);
    end
    car_traj(i, :) = mycar.postemp;
    rate           = 0.8;
    car_trajbd{i}  = get_carshape(mycar.postemp, rate*mycar.W, rate*mycar.H);
end
rszwh  = [50 100];
[W, H] = get_carsize();
carwh  = [W, H];

% ROBOT RFS BOUNDARIES
rfs_bd = zeros(mycar.nr_rfs*3, 2);
for rfsbdi = 1:mycar.nr_rfs
    rfs_deg = mycar.pos(3) + mycar.rfs_degs(rfsbdi);
    rfs_fr  = mycar.pos(1:2);
    rfs_to  = rfs_fr + (mycar.r+mycar.rfs_dists(rfsbdi)) ...
        *[cos(rfs_deg*pi/180) sin(rfs_deg*pi/180)];
    rfs_bd(3*(rfsbdi-1)+1:3*rfsbdi, :) ...
        = [rfs_fr(1) rfs_fr(2); rfs_to(1) rfs_to(2); nan nan];
end

if first_flag
    first_flag = false;
    % LOAD CAR IMAGE
    [carimg, ~, cartr] = imread('carimg/redcar.png');  % car1
    carrsz = imresize(carimg, rszwh);
    trrsz  = imresize(cartr, rszwh);
    
    % FUTURE POSITIONS
    if PLOT_FUTURE_CARPOSES
        for i = 1:pred_hor
            futurecarcol = [0.95 0.3 0.3];
            [h1, h2, h3] = plot_arrow(car_traj(i, 1:2), 1500, car_traj(i, 3) ...
                , futurecarcol, 2);
            h.cartraj{i} = [h1 h2 h3];
            h.cartrajbd{i} = plot(car_trajbd{i}(:, 1), car_trajbd{i}(:, 2) ...
                , 'Color', futurecarcol, 'LineWidth', 1);
        end
    end
    
    % CAR PATHS
    if isfield(mycar, 'paths') && PLOT_CAR_PATHS
        paths = mycar.paths;
        npath = size(paths, 1)/3;
        h.paths = cell(npath, 1);
        for pathi = 1:npath
            cpath = paths(3*(pathi-1)+1:3*(pathi-1)+3, :)';
            h.paths{pathi} = plot(cpath(:, 1), cpath(:, 2) ...
                , 'k-', 'LineWidth', 2);
        end
    end
    
    % RFS
    if PLOT_RFS
        h.rfs_bd = plot(rfs_bd(:, 1), rfs_bd(:, 2), '-' ...
            , 'Color', [0.95 0.6 0.4], 'LineWidth', 1);
        h.rfs_bd.Color(4) = 0.5;
    end
    % CURRENT POSITION
    if SIMPLECARSHAPE
        h.carfill = fill(mycar.bd(:, 1), mycar.bd(:, 2), 'g');
        h.carbd = plot(mycar.bd(:, 1), mycar.bd(:, 2), 'k', 'LineWidth', 1);
        [h1, h2, h3] = plot_arrow(mycar.pos, 2000, mycar.pos(3), 'k', 3);
        h.cararrow = [h1 h2 h3];
    end
    % CAR IMAGE (PLOT ALWAYS)
    if 1
        carpos = mycar.pos;
        [xmesh_grid, ymesh_grid] = get_carmeshgred(carpos, carwh, rszwh);
        h.carsurf = surf('xdata', xmesh_grid, 'ydata', ymesh_grid ...
            , 'zdata', zeros(rszwh(1), rszwh(2)) ...
            , 'cdata', carrsz, 'AlphaData', trrsz ...
            , 'FaceAlpha', 'texture' ...
            , 'FaceColor', 'texturemap' ...
            , 'EdgeColor','None', 'LineStyle', 'None');
    end
else
    % FUTURE POSITIONS
    if PLOT_FUTURE_CARPOSES
        for i = 1:pred_hor
            [x1, y1, x2, y2, x3, y3] ...
                = get_arrow(car_traj(i, 1:2), 2000, car_traj(i, 3), 'k', 1);
            h.cartraj{i}(1).XData = x1; h.cartraj{i}(1).YData = y1;
            h.cartraj{i}(2).XData = x2; h.cartraj{i}(2).YData = y2;
            h.cartraj{i}(3).XData = x3; h.cartraj{i}(3).YData = y3;
            h.cartrajbd{i}.XData = car_trajbd{i}(:, 1);
            h.cartrajbd{i}.YData = car_trajbd{i}(:, 2);
        end
    end
    
    % CAR PATHS
    if isfield(mycar, 'paths') && PLOT_CAR_PATHS
        paths = mycar.paths;
        npath = size(paths, 1)/3;
        for pathi = 1:npath
            cpath = paths(3*(pathi-1)+1:3*(pathi-1)+3, :)';
            h.paths{pathi}.XData = cpath(:, 1);
            h.paths{pathi}.YData = cpath(:, 2);
        end
    end
    
    % RFS
    if PLOT_RFS
        h.rfs_bd.XData = rfs_bd(:, 1);
        h.rfs_bd.YData = rfs_bd(:, 2);
    end
    % CAR SHAPE
    if SIMPLECARSHAPE
        h.carfill.Vertices = mycar.bd;
        h.carbd.XData = mycar.bd(:, 1); h.carbd.YData = mycar.bd(:, 2);
        [x1, y1, x2, y2, x3, y3] = get_arrow(mycar.pos, 2000, mycar.pos(3), 'k', 3);
        h.cararrow(1).XData = x1; h.cararrow(1).YData = y1;
        h.cararrow(2).XData = x2; h.cararrow(2).YData = y2;
        h.cararrow(3).XData = x3; h.cararrow(3).YData = y3;
    end
    % CAR IMAGE (PLOT ALWAYS)
    if 1
        carpos = mycar.pos;
        [xmesh_grid, ymesh_grid] = get_carmeshgred(carpos, carwh, rszwh);
        h.carsurf.XData = xmesh_grid;
        h.carsurf.YData = ymesh_grid;
    end
    
end
ems = etime(clock, iclk)*1000;
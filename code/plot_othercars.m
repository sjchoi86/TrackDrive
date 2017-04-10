function ems = plot_othercars(othercars, SIMPLECARSHAPE, REALCARSHAPE)
persistent fist_flag h
if isempty(fist_flag)
    fist_flag = true;
end

iclk = clock;

% MY CAR GRID
rszwh  = [50 100];
[W, H] = get_carsize();
carwh  = [W, H];
% PLOT
if fist_flag
    fist_flag = false;
    % LOAD CAR IMAGE
    [carimg, ~, cartr] = imread('carimg/car1.png');
    carrsz = imresize(carimg, rszwh); 
    trrsz  = imresize(cartr, rszwh);  
    % OTHER CARS
    h.carsarrow = cell(othercars.n, 1);
    % for i = 1:othercars.n
    for i = 1:othercars.MAX_NRCAR
        col = [0.9 0.2 0.6];
        randpaths = othercars.car{i}.paths;
        npath = size(randpaths, 1)/3; 
        if npath > 0
            cpaths = [];
            for j = 1:npath
                cpath = randpaths(3*j-2:3*j, :)';
                cpaths = [cpaths ; NaN NaN ; cpath(:, 1:2)];
            end
            h.paths{i} = plot(cpaths(:, 1), cpaths(:, 2), '-', 'Color', col, 'LineWidth', 2);
        end
        if SIMPLECARSHAPE
            h.carsfill{i} = fill(othercars.car{i}.bd(:, 1), othercars.car{i}.bd(:, 2), col);
            h.carsbd{i} = plot(othercars.car{i}.bd(:, 1), othercars.car{i}.bd(:, 2) ...
                , 'Color', 'k', 'LineWidth', 1);
            [h1, h2, h3] = plot_arrow(othercars.car{i}.pos(1:2) ...
                , 2000, othercars.car{i}.pos(3), 'w', 3);
            h.carsarrow{i} = [h1 h2 h3];
        end
        if REALCARSHAPE
            carpos = othercars.car{i}.pos;
            [xmesh_grid, ymesh_grid] = get_carmeshgred(carpos, carwh, rszwh);
            h.carsurf{i} = surf('xdata', xmesh_grid, 'ydata', ymesh_grid ...
                , 'zdata', zeros(rszwh(1), rszwh(2)) ...
                , 'cdata', carrsz, 'AlphaData', trrsz ...
                , 'FaceAlpha', 'texture' ...
                , 'FaceColor', 'texturemap' ...
                , 'EdgeColor','None', 'LineStyle', 'None');
        end
    end
else
    % OTHER CARS
    % for i = 1:othercars.n 
    for i = 1:othercars.MAX_NRCAR
        if SIMPLECARSHAPE
            h.carsfill{i}.Vertices = othercars.car{i}.bd;
            h.carsbd{i}.XData = othercars.car{i}.bd(:, 1);
            h.carsbd{i}.YData = othercars.car{i}.bd(:, 2);
            [x1, y1, x2, y2, x3, y3] = get_arrow(othercars.car{i}.pos, 2000 ...
                , othercars.car{i}.pos(3), 'k', 3);
            h.carsarrow{i}(1).XData = x1; h.carsarrow{i}(1).YData = y1;
            h.carsarrow{i}(2).XData = x2; h.carsarrow{i}(2).YData = y2;
            h.carsarrow{i}(3).XData = x3; h.carsarrow{i}(3).YData = y3;
        end
        if REALCARSHAPE
            carpos = othercars.car{i}.pos;
            [xmesh_grid, ymesh_grid] = get_carmeshgred(carpos, carwh, rszwh);
            h.carsurf{i}.XData = xmesh_grid;
            h.carsurf{i}.YData = ymesh_grid;
        end
    end
    % RANDOM PATHS
    for i = 1:othercars.n
        randpaths = othercars.car{i}.paths;
        npath = size(randpaths, 1)/3;
        if npath > 0
            cpaths = [];
            for j = 1:npath
                cpath = randpaths(3*j-2:3*j, :)';
                cpaths = [cpaths ; NaN NaN ; cpath(:, 1:2)];
            end
            h.paths{i}.XData = cpaths(:, 1);
            h.paths{i}.YData = cpaths(:, 2);
        end
    end    
end
ems = etime(clock, iclk)*1000;

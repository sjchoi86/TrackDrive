function plot_mycar(mycar)
persistent first_flag h
if isempty(first_flag)
    first_flag = true;
end

PLOT_FUTURE_CARPOSES = 0;

mycar_bd = get_carshape(mycar.pos, mycar.W, mycar.H);
pred_hor = 5;
mycar.postemp = mycar.pos;
for i = 1:pred_hor
    mycar.postemp = update_pos(mycar.postemp, mycar.vel, 0.2);
    car_traj(i, :) = mycar.postemp;
    car_trajbd{i} = get_carshape(mycar.postemp, mycar.W, mycar.H);
end
if first_flag
    first_flag = false;
    
    % FUTURE POSITIONS
    if PLOT_FUTURE_CARPOSES
        for i = 1:pred_hor
            [h1, h2, h3] = plot_arrow(car_traj(i, 1:2), 2000, car_traj(i, 3) , 'k', 1);
            h.cartraj{i} = [h1 h2 h3];
            h.cartrajbd{i} = plot(car_trajbd{i}(:, 1), car_trajbd{i}(:, 2), 'k', 'LineWidth', 1);
        end
    end
    % CURRENT POSITION
    h.carfill = fill(mycar_bd(:, 1), mycar_bd(:, 2), 'g');
    h.carbd = plot(mycar_bd(:, 1), mycar_bd(:, 2), 'k', 'LineWidth', 3);
    [h1, h2, h3] = plot_arrow(mycar.pos, 2000, mycar.pos(3), 'k', 3);
    h.cararrow = [h1 h2 h3];
    
else
    % Future pos
    if PLOT_FUTURE_CARPOSES
        for i = 1:pred_hor
            [x1, y1, x2, y2, x3, y3] = get_arrow(car_traj(i, 1:2), 2000, car_traj(i, 3) , 'k', 1);
            h.cartraj{i}(1).XData = x1; h.cartraj{i}(1).YData = y1;
            h.cartraj{i}(2).XData = x2; h.cartraj{i}(2).YData = y2;
            h.cartraj{i}(3).XData = x3; h.cartraj{i}(3).YData = y3;
            h.cartrajbd{i}.XData = car_trajbd{i}(:, 1);
            h.cartrajbd{i}.YData = car_trajbd{i}(:, 2);
        end
    end
    
    % Car pos
    h.carfill.Vertices = mycar_bd;
    h.carbd.XData = mycar_bd(:, 1); h.carbd.YData = mycar_bd(:, 2);
    [x1, y1, x2, y2, x3, y3] = get_arrow(mycar.pos, 2000, mycar.pos(3), 'k', 3);
    h.cararrow(1).XData = x1; h.cararrow(1).YData = y1;
    h.cararrow(2).XData = x2; h.cararrow(2).YData = y2;
    h.cararrow(3).XData = x3; h.cararrow(3).YData = y3;
    
end
function cars = init_cars(W, H)

cars.n = 0;
cars.car = cell(100, 1);
for i = 1:100
    cars.car{i}.pos = [0 0 0]; 
    cars.car{i}.vel = [0 0]; 
    cars.car{i}.W   = W;
    cars.car{i}.H   = H;
end


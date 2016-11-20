function [key_pressed, mycar, sim] ...
    = keybd_handler_trackusage(key_pressed, mycar, sim)

if isequal(key_pressed, '') == 0
    switch key_pressed
        case 'uparrow'
            mycar.vel(1) = mycar.vel(1) + 5000;
        case 'downarrow'
            mycar.vel(1) = mycar.vel(1) - 5000;
        case 'leftarrow'
            mycar.vel(2) = mycar.vel(2) + 20;
        case 'rightarrow'
            mycar.vel(2) = mycar.vel(2) - 20;
        case 'space'
            mycar.vel = [0 0];
        case 'q' % Quit
            sim.flag = -1;
        case 'p' % Pause
            sim.flag = ~sim.flag;
    end
    key_pressed = '';
end
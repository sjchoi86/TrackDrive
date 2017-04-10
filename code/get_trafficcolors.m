function [gcol, ycol, rcol] = get_trafficcolors(type)

gcol = 0.3*[1 1 1];
ycol = 0.3*[1 1 1];
rcol = 0.3*[1 1 1];
switch type
    case 'g'
        gcol = 'g';
    case 'y'
        ycol = 'y';
    case 'r'
        rcol = 'r';
end
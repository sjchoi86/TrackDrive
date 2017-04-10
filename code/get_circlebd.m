function circlebd = get_circlebd(pos, r, n)
% GET CIRCLE BOUNDARY

rads = linspace(0, 2*pi, n)';
cs  = cos(rads);
ss  = sin(rads);
circlebd = repmat(pos(1:2), n, 1) + r*[cs ss];


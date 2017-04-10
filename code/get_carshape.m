function bd = get_carshape(pos, W, H)

x0 = pos(1);
y0 = pos(2);
deg = pos(3);
c = cos(deg*pi/180);
s = sin(deg*pi/180);

x1 = x0 - W/2*c + H/2*s;
y1 = y0 - W/2*s - H/2*c;

x2 = x0 + W/2*c + H/2*s;
y2 = y0 + W/2*s - H/2*c;

x3 = x0 + W/2*c - H/2*s;
y3 = y0 + W/2*s + H/2*c;

x4 = x0 - W/2*c - H/2*s;
y4 = y0 - W/2*s + H/2*c;


gamma = 1;
x12c = gamma*x1 + (1-gamma)*x2;
y12c = gamma*y1 + (1-gamma)*y2;
x34c = gamma*x3 + (1-gamma)*x4;
y34c = gamma*y3 + (1-gamma)*y4;
xc = (x12c + x34c)/2;
yc = (y12c + y34c)/2;
theta1 = atan2(y2-yc, x2-xc);
theta2 = atan2(y3-yc, x3-xc);

nseg = 3;
if theta2 > theta1
    thetas = linspace(theta1, theta2, nseg)';
else
    thetas = linspace(theta1, theta2+2*pi, nseg)';
end
cs = cos(thetas);
ss = sin(thetas);
r = sqrt((x2-xc)^2 + (y2-yc)^2);
seg = repmat([xc yc], nseg, 1) + r*[cs ss];

bd = [x1 y1 ; x2 y2 ; seg ; x3 y3 ; x4 y4 ; x1 y1];
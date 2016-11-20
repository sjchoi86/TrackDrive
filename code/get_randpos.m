function xyrand = get_randpos(field, n)
xrand = [field.xmax - field.xmin]*rand(n, 1) + field.xmin;
yrand = [field.ymax - field.ymin]*rand(n, 1) + field.ymin;

xyrand = [xrand yrand];
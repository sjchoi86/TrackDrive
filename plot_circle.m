function h = plot_circle(xyz, r, color)

[pnt.x, pnt.y, pnt.z] = ellipsoid(xyz(1), xyz(2), xyz(3), r, r, r, 30); % Origin
h  = surf(pnt.x, pnt.y, pnt.z, 'EdgeColor', color, 'FaceColor', color, 'FaceAlpha', 1); 


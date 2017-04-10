function [xmesh_grid, ymesh_grid] = get_carmeshgred(carpos, carwh, rszwh)

[xtemp, ytemp] = meshgrid(linspace(-carwh(1)/2, carwh(1)/2, rszwh(2)) ...
    , linspace(-carwh(2)/2, carwh(2)/2, rszwh(1)));
xvec = xtemp(:);
yvec = ytemp(:);
xyvec = [xvec yvec];
c = cos(carpos(3)*pi/180);
s = sin(carpos(3)*pi/180);
rotmat = [c s ; -s c];
xyvec = xyvec * rotmat + repmat(carpos(1:2), rszwh(1)*rszwh(2), 1);
xvec = xyvec(:, 1);
yvec = xyvec(:, 2);
xmesh_grid = reshape(xvec, rszwh(1), rszwh(2));
ymesh_grid = reshape(yvec, rszwh(1), rszwh(2));

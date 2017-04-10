function nzr_x = init_nz(x)
% NORMALIZE DATA SO THAT MIN AND MAX VALS TO BE +0 AND +1.

n = size(x, 1);
minx = min(x);
maxx = max(x);
rang = maxx - minx;

temp = (x - repmat(minx, n, 1))./repmat(rang, n, 1);

nzr_x.nzd_x = temp;
nzr_x.minx  = minx;
nzr_x.maxx  = maxx;
nzr_x.rang  = rang;

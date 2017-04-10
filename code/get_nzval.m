function nzd_x = get_nzval(nzr_x, x)
% GET NORMALIZED VALUE

n     = size(x, 1);
minx  = nzr_x.minx;
rang  = nzr_x.rang;
nzd_x = (x - repmat(minx, n, 1))./repmat(rang, n, 1);

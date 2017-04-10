function org_x = get_orgval(nzr_x, x)

n     = size(x, 1);
minx  = nzr_x.minx;
rang  = nzr_x.rang;

temp  = x .* repmat(rang, n, 1);
temp  = temp + repmat(minx, n, 1);
org_x = temp;

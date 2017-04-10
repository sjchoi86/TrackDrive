function val = get_kdmrl(kdmrl, feats)
% GET REWARD VALUE FUNCTION KDMRL

n        = size(feats, 1);
nzd_feat = get_nzval(kdmrl.nzr_feat, feats);
Ktestu   = kernel_se(nzd_feat, kdmrl.Xu, ones(n, 1), kdmrl.Lu, kdmrl.hypOpt);
val      = Ktestu*kdmrl.alphathat;

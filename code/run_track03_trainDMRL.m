ccc
%% TRAIN DMRL
ccc

% ACCUMULATE FEATURES FROM THE FOLDER
dirpath = 'data/raw_trajs';
feats = get_feats_folder(dirpath);
nfeats = size(feats, 1);
fprintf('%d FEATURES ARE COLLECTED. \n', nfeats);

% NOMRALIZE DATA (TO BE BETWEEN 0 AND 1)
nzr_feat = init_nz(feats);
nzd_feat = nzr_feat.nzd_x;

% TRAIN KDMRL
Xd = nzd_feat;
Ld = ones(nfeats, 1);
lambda = 1E-2;
beta   = 1E-3;
% MEDIAN TRICK
meds  = get_meds(Xd);
hyp   = [100*meds 1];
kdmrl = init_kdmrl(Xd, Ld, lambda, beta, hyp);
kdmrl.nzr_feat = nzr_feat; % ADD NORMALIZER

% SAVE
savename = 'data/kdmrl/kdmrl.mat';
save(savename, 'kdmrl', 'feats');
fprintf(2, 'KDMRL IS SAVED IN [%s]. \n', savename);

%% THIS IS HOW WE EXTRACT REWARDS OF FEATURES
ccc
loadname = 'data/kdmrl/kdmrl.mat';
l = load(loadname); kdmrl = l.kdmrl; feats = l.feats;
val_train  = get_kdmrl(kdmrl, feats);

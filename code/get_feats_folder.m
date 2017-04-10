function feats = get_feats_folder(dirpath)
% GET FEATURES FROM THE FOLDER

mats  = dir([dirpath '/*.mat']);
nmats = length(mats);
feats = [];
for matidx = 1:nmats
    l = load([dirpath '/' mats(matidx).name]);
    data      = l.traj.data;
    othercars = l.traj.othercars;
    track     = l.traj.track;
    ndata     = data.n;
    for t = 1:ndata
        mycar = data.mycar{t};
        myinfo = data.myinfo{t};
        % GET FEATURES
        feat = get_feat(myinfo);
        feats = [feats ; feat];
    end
end

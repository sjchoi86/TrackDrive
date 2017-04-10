function kdmrl ...
    = init_kdmrl(Xd, Ld, lambda, beta, hypInit)

Xu    = Xd;
Lu    = Ld;
Nd    = size(Xd, 1);
Nu    = size(Xu, 1);
hypOpt = hypInit;
KU = kernel_se(Xu, Xu, Lu, Lu, hypOpt);
KD = kernel_se(Xu, Xd, Lu, Ld, hypOpt);
alphathat = 1/Nd*(lambda*KU + beta*eye(Nu))\KU*KD*ones(Nd, 1);

kdmrl.alphathat = alphathat;
kdmrl.hypOpt    = hypOpt;
kdmrl.Xu        = Xu;
kdmrl.Lu        = Lu;

PLOT_KMTX = 1;
if PLOT_KMTX
    figure(1); imagesc(KU); title('KU'); colorbar;
    figure(2); imagesc(KD); title('KD'); colorbar;
    drawnow;
end
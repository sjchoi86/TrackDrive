function [K, dK] = kernel_se(X1, X2, L1, L2, hyp)

n1 = size(X1, 1);
n2 = size(X2, 1);
d1 = size(X1, 2);
d2 = size(X2, 2);
if d1 ~= d2, fpinrtf(2, 'Data dimension missmatch! \n'); end
d  = d1;

beta  = hyp(end); % Gain
gamma = hyp(1:d); % Inverse Length Parameters

% make sure 'gamma' stays positive
gamma = max(gamma, 1E-10*ones(size(gamma)));

% Compute Kernel Matrix
Gamma = diag(gamma);
temp1 = pdist2(X1, X2, 'mahalanobis', inv(Gamma)).^2;
K = beta*exp(-1/2*temp1) ...
    .*cos(pi/2*pdist2(L1, L2, 'cityblock')) ;

% Limit condition number
sig = 1E-8*beta;
if n1 == n2 && n1 > 10
    K = K + sig*eye(size(K));
end

% Compute Kernel Derivates
if nargin > 1
    dK = zeros(n1, n2, d+1);
    % w.r.t. gamma
    for i = 1:d
        A = -0.5*pdist2(X1(:, i), X2(:, i), 'euclidean').^2;
        dK(:, :, i) = A.*K;
    end
    % w.r.t. gain (beta)
    dK(:, :, d+1) = K/beta;
end

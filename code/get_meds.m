function meds = get_meds(Xd)
% GET MEDIAN VALUES FOR MEDIAN TRICK

n = size(Xd, 1);
d = size(Xd, 2);

meds = zeros(1, d); % ROW VECTOR
for i = 1:d
    meds(i) = median( ...
        pdist( ...
            Xd(randsample(n, min(1000, n)), i))...
        );
end
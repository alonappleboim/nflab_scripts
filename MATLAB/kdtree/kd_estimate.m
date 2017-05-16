function d = kd_estimate(tree, X, bw, k, nk)
%
%
if ~exist('bw','var') || isempty(bw), bw = 1; end
if ~exist('k','var') || isempty(k), k = 20; end
if ~exist('nk','var') || isempty(nk), nk = 1; end
[N,D] = size(X);
if ~exist('w','var') || isempty(w), w = ones(N,1)./N; end

d = nan(N,1);
for xi = 1:N
    [kidx, kdists] = kdtree_k_nearest_neighbors(tree, X(xi,:), k);
    kidx = kidx(nk+1:end);
    kdists = kdists(nk+1:end);
    d(xi) = mean(exp(-(kdists'./bw).^2)) ./ (bw.^(D/2));
end

end
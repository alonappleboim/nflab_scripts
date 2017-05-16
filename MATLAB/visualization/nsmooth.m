function [sf] = nsmooth(X, F, varargin)
% smooth F w.r.t to X. (f:R^D->R^M)
%
% Arguments:
%  X - NxD, N points in R^D.
%  F - NxM, N points in R^M.
%
% Name/Value pairs:
%  sig - smoothing kernel width, default = median l2 norm of X.
%  norm - should kernel be normalized (units of output do not change).
%         default = true.
%  K - number of nearest neighbours to consider, default = 20.
%  nK - number of closest nearest neighbours exclude. default = 1.

assert(size(X,1)==size(F,1), 'f and X should have same length.')
args = parse_namevalue_pairs(struct('sig',[],'K',20,'nK',1,'norm',true),...
                             varargin);
if isempty(args.sig)
    args.sig = median(sqrt(nanmean(X.^2,2)));
end

kdtree = kdtree_build(X);
sf = nan(size(F));
for xi = 1:size(X,1)
    [idx, d] = kdtree_k_nearest_neighbors(kdtree, X(xi,:), args.K+args.nK);
    idx = idx(1+args.nK:end); d = d(1+args.nK:end);
    w = exp(-((d./args.sig).^2));
    if args.norm, w = w./sum(w); end
    sf(xi,:) = nansum(w .* F(idx,:));
end
kdtree_delete(kdtree);
end
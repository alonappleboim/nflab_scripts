function [sF] = nsmooth(X, F, varargin)
% smooth F w.r.t. to X. (f:R^D->R^M)
%
% Written by Alon (2015).
%
% Arguments:
%  X - NxD, N points in R^D.
%  F - NxM, N points in R^M.
%
% Name/Value Arguments:
%  sig - smoothing kernel width, default = median l2 norm of X, centered.
%  K - number of nearest neighbours to consider, default = 20.
%  nK - number of closest nearest neighbours exclude. default = 1.
%
% Returns:
%  sF - smoothed function.
%
% Example:
%  >> X = [mvnrnd([15;10],[2,-2;-2,3],1000); ...
%          mvnrnd([3;4],[3,1.5;1.5,1],500); ...
%          mvnrnd([5;10],[2,0;0,2],800)];
%  >> f = (X(:,1)-X(:,2)).*(1+randn(size(X,1),1).*.5);
%  >> subplot(1,2,1); scatter(X(:,1), X(:,2), 25, f, 'filled');
%  >> subplot(1,2,2); scatter(X(:,1), X(:,2), 25, nsmooth(X,f), 'filled');
%

assert(size(X,1)==size(F,1), 'f and X should have same # of rows.')
args = parse_namevalue_pairs(struct('sig',[],'K',20,'nK',1), varargin);
if isempty(args.sig)
    X = X - ones(size(X,1),1)*nanmean(X);
    args.sig = median(sqrt(nanmean(X.^2,2)));
end

kdtree = kdtree_build(X); %TODO: change to MATLAB's new KDtree object.
sF = nan(size(F));
for xi = 1:size(X,1)
    [idx, d] = kdtree_k_nearest_neighbors(kdtree, X(xi,:), args.K+args.nK);
    idx = idx(1+args.nK:end); d = d(1+args.nK:end);
    w = exp(-((d./args.sig).^2));
    w = w./sum(w);
    sF(xi,:) = nansum(w .* F(idx,:));
end
kdtree_delete(kdtree);
end
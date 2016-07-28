function [p] = kd_estimate(kdtree, Q, sigma, mix, r, k, W)
% kdtree - A KDTree object to query.
% Q - Query data, the data whose denisty is to be etimated. MxD.
% W - weights for the data points in kdtree. optional.
% sigma - kernel width parameter. default = 1;
% r - radius of ball component.
% k - number of nearest neighbours in knn component.
% mix - a scalar in [0,1] denoting the mixture between the ball estimate
%       and knn estimate. 0 means only ball, 1 means only knn. default .1.


if ~exist('sigma','var') || isempty(sigma) sigma = .5; end
if ~exist('r','var') || isempty(r) r = 2; end
if ~exist('k','var') || isempty(k) k = 30; end
if ~exist('mix','var') || isempty(mix) mix = 1; end
if ~exist('W','var') W = []; end

weigh = @(idx)get_weights(idx,W);
density = @(dist,w,sig)w * exp(-(dist./sig).^2);

M = size(Q,1);
p = nan(M,1);
for xi = 1:M
    [kidx, kdists] = kdtree_k_nearest_neighbors(kdtree, Q(xi,:), k);
    if mix < 1
        [bidx, bdists] = kdtree_ball_query(kdtree, Q(xi,:), r);
    end
    
    p(xi) = density(kdists,weigh(kidx),sigma) * mix;
    if mix < 1
        p(xi) = p(xi) + density(bdists,weigh(bidx),sigma) * (1-mix);
    end
end
end

function w = get_weights(idx, W)
if isempty(W)
    w = ones(1,length(idx))/length(idx);
else
    w = W(idx);
end
end
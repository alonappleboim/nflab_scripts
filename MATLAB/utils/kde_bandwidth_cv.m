function bw = kde_bandwidth_cv(X, varargin)
%
% Arguments:
%   X - samples (NxD)
% 
% Name/value pairs:
%   K - fold cross validation
%   knn - number of neighbours to consider in density estimation
%   nknn - closest neighbours to ignore.
%   plot - boolean, default - if no output arguments true, otherwise false.
%
pl = false; if nargout < 1, pl = true; end
args = struct('K',2,'knn',20,'nknn',2,'plot',pl);
args = parse_namevalue_pairs(args, varargin);

[N,D] = size(X);

max_sig = nanmean(sqrt(nansum(X.^2,2)))*D;
sets = randi(args.K,[N,1]);
bw = 0;
for ki = 1:args.K
    trntree = kdtree_build(X(sets~=ki,:));
    obj = @(bw)loss(bw, trntree, X(sets==ki,:), args.knn, args.nknn);
    bw = bw + fminbnd(obj, 0, max_sig)./args.K;
    kdtree_delete(trntree);
end

if args.plot
    res = 30;
    bws = linspace(0,bw*res/4,res);
    lls = nan(1,res);
    for i = 1:res
        lls(i) = obj(bws(i));
    end
    plot(bws, lls, 'linewidth', 3);
    fsl = 20;
    fss = 14;
    xlabel('Kernel Bandwidth', 'fontsize', fsl)
    ylabel('-Log Likelihood (2-CV)', 'fontsize', fsl)
    set(gca,'fontsize', fss)
end

end

function l = loss(bw, tree, test, k, nk)
    l = -sum(log(kd_estimate(tree, test, bw, k, nk)));
end
function [bw, k_hist] = kde_bandwidth_cv(X, varargin)
% Try various smoothing kernel sizes, and select the best one based on
% cross validation.
%
% Written by Alon (2015).
%
% Arguments:
%   X - samples (NxD)
% 
% Name/value Arguments:
%   K - Fold cross validation. default = 4.
%   knn - Number of neighbours to consider in density estimation. default =
%         20.
%   nknn - Closest neighbours to ignore. default = 2.
%
% Returns:
%  bw - The optimal bw.
%  k_hist - A cell array holding optimization per K-batch:
%            k_hist{i}.bw - bandwidths traversed
%            k_hist{i}.loss - the negative log likelihood of the data.
%
% Example:
%  >> X = [mvnrnd([15;10],[2,-2;-2,3],1000); ...
%          mvnrnd([3;4],[3,1.5;1.5,1],500); ...
%          mvnrnd([5;10],[2,0;0,2],800)];
%  >> dscatter(X(:,1),X(:,2)); %see the data
%  >> bw = kde_bandwidth_cv(X);
% 
% TODO: This code uses a KDtree package found in MATLAB central. Since In
% recent versions MATLAB provides a built in KDtree implemetation, so it
% should be used instead...

pl = false; if nargout < 1, pl = true; end
args = struct('K',4,'knn',20,'nknn',2);
args = parse_namevalue_pairs(args, varargin);

[N,D] = size(X);

tmp_hist_x = [];
tmp_hist_val = [];
function stop = logger(x,optimvalues,state)
    if optimvalues.iteration == 0
        tmp_hist_x = [];
        tmp_hist_val = [];
    end
    stop = false;
    if isequal(state,'iter')
        tmp_hist_x = [tmp_hist_x; x];
        tmp_hist_val = [tmp_hist_val; optimvalues.fval];
    end
end
opts = optimset('OutputFcn', @logger);

max_sig = nanmean(sqrt(nansum(X.^2,2)))*D;
sets = randi(args.K,[N,1]);
bw = 0;
k_hist = cell(args.K,1);
for ki = 1:args.K
    trntree = kdtree_build(X(sets~=ki,:));
    obj = @(bw)loss(bw, trntree, X(sets==ki,:), args.knn, args.nknn);
    bw = bw + fminbnd(obj, 0, max_sig, opts)./args.K;
    kdtree_delete(trntree);
    k_hist{ki} = struct();
    k_hist{ki}.bws = tmp_hist_x;
    k_hist{ki}.loss = tmp_hist_val;
end

% bw = bw ./ (N-1./args.K).^(1./D); % TODO? adjust bw to density change due to
% K-sampling. for large enough K It's close to one anyway.
end

function l = loss(bw, tree, test, k, nk)
    l = -sum(log(kd_estimate(tree, test, bw, k, nk)));
end

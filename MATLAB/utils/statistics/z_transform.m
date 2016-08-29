function [data] = z_transform(data, varargin)
%Normalize data assuming it comes from a normal distribution.
%
% Arguments:
%  data - a NxT array (N - samples, T - dimensions).
% 
% Name/Value Arguments:
%  covtype - either:
%             full - a multivariave gaussian is assumed, and data is
%                    normalized to the normal multivariate gaussian.
%             diag - independence between dimenstions is assumed, and each
%                    dimension has its own std.
%             none - no rescaling is performed.
%
% Examples:
%  X = mvnrnd([15;10],[2,-2;-2,3],300);
%  n1 = z_transform(X,'covtype','diag'); 
%  n2 = z_transform(X,'covtype','full');
%  hold all; scatter(X(:,1),X(:,2));
%  scatter(n1(:,1),n1(:,2));
%  dscatter(n2(:,1),n2(:,2));
args = parse_namevalue_pairs(struct('covtype','diag'), varargin);

[tmp, nanidx] = rmnan(data);
[N,M] = size(tmp);
mu = nanmean(tmp);
switch args.covtype
    case 'full'
        sig = nancov(tmp);
    case 'none'
        sig = eye(M);
    case 'diag'
        sig = diag(nanvar(tmp));
end

tmp = (tmp - repmat(mu,N,1))/(sig^.5);
data(nanidx{1},nanidx{2}) = tmp;
data(~nanidx{1},~nanidx{2}) = nan;

function [data] = z_transform(data, covtype)
%Normalize data assuming it comes from a normal distribution.
%
% Arguments:
%  data - a NxT array (N - samples, T - dimensions).
%  covtype - either:
%             full - a multivariave gaussian is assumed, and data is
%                    normalized to the normal multivariate gaussian.
%             diag - independence between dimenstions is assumed, and each
%                    dimension has its own std.
%             none - no rescaling is performed.

if ~exist('covtype','var') || isempty(covtype) covtype = 'diag'; end;

[tmp, nanidx] = rmnan(data);
[N,M] = size(tmp);
mu = nanmean(tmp);
switch covtype
    case 'full'
        sig = nancov(tmp);
    case 'none'
        sig = eye(M);
    case '1d'
        sig = diag(var(tmp));
end

tmp = (tmp - repmat(mu,N,1))/(sig^.5);
data(nanidx{1},nanidx{2}) = tmp;
data(~nanidx{1},~nanidx{2}) = nan;

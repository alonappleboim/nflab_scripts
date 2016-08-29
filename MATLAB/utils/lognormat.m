function N = lognormat(A, dims)
%LOGNORMAT normalize A to 1 along dims, in log space (no loss of precision).
%
% Arguments:
%  A - An array to normalize (in log space!).
%  dims - Dimensions along which to normalize to 1. default is 2 (column).
%
% Example:
%  x = -rand(1000,1)*1000;
%  n1 = log(exp(x) ./ sum(exp(x)));
%  sum(isinf(n2)) % > 0
%  n2 = lognormat(x);
%  sum(isinf(n1) % == 0
%  sum(exp(n1)) % == 1
%  n1(isinf(n1)) = min(n1(~isinf(n1)));
%  scatter(n1,n2,'.');

if ~exist('dims','var')
    if size(A,2) == 1, dims = 1;
    else dims = 2;
    end
end
S = size(A);
dims = dims(dims<=length(S)); %remove irrelevant dimensions.
rep_dims = ones(1,length(S));
rep_dims(dims) = S(dims);
N =  A - repmat(logsum(A,dims), rep_dims);
end
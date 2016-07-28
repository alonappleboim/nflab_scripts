function N = lognormat(A, dims)
%LOGNORMAT normalize A along dims, in log space.
% Arguments:
%   A - matrix to normalize
%   dims - dimensions along which to normalize. default is 2
%          (column)

if ~exist('dims','var') dims = 2; end;
S = size(A);
dims = dims(dims<=length(S)); %remove irrelevant dimensions.
rep_dims = ones(1,length(S));
rep_dims(dims) = S(dims);
N =  A - repmat(logsum(A,dims), rep_dims);
end
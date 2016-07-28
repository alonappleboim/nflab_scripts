function [S,N,X] = scalemat(A, dim)
%NORMAT scale A along dim.
% Arguments:
%   A - matrix to rescale
%   dim - dimension along which to scale. default is 2 (column)
%
% Returns:
%   S - scaled matrix (along dim), lowest is 0, highest is 1.
%   N - min values along dim.
%   X = max values along dim.

if ~exist('dim','var') dim = 2; end;

rep_dims = ones(1,length(size(A))); rep_dims(dim) = size(A, dim);
N = nanmin(A,[],dim);
S = A - repmat(N, rep_dims);
X = nanmax(S,[],dim);
S = S ./ repmat(X, rep_dims);
X = X + N;
end
function S = logsum(X, dims)
%LOGSUM executes: S = log(sum(exp(X)), along dims in a precision-aware
% manner.
%
% Arguments:
%  X - a matrix in log space.
%  dims - The dimensions along which summation is performed,
%         defaults to 1, i.e. rows.
%

if ~exist('dims','var') || isempty(dims), dims = 1; end
S = X;
sdims = sort(dims, 'descend');
for d = sdims
    rep_dims = ones(1,length(size(X))); rep_dims(d) = size(X, d);
    m = max(S, [], d);
    M = repmat(m, rep_dims);
    S = m + log(sum(exp(S-M),d));
    S(isnan(S)) = -inf; %only reason for a NaN is -inf - -inf
end
end
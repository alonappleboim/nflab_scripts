function [X, rem_idx] = rmlogical(X, func, dims, mode)
%rmlogical removes projections of X for which func is true.
%
%   Arguments
%       X - the matrix to be logical-cleaned.
%       func - a point-wise function that outputs a logical array.
%       dims - dimensions along which elements are removed. e.g. if [1] is
%              given (and X is 2 dimensionial) then rows are removed.
%              Defaults to all dims, in order.
%       mode - 'any', 'all', or a number in [0,1]. If 'any' - it's enough
%              for 1 non to exist in projection for it to be removed, if
%              'all', then only if the entire projection is true. A number
%              indicates the threshold in percent. i.e. 'any' == 0.
%              Defatuls to 'all'.
%
%   Returns
%       X - the matrix without logicals.
%       rem_idx - a cell array whose every entry is a logical indexing
%                 vector along dim (from given dims).
%

if ~exist('dims','var') || isempty(dims) dims = 1:ndims(X); end
if ~exist('mode','var') || isempty(mode) mode = 'all'; end

if ischar(mode)
    switch mode
        case 'all'
            th = 1;
        case 'any'
            th = 0;
    end
else
    th = mode;
end

S = size(X);
D = length(S);
all_dims = 1:D;

all_idx = {};
rem_idx = {};
for d = 1:D
    all_idx{d} = 1:S(d);
end

logmap = func(X);
for d = dims
    nd = all_dims((1:D)~=d);
    nlogs = dimsum(logmap, nd);
    d_idx = nlogs./prod(S(nd)) < th | nlogs == 0;
    rem_idx{d} = d_idx;
    all_idx{d} = all_idx{d}(d_idx);
    X = X(all_idx{:});
    all_idx{d} = 1:sum(d_idx);
end

squeeze(X);
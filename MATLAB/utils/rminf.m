function [X, rem_idx] = rminf(X, varargin)
%rminf removes projections of X that conatin infs
%
%   Arguments
%       X - the matrix to be inf-cleaned.
%       dims - dimensions along which infs are removed. e.g. if [1] is
%              given (and X is 2 dimensionial) then rows are removed.
%              Defaults to all dims, in order.
%       mode - 'any', 'all', or a number in [0,1]. If 'any' - it's enough
%              for 1 non to exist in projection for it to be removed, if
%              'all', then only if the entire projection is inf. A number
%              indicates the threshold in percent. i.e. 'any' == 0.
%              Defatuls to 'all'.
%
%   Returns
%       X - the matrix without infs.
%       rem_idx - a cell array whose every entry is a logical indexing
%                 vector along dim (from given dims).
%
%

[X, rem_idx] = rmlogical(X, @(x)isinf(x), varargin{:});
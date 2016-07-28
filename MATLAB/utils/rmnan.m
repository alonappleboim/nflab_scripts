function [X, rem_idx] = rmnan(X, varargin)
%rmnan removes projections of X that conatin nans
%
%   Arguments
%       X - the matrix to be nan-cleaned.
%       dims - dimensions along which nans are removed. e.g. if [1] is
%              given (and X is 2 dimensionial) then rows are removed.
%              Defaults to all dims, in order.
%       mode - 'any', 'all', or a number in [0,1]. If 'any' - it's enough
%              for 1 non to exist in projection for it to be removed, if
%              'all', then only if the entire projection is nan. A number
%              indicates the threshold in percent. i.e. 'any' == 0.
%              Defatuls to 'all'.
%
%   Returns
%       X - the matrix without nans.
%       rem_idx - a cell array whose every entry is a logical indexing
%                 vector along dim (from given dims).
%
%

[X, rem_idx] = rmlogical(X, @(x)isnan(x), varargin{:});
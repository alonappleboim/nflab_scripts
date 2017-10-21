function [xs, perm] = sort_roman(x, dir)
% Sort roman numbers
% 
% Arguments:
%  x - cell array with roman numbers
%
% Optional Argumetns:
%  dir - 'descend', or 'ascend'*
%
% Returns:
%  xs - sorted array
%  perm - the sorting permutation such that xs = x(perm).

if ~exist('dir', 'var'), dir = 'ascend'; end

n = roman2num(x);
[~, perm] = sort(n, dir);
xs = x(perm);

function [sx,sy] = r_lowess(x, y, varargin)
% use robust loess to smooth the data in y w.r.t. x
%
% Arguments:
%  x, y - same length vectors
%
% Name/Value Arguments:
%   p - percent of points to consider. default = .1.
%

args = parse_namevalue_pairs(struct('p',.1), varargin);
[sx,ord] = sort(x);
sy = smooth(sx, y(ord), args.p, 'rlowess');
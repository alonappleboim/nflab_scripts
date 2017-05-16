function [sx, sy, se, ys, ye] = r_lowess(x, y, varargin)
% use robust loess to smooth the data in y w.r.t. x
%
% Arguments:
%  x, y - same length vectors
%
% Name/Value Arguments:
%   p - percent of points to consider. default = .1.
%
% Returns:
%  sx - sorted x values
%  sy - sorted smoothed y values
%  se - sorted local std around smoothed line
%  ys - unsorted smoothed y values
%  ye - unsorted local std around smoothed line.
%
assert(isvector(x), 'x should be a vector')
assert(isvector(y), 'y should be a vector')
if size(x,1) == 1, x = x.'; warning('transposed x'); end
if size(y,1) == 1, y = y.'; warning('transposed y'); end

nidx = isnan(x) | isnan(y);
nx = x(~nidx);
ny = y(~nidx);
args = parse_namevalue_pairs(struct('p',.1), varargin);
[sx, ord] = sort(nx);
sy = smooth(sx, ny(ord), args.p, 'rlowess');
n = round(args.p * length(ny));
se = conv(abs(sy - ny(ord)), ones(n,1)/n, 'same');
[~, iord] = sort(ord);
ys = nan(size(y));
ye = nan(size(y));
ys(~nidx) = sy(iord);
ye(~nidx) = se(iord);
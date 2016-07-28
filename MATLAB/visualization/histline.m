function [x, y] = histline(x, varargin)
% a quantile based histogram
%
%  Arguments:
%   x - data vector
%  Name/value arguments:
%   qs - a list of quantiles to use. default is 0:.1:1
%
args = struct('qs',0:.1:1);
args = parse_namevalue_pairs(args, varargin);

nbins = length(args.qs) - 1;
binarea = 1./nbins;
xs = nan(size(args.qs));

xs(1) = nanmin(x);
for i = 2:nbins+1
    xs(i) = quantile(x, args.qs(i)); %x start
end

dx = diff(xs);
y = [0, binarea./dx, 0];
x = [xs(1), xs(1:end-1)+dx/2, xs(end)];

if nargout < 2
    plot(x,y);
end
end
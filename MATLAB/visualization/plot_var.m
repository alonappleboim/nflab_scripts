function [ah, lh] = plot_var(x, Y, varargin)
% Plot data in Y with background variance error
%
% Arguments
%  x - the x axis for the plot, a Nx1 vector
%  Y - the y axis with repeats in 2nd dimensions, NxM
%
% Name/Value pairs
%  lq - lower quantile to bound background area
%  uq - upeer quantile to bound background area
%  c - color, default is light blue.
%  lc - line color, default is none.
%  
assert(isvector(x), 'x must be a column vector');
if size(x,1) < size(x,2), x = x.'; end
assert(size(x,1)==size(Y,1), ...
       'x and Y must have same size in first dimension');
args = parse_namevalue_pairs(struct('lq',.1,'uq',.9, 'c', [65,105,225]/255,...
                                    'lc', 'none'),...
                             varargin);

lb = quantile(Y,args.lq,2);
ub = quantile(Y,args.uq,2);
m = nanmedian(Y,2);

h = ishold(gca);
ah = fill([x;flipud(x)], [lb;flipud(ub)], args.c, 'edgecolor', args.lc);
ah.FaceAlpha = .5;
hold on;
lh = plot(x, m, 'linewidth', 2, 'color', args.c);
if ~h, hold off; end
end
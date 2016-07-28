function [th,xp,handles] = fdr2(x, y, alpha, dir, toplot)
% given to sample vectors, determine the alpha-FDR value
%
% Arguments:
%  x - values of one population.
%  y - values of other population.
%  alpha - false discovery rate.def=.05.
%  dir - direction of examination: 'ascend'(def) or 'descend'
%  toplot - either 'no', 'zoom' 'full' or 'both'(default: 'no', unless no
%           output arguments, in which case 'both')
%
% Returns:
%   th - the FDR threshold.
%   xp - percent of x that passed FDR threshold.
%   handles - if plotting, 2X4 handles for 2 axes (1-large, 2-small) and
%             4 objects: axes, xCDF yCDF and threshold. or 1X4 handles if
%             only one axes.

if ~exist('alpha','var') || isempty(alpha), alpha = .05; end
if ~exist('dir','var') || isempty(dir), dir = 'ascend'; end
if ~exist('toplot','var') || isempty(toplot)
    if nargout == 0, toplot = 'both'; else toplot = 'no'; end
end
clrs = AdvancedColormap('vs',2);

xzoom_factor = 1;
yzoom_factor = xzoom_factor + 1;

mxval = max(max(x),max(y));
mnval = min(min(x),min(y));
step = (mxval-mnval)/max(length(x),length(y));
[fx,xx] = hist(x(~isnan(x)), mnval:step:mxval);
fx = cumsum(fx); fx = fx./fx(end);
[fy,~] = hist(y(~isnan(y)), mnval:step:mxval);
fy = cumsum(fy); fy = fy./fy(end);
if strcmp(dir, 'descend')
    fx = 1-fx; fy = 1-fy;
    maxi = find(fx*alpha > fy, 1, 'first');
else
    maxi = find(fx*alpha > fy, 1, 'last');
end
if ~isempty(maxi)
    th = xx(maxi);
    xp = fx(maxi);
else
    th = nan;
    xp = 0;
end

switch toplot
    case 'zoom'
        if isnan(th), toplot = 'full';
        else
            z_ax = gca();
            z_xCDF = plot(xx, fx, 'color', clrs(1,:), 'linewidth', 2);
            hold on;
            z_yCDF = plot(xx, fy, 'color', clrs(2,:), 'linewidth', 2);
            z_thl = plot([th,th], ylim, 'r--');
            xlim(th+th/xzoom_factor.*[-1,1])
            ylim([0,xp*yzoom_factor])
            hold off
            handles = [z_ax, z_xCDF, z_yCDF, z_thl];
        end
    case 'full'
        ax = gca()
        xCDF = plot(xx, fx, 'color', clrs(1,:), 'linewidth', 2);
        hold on;
        yCDF = plot(xx, fy, 'color', clrs(2,:), 'linewidth', 2);
        thl = plot([th,th], ylim, 'r--');
        hold off
        handles = [ax, xCDF, yCDF, thl];
    case 'both'
        handles = nan(2,4);
        ax = gca();
        xCDF = plot(xx, fx, 'color', clrs(1,:), 'linewidth', 2);
        hold on;
        yCDF = plot(xx, fy, 'color', clrs(2,:), 'linewidth', 2);
        thl = plot([th,th], ylim, 'r--');
        hold off
        handles(1,:) = [ax, xCDF, yCDF, thl];
        if ~isnan(th)
            if strcmp(dir,'descend')
                z_ax = axes('position',[.55,.55,.3,.3]);
            else
                z_ax = axes('position',[.55,.15,.3,.3]);
            end
            z_xCDF = plot(xx, fx, 'color', clrs(1,:), 'linewidth', 2);
            hold on;
            z_yCDF = plot(xx, fy, 'color', clrs(2,:), 'linewidth', 2);
            z_thl = plot([th,th], ylim, 'r--');
            xlim(th+abs(th)/xzoom_factor.*[-1,1])
            ylim([0,xp*yzoom_factor])
            handles(2,:) = [z_ax, z_xCDF, z_yCDF, z_thl];
        end
end
end
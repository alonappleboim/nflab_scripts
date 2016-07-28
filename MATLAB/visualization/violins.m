function h = violins(X, varargin)
% plot distributions in violin plot
% 
% Arguments:
%  X - NxD matrix or a D-lengthed cell array with data in each entry.
%
% name/value arguments:
%  x - D positions along x axis for violin centers.
%  clrs - Dx3 colors.
%  maxbins - number of bins per violin. optional
%  vwidth - violin width, in fraction of minimum difference between
%           positions.
%
% Returns:
%  h - handles 

[~,D] = size(X);

args = struct('x',1:D, 'clrs', rainbow(D),...
              'maxbins', 20, 'vwidth', .9);
args = parse_namevalue_pairs(args, varargin);

xw = min(abs(diff(args.x))); %x width
if isempty(xw), xw = 1; end
half_violin_width = xw * args.vwidth / 2;
xls = [min(args.x) - xw, max(args.x) + xw]; %x lims

washold = ishold;
h = zeros(D,1);
for di = 1:D
    if iscell(X)
        ddata = X{di};
    else
        ddata = X(:,di);
    end
    nbins = min(max(1,sum(~isnan(ddata))/20),args.maxbins);
    [y, dx] = histline(ddata,'qs',0:1/nbins:1);
    dxm = dx .* (half_violin_width./max(dx));
    sdxm = smooth(dxm)';
    hi = fill([args.x(di)+sdxm,args.x(di)-sdxm(end:-1:1)],...
              [y, y(end:-1:1)],args.clrs(di,:));
    hold on;
    h(di) = hi;
end

set(gca,'xtick', sort(args.x),'xlim', xls);
if ~washold, hold off, end;
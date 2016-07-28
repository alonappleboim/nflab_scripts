function [idx, h] = crosscatter(x, y, varargin)
%scatter x,y with error crosses
% Arguments:
%  x - x coordinates (Nx1)
%  y - y coordinates (Nx1)
%
% Name/Value arguments:
%  xe - x error. Nx1 for symmetric error, Nx2 for left/right error.
%  ye - y error. Nx1 for symmetric error, Nx2 for top/bottom error.
%  c - marker colors. Either a scalar, a scalar vector, or a single rgb
%      color.
%  ms - marker size, as in scatter
%  marker - marker type, as in scatter
%  lc - line color, defult is black, overridden by lcx/lcy.
%  lcx - xline color, default is black.
%  lcy - yline color, default is black.
%  lw - line width, defult is 1, overridden by lwx/lwy.
%  lwx - x line width, default = 1
%  lwy - y line width, default = 1
%  ls - line style, defult is '-', overridden by lsx/lsy.
%  lsx - x line style, default = '-'
%  lsy - y line style, default = '-'
% 
% Returns:
%  the plotted indices (nans/infs are removed)
%  h - a struct with handles for dots hlines and vlines.
defaults = struct('xe',zeros(size(x)), 'ye',zeros(size(y)), 'c', [0 0 0], ...
                  'ms', 15, 'lc', 'k', 'lcx', nan, 'lcy', nan, 'lw', 1, ...
                  'lwx', nan, 'lwy', nan, 'ls', '-', 'lsx', nan, 'lsy', nan, ...
                  'marker', 'o');
args = parse_namevalue_pairs(defaults, varargin);
if isnan(args.lwx), args.lwx = args.lw; end
if isnan(args.lwy), args.lwy = args.lw; end
if isnan(args.lcx), args.lcx = args.lc; end
if isnan(args.lcy), args.lcy = args.lc; end
if isnan(args.lsx), args.lsx = args.ls; end
if isnan(args.lsy), args.lsy = args.ls; end

xe = args.xe; ye = args.ye;

all = x+y+sum(xe,2)+sum(ye,2)+sum(args.c,2);
idx = ~isnan(all) & ~isinf(all);

x = x(idx); y = y(idx); xe = xe(idx,:); ye = ye(idx,:);
assert(sum(xe(:)>=0)==numel(xe) && sum(ye(:)>=0)==numel(ye), ...
       'errors are assumed to be positive');

if size(xe,2) ==1, xe = [xe, xe]; end
if size(ye,2) ==1, ye = [ye, ye]; end
xe = [-xe(:,1),xe(:,2)]';
ye = [-ye(:,1),ye(:,2)]';
rx = [1;1]*x';
ry = [1;1]*y';

tohold = ishold();
if ~tohold, cla; end;
hold on;

h.hlines = plot(rx + xe, ry,'color',args.lcx,'linewidth',...
                args.lwx,'linestyle',args.lsx);
h.vlines = plot(rx, ry + ye,'color',args.lcy,'linewidth',...
                args.lwy,'linestyle',args.lsy);
h.dots = scatter(x,y,args.ms,args.c,args.marker,'filled');

if ~tohold, hold off; end
end
function [h] = egg(x, y, varargin)
%EGG plot an egg ellipse on current axes
%
% Arguments:
%  x,y - data vectors with same length.
%
% name/value pairs:
%  clr - face color of egg (NaN, i.e. unfilled)
%  eclr - edge color of egg (k)
%  res - egg resolution or number of points (100)
%  q - egg quantile to use (.25)
%  rot - should rotate data with its covariance? (true)
%  marker - which marker to denote median of egg ('+')
%  ms - marker size (12)
%  mlw - marker line width (2)
%  elw - egg line width (1.5)
%  ealpha - egg alpha value (.25)
% Returns:
%  h = handles for egg components.
%
args = struct('clr', NaN, 'eclr', [0,0,0],...
              'res', 100, 'q', .25, 'rot', true, 'ealpha', .25,...
              'marker', '+', 'ms', 12, 'mlw', 2, 'elw', 1.5);
args = parse_namevalue_pairs(args, varargin);

if size(x,2) > size(x,1), x = x'; end;
if size(y,2) > size(y,1), y = y'; end;

if args.rot
    [U, ~] = eig(nancov(x,y));
    U = repmat(sign(U(:,1)),1,2).*U;
else
    U = eye(2);
end

x0 = nanmedian(x);
y0 = nanmedian(y);
rotated = U*[x-x0, y-y0].'; %center and rotate
xr = rotated(1,:);
yr = rotated(2,:);

rxr = abs(quantile(xr, 1-args.q));
rxl = abs(quantile(xr, args.q));
ryd = abs(quantile(yr, args.q));
ryu = abs(quantile(yr, 1-args.q));

t = 0:(pi/args.res):pi/2;
ex = [rxr.*cos(t),...
      rxl.*cos(t+pi/2),...
      rxl.*cos(t+pi),...
      rxr.*cos(t+3*pi/2)];
ey = [ryu.*sin(t),...
      ryu.*sin(t+pi/2),...
      ryd.*sin(t+pi),...
      ryd.*sin(t+3*pi/2)];

e = U.'*[ex;ey];

washold = ishold;
hold on;

if ~isnan(args.clr)
    eh = fill(x0+e(1,:), y0+e(2,:), args.clr, 'edgecolor', 'none');
    set(eh, 'facealpha',args.ealpha)
else
    eh = [];
end

hl = plot(x0+e(1,:), y0+e(2,:), 'linewidth', args.elw, 'color', args.eclr);

if ~isempty(args.marker) && ~isnan(args.marker)
    hm = plot(x0,y0,args.marker,'markersize',args.ms,...
              'linewidth',args.mlw, 'color', args.eclr);
end
if ~washold, hold off, end;

h.fill = eh;
h.marker = hm;
h.edge = hl;

end
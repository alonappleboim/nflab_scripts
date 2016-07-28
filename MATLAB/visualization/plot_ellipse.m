function [] = plot_ellipse(center, radii, theta, clr, lclr, res)
%PLOT_ELLIPSE plot an ellipse on current axes
%
% Arguments:
%  center - x;y - center of ellipse
%  radii - a;b - radii of ellipse
%  theta - rotation angle. in radians.
%  clr - color for ellipse face. default = white.
%  lclr - color for ellipse boundary. default = black.
%  res - plot resolution. default = 100.

if ~exist('center','var') || isempty(center) center = [0;0]; end
if ~exist('radii','var') || isempty(radii) radii = [1;1]; end;
if ~exist('theta','var') || isempty(theta) theta = 0; end;
if ~exist('res','var') || isempty(res) res = 100; end;
if ~exist('clr','var') || isempty(clr) clr = 'w'; end
if ~exist('lclr','var') || isempty(lclr) lclr = 'k'; end;
if ~exist('res','var') || isempty(res) res = 100; end;

rotmat = [cos(theta), -sin(theta);
          sin(theta), cos(theta)];
t = 0:(2*pi/res):2*pi;
T = length(t);
E = center*ones(1,T) + rotmat * (radii*ones(1,T).*[cos(t);sin(t)]);
h = fill(E(1,:),E(2,:), clr, 'edgecolor', lclr);
% set(h,'edgecolor',lclr);
end


function [F, X, Y, d] = density2(x, y, varargin)
% DENSITY - return a 2d density function over x and y
% 
% Name/Value Arguments:
%  lambda - smoothing factor. default=10.
%  nbins - #bins in each dimension, or a scalar for symmetric assignment.
%          default=200.
%
% Returns:
%  F - 2d smoothed density estimation
%  X - xoordinates for F
%  Y - yoordinates for F
%  d - density values at input x and y
%  
% Based on dscatter:
% Reference:
% Paul H. C. Eilers and Jelle J. Goeman
% Enhancing scatterplots with smoothed densities
% Bioinformatics, Mar 2004; 20: 623 - 628.

args = parse_namevalue_pairs(struct('lambda', 10, 'nbins', 200), varargin);
if isscalar(args.nbins), args.nbins = [args.nbins, args.nbins]; end;

nidx = ~(isnan(x) | isnan(y) | isinf(x) | isinf(y));
nx = x(nidx); ny = y(nidx);
args.nbins = [min(numel(unique(nx)),args.nbins(1)),...
              min(numel(unique(ny)),args.nbins(2))];

minx = min(nx,[],1);
maxx = max(nx,[],1);
miny = min(ny,[],1);
maxy = max(ny,[],1);

edges1 = linspace(minx, maxx, args.nbins(1)+1);
X = edges1(1:end-1) + .5*diff(edges1);
edges1 = [-Inf edges1(2:end-1) Inf];
edges2 = linspace(miny, maxy, args.nbins(2)+1);
Y = edges2(1:end-1) + .5*diff(edges2);
edges2 = [-Inf edges2(2:end-1) Inf];

[n,~] = size(nx);
bin = zeros(n,2);
% Reverse the columns to put the first column of X along the horizontal
% axis, the second along the vertical.
[~,bin(:,2)] = histc(nx,edges1);
[~,bin(:,1)] = histc(ny,edges2);
H = accumarray(bin,1,args.nbins([2 1])) ./ n;
G = smooth1D(H,args.nbins(2)/args.lambda);
F = smooth1D(G',args.nbins(1)/args.lambda)';
F = F./max(F(:));
ind = sub2ind(size(F),bin(:,1),bin(:,2));
d = nan(size(x));
d(nidx) = F(ind);
end

function Z = smooth1D(Y, lambda)
[m,~] = size(Y);
E = eye(m);
D1 = diff(E,1);
D2 = diff(D1,1);
P = lambda.^2 .* D2'*D2 + 2.*lambda .* D1'*D1;
Z = (E + P) \ Y;
end
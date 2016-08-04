function [F,ctrs1,ctrs2] = density2(x,y, varargin)
% DENSITY - return a 2d density function over x and y
% 
% Name/Value Arguments:
%  lambda - smoothing factor. default=20.
%  nbins - #binsin each dimension, or a scalar for symmetric assignment.
%          default=200.
%
% Based on dscatter:
% Reference:
% Paul H. C. Eilers and Jelle J. Goeman
% Enhancing scatterplots with smoothed densities
% Bioinformatics, Mar 2004; 20: 623 - 628.

args = parse_namevalue_pairs(struct('lambda', 10, 'nbins', 200),varargin);
if isscalar(args.nbins), args.nbins = [args.nbins, args.nbins]; end;

nidx = ~(isnan(x) | isnan(y));
x = x(nidx); y = y(nidx);
args.nbins = [min(numel(unique(x)),args.nbins(1)),...
              min(numel(unique(y)),args.nbins(2))];

minx = min(x,[],1);
maxx = max(x,[],1);
miny = min(y,[],1);
maxy = max(y,[],1);


edges1 = linspace(minx, maxx, args.nbins(1)+1);
ctrs1 = edges1(1:end-1) + .5*diff(edges1);
edges1 = [-Inf edges1(2:end-1) Inf];
edges2 = linspace(miny, maxy, args.nbins(2)+1);
ctrs2 = edges2(1:end-1) + .5*diff(edges2);
edges2 = [-Inf edges2(2:end-1) Inf];

[n,~] = size(x);
bin = zeros(n,2);
% Reverse the columns to put the first column of X along the horizontal
% axis, the second along the vertical.
[~,bin(:,2)] = histc(x,edges1);
[~,bin(:,1)] = histc(y,edges2);
H = accumarray(bin,1,args.nbins([2 1])) ./ n;
G = smooth1D(H,args.nbins(2)/args.lambda);
F = smooth1D(G',args.nbins(1)/args.lambda)';

end

function Z = smooth1D(Y,lambda)
[m,~] = size(Y);
E = eye(m);
D1 = diff(E,1);
D2 = diff(D1,1);
P = lambda.^2 .* D2'*D2 + 2.*lambda .* D1'*D1;
Z = (E + P) \ Y;
end
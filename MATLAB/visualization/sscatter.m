function [h] = sscatter(x, y, c, varargin)
% smoothed scatter
% scatter x and y while coloring them with a smoothed coloring given by c,
% and the x,y distribution.
%
% Arguments:
%  x,y,c - Nx1 vectors
%
% Name/Value pairs:
%  s - sizes Nx1 vector, default = 15.
%  m - marker type, default = 'o'.
%  sig - smoothing kernel width, default = mean norm of data.
%  K - number of nearest neighbours to consider, default = 20.
%  nK - number of closest nearest neighbours exclude. default = 1.

if size(x,1) < size(x,2), x = x'; end
if size(y,1) < size(y,2), y = y'; end

nidx = isnan(x)|isnan(y)|isnan(c);
if ~exist('sig','var'), sig = []; end
args = parse_namevalue_pairs(struct('s',15,'m','o',...
                                    'sig',sig,'K',20,'nK',1),varargin);
tmp = unpack_struct(args);
sc = nsmooth([x(~nidx),y(~nidx)],c(~nidx),tmp{:});

hh = scatter(x(~nidx),y(~nidx),args.s,sc,args.m,'filled');
if nargout > 1, h = hh; end;
end
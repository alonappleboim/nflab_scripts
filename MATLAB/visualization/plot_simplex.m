function plot_simplex(X ,Y, varargin)
% Plot samples on a simplex, each column/cell in X/Y is a sample.
% 
% Arguments:
%  X - non-negative vector (or matrix, or cell array), X+Y need to sum to
%      less than one, in each column.
%  Y - non-negative vector (or matrix, or cell array), X+Y need to sum to
%      less than one, in each column.
%
% Name/Value arguments:
%   vlabels - cell array with 3 strings: {'x','y','z'}
%   type - the type of plot: 'scatter', *'dscatter', 'contour', **'egg', sscatter 
%   plot_mid - draw the mid point of each column: *'none', 'median', 'mean'
%   cmap - a triplet per sample in a Sx3 matrix. ignored if dscatter is
%          type drawn.
%   type_args - a cell array with name/value pair arguments to be passed to
%               the underlying drawing function (e.g. 'markerfacecolor' for
%               'scatter', or 'msz' for 'egg'). see individual drawing
%               funcitons. additional arguments for 'scatter':
%                   'ms' - marker size, as in 3rd argument of scatter
%                   'c' - color, as in 4th argument of scatter
%
% * - default for single sample, ** - default for multiple samples
%
% Usage example:
%
% clf;
% p = rand(1000,3)+repmat([0 0 .5],1000,1);
% p = normat(p,2);
% q = rand(3000,3)+repmat([.2 .2 0],3000,1);
% q = normat(q,2);
% subplot(2,2,1);
% plot_simplex(p(:,1),p(:,2));
% subplot(2,2,2);
% plot_simplex(p(:,1),p(:,2),'vlabels',{'\phi','u','m'},'type','egg','type_args',{'msz',10,'q',.05,'clr',[1,1,0],'mclr',[0 0 0]});
% subplot(2,2,3);
% plot_simplex(q(:,1),q(:,2),'type','contour','type_args',{'showtext','on'});
% subplot(2,2,4);
% plot_simplex({q(:,1),p(:,1)},{q(:,2),p(:,2)});
%
TYPES = {'contour','scatter','dscatter','sscatter','egg'};
[X,Y,Z,S] = format_xy(X,Y);
args = parse_input(varargin, S, TYPES);
base = normc([1,0.5,1 ; -1,0.5,1; 0,-1,1]); %change base to the symplex plane
rot = [cos(-pi/6) -sin(-pi/6) ;sin(-pi/6) cos(-pi/6)]; % rotate in 30 deg
vertices = rot * base(:,1:2).';
hold on;
plot(vertices(1,[1:3,1]),vertices(2,[1:3,1]),'--k');

% collect data to plot
m = [];
for si = 1:S
    d = [X{si},Y{si},Z{si}];
    midp = get_mid_point(d, args.plot_mid);
    midp = midp./nansum(midp);
    midp = midp * base;
    
    % transform to a new base (to get an equilateral triangle)
    %toPlot = (base'*[X(:,c),Y(:,c),Z(:,c)]')';
    %avgP(1:3) = base' * avgP(1:3)';
    d = d * base;
    d = (rot * d(:,1:2).').';

    % and draw
    switch args.type
        case 'scatter'
            scatter_wrapper(d(:,1), d(:,2), args.type_args, args.cmap(si,:));
        case 'dscatter'
            dscatter(d(:,1), d(:,2), args.type_args{:});
        case 'egg'
            e = egg(d(:,1), d(:,2), 'clr', args.cmap(si,:), args.type_args{:});
            midp = e.marker;
        case 'contour'
            [f,x,y] = density2(d(:,1), d(:,2));
            contour(x,y,f,3,'color',args.cmap(si,:), args.type_args{:});
        case 'sscatter'
            sscatter_wrapper(d(:,1), d(:,2), args.type_args);
    end
    m = [m; midp];
end

if ~strcmp(args.plot_mid,'none')
    for si = 1:S
        mp = rot * m(si,1:2).';     
        plot(mp(1),mp(2),12,'o','markerfacecolor',args.cmap(si,:));
    end
end

% Edit figure;
ylim([-0.8,1]);
xlim(ylim+0.2);
set(gca,'xtick', [], 'ytick', [], 'fontsize', 14); %,'visible','off');
text([0.9,-0.5,-0.6], [0,0.8,-0.8], args.vlabels, 'fontsize', 12, 'FontWeight', 'bold')
axis square;
% set(gcf,'color','w');
axis off;
hold off;
end

function [X,Y,Z,S] = format_xy(X,Y)
% return cell arrays of groups to plots, each cell triples (X{i}, Y{i}, 
% Z{i} holds three (column) vectors that are non-negative and sum to 1.
% S is the number of samples (groups/triplets).

assert(all(size(X)==size(Y)), 'X and Y shapes must be identical');
[N,S] = size(X);
if isnumeric(X)
    X = mat2cell(X, N, ones(1,S));
    Y = mat2cell(Y, N, ones(1,S));
end
assert(all(cellfun(@(x)length(x),X)==cellfun(@(x)length(x),Y)),...
       'each corresponding element in X and Y must be a vector of identical size');
Z = cell(1,S);
for si = 1:S
    assert(isvector(X{si})&isvector(Y{si}),...
           'each corresponding element in X and Y must be a vector of identical size')
    if size(X{si},1) < size(X{si},2), X{si} = X{si}.'; end
    if size(Y{si},1) < size(Y{si},2), Y{si} = Y{si}.'; end
    Z{si} = 1-X{si}-Y{si};
    assert(all(X{si}>=0) & all(Y{si}>=0) & all(Z{si}>=0),...
           ['all X and Y elements must be between 0 and 1 and must ',...
           'element-wise sum to a number between 0 and 1'])
end
if size(X,1) > size(X,2), X = X.'; end %X,Y,Z should be horizontal, their insides are vertical.
if size(Y,1) > size(Y,2), Y = Y.'; end
if size(Z,1) > size(Z,2), Z = Z.'; end
end

function midp = get_mid_point(d, plot_mid)
switch plot_mid
    case 'median'
        midp = nanmedian(d,1);
    case 'mean'
        midp = nanmean(d,1);
    otherwise
        midp = nan(1,3);
end
end

function args = parse_input(vargs, S, TYPES)
defc = AdvancedColormap('vk vbk bk bsk sk sgk gk ogk ok ork rk kk', S);
dtype = 'dscatter';
if S > 1
    dtype = 'egg';
end
if S < 12
    defc = defc(1:S,:);
end
defs = struct('type', dtype, 'plot_mid', 'none', 'cmap', defc, 'vlabels', [], 'type_args', []);
args = parse_namevalue_pairs(defs, vargs);
if isempty(args.vlabels), args.vlabels = {'x','y','z'}; end
if isempty(args.type_args), args.type_args = {}; end
assert(size(args.cmap,1)==S, 'number of colors must match number of samples')
if ~any(cellfun('isempty',strfind(TYPES,args.type)))
    error('unknown plot type');
end
end

function [] = scatter_wrapper(x, y, args, defc)
args = reshape(args,[2,length(args)/2]);
ms = 30;
c = defc;
i = find(~cellfun('isempty',strfind(args(1,:),'ms')));
if ~isempty(i)
    ms = args{2,i};
    args = [args(:,1:i-1), args(:,i+1:end)];
end
i = find(~cellfun('isempty',strfind(args(1,:),'c')));
if ~isempty(i)
    c = args{2,i};
    args = [args(:,1:i-1), args(:,i+1:end)];
end
scatter(x, y, ms, c, 'fill', args{:});
end

function [] = sscatter_wrapper(x, y, args)
args = reshape(args,[2,length(args)/2]);
i = find(~cellfun('isempty',strfind(args(1,:),'c')));
if ~isempty(i)
    c = args{2,i};
    args = [args(:,1:i-1), args(:,i+1:end)];
else
    error('When using sscatter, a "c" field is mandatory')
end
sscatter(x, y, c, args{:});
end

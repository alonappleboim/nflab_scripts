function h = boxes(X, varargin)
% plot distributions in box plot
% 
% Arguments:
%  X - NxD matrix.
% Name/value pairs:
%  x - D positions along x axis for box centers.
%  clrs - Dx3 colors.
%  wq - whiskers quantile.
%  bq - box quantile.
%  bwidth - box width, in fraction of total box width.
%  balpha - box tranparency.
%
% Returns:
%  h - handles h{:,3} = boxes, h{:,1} = whiskers, h{:,2} = medians.

[N,D] = size(X);

args = parse_namevalue_pairs(struct('x',1:D,'clrs', rainbow(D), 'wq', .1,...
                             'bq',.25,'bwidth',.8,'balpha',.5), varargin);

xw = min(abs(diff(args.x))); %x width
if isempty(xw), xw = 1; end
hbw = xw * args.bwidth / 2;
if iscell(X)
    lw = cellfun(@(x)quantile(x,args.wq), X);
    hw = cellfun(@(x)quantile(x,1-args.wq), X);
    lb = cellfun(@(x)quantile(x,args.bq), X);
    hb = cellfun(@(x)quantile(x,1-args.bq), X);
    med = cellfun(@(x)quantile(x,.5), X);
else
    lw = quantile(X,args.wq);
    hw = quantile(X,1-args.wq);
    lb = quantile(X,args.bq);
    hb = quantile(X,1-args.bq);
    med = quantile(X,.5);
end

hold on;
h = cell(D,3);
for di = 1:D
    c = args.clrs(di,:);
    %plot whiskers
    hhw = plot(args.x(di).*[1,1], [hb(di), hw(di)],'-','linewidth', 3, 'color', c);
    hhw(2) = plot(args.x(di)+hbw.*[-1,1]./2, [1,1].*hw(di), 'linewidth', 3, 'color', c);
    hlw = plot(args.x(di).*[1,1], [lb(di), lw(di)],'-','linewidth', 3, 'color', c);
    hlw(2) = plot(args.x(di)+hbw.*[-1,1]./2, [1,1].*lw(di), 'linewidth', 3, 'color', c);
    h{di,1} = [hlw,hhw];
    
    %median
    h{di,2} = plot([args.x(di)-hbw, args.x(di)+hbw], [med(di), med(di)], 'linewidth', 3, 'color', c);
    
    %plot box
    h{di,3} = patch([args.x(di)-hbw, args.x(di)+hbw, args.x(di)+hbw, args.x(di)-hbw],...
                    [lb(di), lb(di), hb(di), hb(di)], c, 'linewidth',1.5);
    set(h{di,3},'FaceAlpha',args.balpha);
end

hold off;
if nargout < 1
    clear h
end
function [hs] = eggs(X, Y, varargin)
%EGGS plot data eggs in 2d space
%
% Arguments:
%  X - NxD matrix for x data (or a pair of cell arrays of size 1xD)
%  Y - NxD matrix for y data (or a pair of cell arrays of size 1xD)
%
% Name/Value Arguments:
%  q - quantile {.1};
%  c - eggs color, either a single color, or a list of D colors {rainbow(D)}.
%  names - if these D names are given, they are written along side the
%          medians {}.
%  mclr - median color, a single color {[0,0,0]}.
%  mmrkr - median marker {'+'}.
%  msz - median marker size {25}.
%  alpha - alpha. default {.3}.
%  rotate - whether covariance(rotation) should be considered or not {true}.
%  line_only - whether only perimeter of eggs should be drawn (good for EPS
%              printing) {false}.
%  lw - egg line width.
%
% Returns
%  hs - eggs handle structure array

[X, D] = tocell(X);
args = parse_namevalue_pairs(struct('q', .1, 'c', rainbow(D), 'names', 0, ...
                                    'mclr', [0 0 0], 'mmrkr', '+', 'msz', 50,...
                                    'alpha', .3, 'rotate', true, 'single_names', ...
                                    false, 'line_only', false, 'lw', 2),...
                             varargin);
if ~iscell(args.names), args.names = {}; end;
Y = tocell(Y);
    
if size(args.c,1) == 1, args.c = repmat(args.c,D,1); end
assert(size(args.c,1) == D, ...
       'Does the number of colors match the number of eggs?');
assert(0 < args.q && args.q < .5, 'q should be between 0 and .5');

clr = nan;
for di = 1:D
    eclr = args.c(di,:);
    if ~args.line_only, clr = eclr; end
    h = egg(X{di},Y{di}, 'clr', clr, 'eclr', eclr, 'ealpha', args.alpha, ...
            'rot', args.rotate, 'q', args.q, 'marker', args.mmrkr, ...
            'ms',args.msz, 'elw', args.lw);
    if di == 1, hs = h;
    else hs = [hs;h]; end
end

if ~isempty(args.names)
    unit = diff(xlim)/50;
    xc = cell2mat(get([hs.marker],'xdata'));
    yc = cell2mat(get([hs.marker],'ydata'));
    th = text(xc+unit, yc-unit, args.names);
    for di = 1:D, hs(di).text = th; end
end

end

function [out, D] = tocell(in)
    if iscell(in)
        D = length(in);
        out = in;
    else
        [~,D] = size(in); out = cell(1,D);
        for di = 1:D, out{di} = in(:,di); end
    end
end
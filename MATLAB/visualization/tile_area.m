function axs = tile_area(N, varargin)
% Tile the area with N tiles.
% Arguments:
%  N - number of tiles, if a scalar, optimal ratio between rows and columns
%      is calculated from screen dimensions.
%
% Name/Value Arguments:
%  area - a rectangle with (blx, bly, width, height). (blx/y = bottom left
%         x/y). default - [.02, .05, .96, .9]. 
%  gap - a gap between all tiles and area periphary in percent of area.
%        default - .02 of minimum(height/width).
%  hgap - horizontal gap in percent of width (overrides gap)
%  vgap - vertical gap - in percent of height (overrdies gap)
%  margin - margins around tile area (default is gap).
%  hmargin - horizontal margin, in both sides of area (default is hgap).
%  vmargin - vertical margin, in top/bottom of area (default is vgap).
%  emargin - east margin, overrides hmargin only on left side of area.
%  wmargin - wast margin, overrides hmargin only on right side of area.
%  nmargin - north margin, overrides vmargin only on top side of area.
%  smargin - south margin, overrides vmargin only on bottom side of area.
%
% Returns:
%  A struct array shaped as on screen, with fields:
%    pos - axes position on figure
%    ax - the axes
%
defaults = struct('area', [.02, .05, .96, .9], 'gap',-1, ...
                  'margin', -1, 'hgap', -1, 'vgap', -1, ...
                  'hmargin', -1, 'vmargin', -1, 'emargin', -1, ...
                  'wmargin', -1, 'nmargin', -1, 'smargin', -1);
args = parse_namevalue_pairs(defaults, varargin);
blx = args.area(1); bly = args.area(2);
w = args.area(3); h = args.area(4);
args = set_defaults(args, w, h);

axs = struct();
if isscalar(N)
    pos = get(gcf, 'position');
    [R, C] = optimal_subplot_dims(N, w*pos(3), h*pos(4));
else
    R = N(1); C = N(2);
end

tilew = (w - (args.wmargin + args.emargin + args.hgap*(C-1))) / C;
tileh = (h - (args.nmargin + args.smargin + args.vgap*(R-1))) / R;
for ri = 1:R
    for ci = 1:C
        pos = [blx + args.wmargin + (ci-1)*(tilew+args.hgap), ...
               bly + h - args.nmargin - ri*tileh - (ri-1)*args.vgap, ...
               tilew, tileh];
        axs(ri,ci).pos = pos;
        axs(ri,ci).ax = axes('position', pos);
    end
end
end

function args = set_defaults(args, w, h)
if args.gap == -1, args.gap = .02*min(w,h); end;
if args.hgap == -1, args.hgap = w*args.gap; end;
if args.vgap == -1, args.vgap = h*args.gap; end;
if args.margin == -1, args.margin = args.gap; end;
if args.hmargin == -1, args.hmargin = w*args.margin; end;
if args.vmargin == -1, args.vmargin = h*args.margin; end;
if args.emargin == -1, args.emargin = w*args.hmargin; end;
if args.wmargin == -1, args.wmargin = w*args.hmargin; end;
if args.nmargin == -1, args.nmargin = h*args.vmargin; end;
if args.smargin == -1, args.smargin = h*args.vmargin; end;
end
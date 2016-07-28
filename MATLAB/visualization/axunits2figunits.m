function cpoints = axunits2figunits(points)
%convert points in current axis units into figure units in [0,1].
P = length(points);
axo = get(get(gcf,'CurrentAxes'),'Position');%get axes position on the figure. 
xs = axo(1); ys = axo(2); xl = axo(3); yl = axo(4);
xls = get(gca, 'xlim');
yls = get(gca, 'ylim');
xu = xl/abs(diff(xls)); % x unit
yu = yl/abs(diff(yls)); % y unit
ydir = ~strcmp(get(gca,'ydir'),'normal');
xdir = ~strcmp(get(gca,'xdir'),'normal');

cP = ones(P,1);
uF = cP * [xu*(-1)^xdir, yu*(-1)^ydir];
oF = cP * [xs+xdir*xl, ys+ydir*yl];
cpoints = oF + (points - cP * [xls(1),yls(1)]) .* uF;
end
function rsq = r_squared(y, p)
% Calculate the R^2 statistic for response y w.r.t. prediction p
%
rsq = 1 - nansum((y-p).^2)/nansum((y-nanmean(y)).^2);
end
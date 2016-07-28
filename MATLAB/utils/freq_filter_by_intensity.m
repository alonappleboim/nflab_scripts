function f_x = freq_filter_by_intensity(x, th)
% x - data to filter.
% threhsold - percentile threshold. defaults to .95.
if ~exist('th', 'var') || isempty(th)
    th = .95;
end
xF = fftn(x);
f_xF = xF(:);
I = abs(f_xF) > quantile(f_xF, th);
f_xF = reshape(f_xF.*I, size(xF));
f_x = ifftn(f_xF);
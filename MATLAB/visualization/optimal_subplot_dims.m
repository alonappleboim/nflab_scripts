function [R,C] = optimal_subplot_dims(N, w, h)
% calculate optimal [#rows #columns] given number of plots(N) and using
% current desired width height (default are current figure dimensions,
% only their ratio matters).
%
if ~exist('w','var') || ~exist('h','var') || isempty(w) || isempty(h)
    pos = get(gcf, 'position');
    w = pos(3); h = pos(4);
end
ratio = w/h;

R = 1;
while true
    C = ceil(N/R);
    if C/R < ratio, break, end
    R = R + 1;
end
end


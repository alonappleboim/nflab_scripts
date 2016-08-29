function [sorted, order] = nansort(x)
% Sort x but keep NaNs in their original positions.
% 
% Arguments:
%  x - a vector to sort.
% 
% Example:
%  >> x = randi(100,[100,1]);
%  >> x(rand(100,1)<.3) = nan;
%  >> plot(1:100,nansort(x),'.',1:100,sort(x),'--')
%
sorted = nan(size(x));
nnan  = ~isnan(x);
nnan_idx = find(nnan);
[sorted(nnan), tmpord] = sort(x(nnan));
order = 1:length(sorted);
ncs = cumsum(~nnan);
order(nnan) =  ncs(nnan_idx(tmpord)) + tmpord;

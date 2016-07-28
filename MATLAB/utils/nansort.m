function [sorted, order] = nansort(x)
sorted = nan(size(x));
nnan  = ~isnan(x);
nnan_idx = find(nnan);
[sorted(nnan), tmpord] = sort(x(nnan));
order = 1:length(sorted);
ncs = cumsum(~nnan);
order(nnan) =  ncs(nnan_idx(tmpord)) + tmpord;

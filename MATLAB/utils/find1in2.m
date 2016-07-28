function idx = find1in2(s1,s2)
%for each string in s1, finds the first position in s2 that contains it
% (ignoring case)

idx = nan(size(s1));
for si = 1:length(s1)
    q = sprintf('^%s$',s1{si});
    idx(si) = find(~cellfun('isempty',regexpi(s2,q)),1,'first');
end
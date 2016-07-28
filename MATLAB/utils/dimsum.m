function s = dimsum(X, dims)
%DIMSUM sum X along dims

s = X;
for d = dims
    s = sum(s,d);
end
s = squeeze(s);
end
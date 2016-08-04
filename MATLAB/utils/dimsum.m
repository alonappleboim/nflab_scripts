function s = dimsum(X, dims)
%DIMSUM sum X along multiple dims
for d = dims, s = sum(X,d); end
s = squeeze(s);
end
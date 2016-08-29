function s = dimsum(X, dims)
% Sums X along multiple dimensions.
%
% Arguments:
%  X - array to sum.
%  dims - dims to sum along.
%
% Returns:
%  A ndims(X)-length(dims) array with every entry corresponding to the
%  summation over all dimensions in dims.
%
% Examples:
%  >> X = cat(3, 2*ones(4,2),4*ones(4,2));
%  >> dimsum(X,[1,3]); % = [24, 24]
s = X;
if size(dims,1) ~= 1, dims = dims.'; end;
for d = dims
    s = sum(s,d);
end
s = squeeze(s);
end
function [ev, exi] = absmax(X, dim)
% Return the signed maximal absoulte value (and index) along any dimension.
%
% Written by Alon (2015).
% 
% Arguments:
%  X - an array.
%  dim - dimension. default = 1.
%
% Returns:
%   the value of the absoluteley extreme entry along dim, and the index along
%   dim in which it is found.
%
% Examples:
%  extreme_value([10,2,-17]); % = {[10,2,-17],[1,1,1]}. 
%  extreme_value([10,2,-17]'); % = {-17,3}. 
%  extreme_value([10,2,-17],2); % = {-17,3}.


if ~exist('dim','var') || isempty(dim), dim = 1; end
S = size(X);
[ev, exi] = nanmax(abs(X),[],dim);
allinds = cell(1,ndims(X));
for di = 1:ndims(X)
    if di == dim
        allinds{di} = exi(:);
    else
        mulby = true(size(S));
        mulby(di) = false; mulby(dim) = false;
        allinds{di} = repmat((1:size(X,di))', prod(S(mulby)),1);
    end
end
inds = sub2ind(size(X), allinds{:});
ev = ev .* sign(reshape(X(inds),size(ev)));
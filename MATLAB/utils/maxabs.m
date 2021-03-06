function [ma, mai] = maxabs(X, dim)
% Return the signed maximal absoulte value (and index) along any dimension.
%
% Written by Alon (2015).
% 
% Arguments:
%  X - an array.
%  dim - dimension. default = 1.
%
% Returns:
%   the signed value of the absoluteley maximal entry along dim, and the index along
%   dim in which it is found.
%
% Examples:
%  maxabs([10,2,-17]); % = {[10,2,-17],[1,1,1]}. 
%  maxabs([10,2,-17]'); % = {-17,3}. 
%  maxabs([10,2,-17],2); % = {-17,3}.


if ~exist('dim','var') || isempty(dim), dim = 1; end
S = size(X);
cf = prod(S)./S(dim); %row and column factor, see reshapr below
rf = 1; 
[ma, mai] = nanmax(abs(X),[],dim);
allinds = cell(1,ndims(X));
for di = 1:ndims(X)
    if di == dim
        allinds{di} = mai(:);
    else
        idx = repmat(1:size(X,di), rf, cf./size(X,di));
        allinds{di} = idx(:);
        rf = rf .* size(X,di);
        cf = cf ./ size(X,di);
    end
end
inds = sub2ind(size(X), allinds{:});
ma = ma .* sign(reshape(X(inds),size(ma)));
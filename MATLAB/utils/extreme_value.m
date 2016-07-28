function ev = extreme_value(X, dim)
%return the extreme value along dimension dim (default = 1).

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
function [sym] = symmetrize(clrs, rev)
if ~exist('rev','var') || isempty(rev) rev = false; end

N = size(clrs,1);
fwd = [1:N] * (~rev) + [N:-1:1] * rev;
bwd = fwd(end-1:-1:1);

sym = [clrs(fwd,:); clrs(bwd,:)];
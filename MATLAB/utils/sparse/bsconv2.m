function C = bsconv2(S, ker, B, trunc)
% Arguments:
%  S - a sparse matrix. assumed to be highly rectengular (e.g. 1e2 X 1e6).
%  ker - the kernel for convultion, assumed to be much smaller than S
%  B - batch size, along larger dimension of S
%  trunc - after each convolution, truncate this fraction of the non-zero
%          entries (to keep certain matrix sparsity). default is a quarter 
%
% Returns:
% C - the resulting convolution.
%
% See also: sconv2

L = size(S,1);
K = size(ker, 2);
if ~exist('trunc','var') || isempty(trunc), trunc = min(.9,max(ker(:))*K*2); end
if ~exist('B','var') || isempty(B), B = round(1e8/(L*K)); end; % the 1e8 is due to memory constraints of the system.
S = [sparse(L,K),S,sparse(L,K)]; %pad
C = recursive_conv(S,ker,B,K,trunc); %solve
end

function C = recursive_conv(S,ker,B,K,nzq)
N = size(S,2);
if N < B
    C = sconv2(S, ker,'same');
    nzc = C(C>0);
    C(C>0 & C<quantile(nzc, nzq)) = 0; %further sparsify
else
    mid = round(N/2);
    C1 = recursive_conv(S(:,1:mid+K), ker, B, K, nzq);
    C2 = recursive_conv(S(:,mid-K+1:end), ker, B, K, nzq);
    C = [C1(:,K+1:end), C2(:,1:end-K)];
end

end
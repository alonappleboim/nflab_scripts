function [passed, t] = fdr2(X, B, alpha)
% given a sample matrix X, and a background matrix B, determine the
% instances per column (i) such that:
%   Pr_B_i(X_i<t) < alpha
% Where t is the maximum threshold that holds the condition.
%

[N,D] = size(X);
if ~exist('alpha','var') || isempty(alpha), alpha = .05; end

idxs = [ones(size(X));zeros(size(B))];
[S, ord] = sort([X;B]);
idxs = idxs(ord);
ratios = cumsum(idxs==1)./cumsum(idxs==0);
t = nan(1,D);
for di = 1:D
    i = find(ratios(:,di)>1/alpha,1,'last');
    if isempty(i)
        t(di) = nan;
    else
        t(di) = S(i,di);
    end
end

passed = X < ones(N,1)*t;
function [D] = discretize(x, q)
% Partition x (a vector) according to its values.
%   
% Arguemnts:
%  x - a vector.
%  q - either a fraction, in which case interpreted as a quantile in the
%      data for partition, or an integer, in which case treated as a
%      desired set number in the partition.

if q > 1
    n_sets = q;
else
    n_sets = floor(1/q);
end
[~, ord] = sort(x);
N = length(x);
D = zeros(1,N);
set_size = round(max(1, N/n_sets));
for i = 1:n_sets % should be optimized
    min_ind = (i-1)*set_size+1;
    max_ind = max(min(set_size*i, N), (i==n_sets) * N);
    D(ord(min_ind:max_ind)) = i;
end

%
% upgrade to this version...
%
% function [D] = discretize(X, q)
% % Partition each column in X (a matrix) to discrete setes according
% % to its values.

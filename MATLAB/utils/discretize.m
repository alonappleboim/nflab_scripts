function [D] = discretize(x, q)
% Partition x (a vector) according to its values.
%   
% Arguemnts:
%  x - a vector.
%  q - either a fraction, in which case interpreted as a quantile in the
%      data for partition, or an integer, in which case treated as a
%      desired set number in partition.

if q > 1
    n_sets = q;
else
    n_sets = floor(1/q);
end
[~, ord] = sort(x);
N = length(x);
D = zeros(1,N);
set_size = round(max(1, N/n_sets));
for i = 1:n_sets
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
% %   
% % Arguemnts:
% %  x - a vector.
% %  q - a vector of discrete boundary quantiles. If a scalar is given, it
% %      can either be a fraction, representing quantile resolution, or an
% %      integer representing number of sets (uniform quantiles).
% %
% set_size = parseq(q, size(X,1));
% [~, ord] = sort(x);
% N = length(x);
% D = zeros(1,N);
% set_size = round(max(1, N/n_sets));
% for i = 1:n_sets
%     min_ind = (i-1)*set_size+1;
%     max_ind = max(min(set_size*i, N), (i==n_sets) * N);
%     D(ord(min_ind:max_ind)) = i;
% end
% 
% end
% 
% function q = parseq(q, N)
% if isscalar(q)
%     if q > 1
%         q = 0:1/q:1;
%     else
%         q = 0:q:1;
%     end
% end
% if q(1) == 0, q = q(2:end); end
% if 
% end
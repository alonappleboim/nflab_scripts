function [ A ] = samplemat(A, p, dims)
%SAMPLEMAT Sample proportion ~p from matrix A along dim
%
% Arguments:
%   A - The matrix to be sampled.
%   p - Proportion to sample. Defaults to .1 (i.e. 10%). If a vector, and
%       dims is not given, the first length(p) dims are sampled.
%   dims - Dimension(s) along which to sample. Defaults to 1 (i.e. rows).

if ~exist('p', 'var') || isempty(p) p = .1; end
if ~isscalar(p)
    if ~exist('dims', 'var') || isempty(dims)
        dims = 1:length(p);
    end
end
if ~exist('dims', 'var') || isempty(dims) dims = 1; end;

if isscalar(p) p = ones(size(dims)) * p; end;

assert(length(dims) == length(p), 'p and dims must have the same length.')

S = size(A);
D = length(S);

all_idx = {1, ndims(A)};

for d = 1:D
    all_idx{d} = true(1,S(d));
end

for di = 1:length(dims)
    d = dims(di);
    all_idx{d} = rand(1,S(d)) <= p(di);
end

A = A(all_idx{:});


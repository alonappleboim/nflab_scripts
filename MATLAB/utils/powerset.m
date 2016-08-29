function P = powerset(N)
% for a number, N, returns all subsets of 1..N in the form of a logical
% matrix, P, with dimensions 2.^NxN, such that P(i,j) is true iff element j
% is in subset i.
P = dec2bin(0:(2.^N-1))=='0';
end
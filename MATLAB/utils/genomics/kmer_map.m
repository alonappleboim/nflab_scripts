function kmers = kmer_map(idx, alphabet, A, k)
% A converter from indices of k-mers from "alphabey" to strings.
% 
% Written by Alon (2015).
%
% Arguments:
%  idx - a list of indices of kmers made of letters in Alphabet.
%  alphabet - the alphabet used for calculation.
%  A - the length of the alphabet.
%  k - the length of a kmer.
%
nidx = (idx > A^k) | (idx < 1); %make sure indices are valid kmer indices.
kmers = repmat('~', length(idx), k); %default char is for invalid indices
if ~all(nidx)
    kmers(~nidx, :) = alphabet(bchr2num(dec2base(idx(~nidx)-1, A, k))+1);
end
end

 
function N = bchr2num(C)
% C is assumed to be a numeric representation in chars of a number in some
% base, e.g. in base 12 (A=10, B=11) 'A2'=10*12+2*1=122. C can be a vector,
% for example: C = ['A24';'3B5';'CC3'];
N = C - '0';

% in ASCII, 0..9 are consecutive, and then there's a gap of 8 chars 'till A,
% so 7 should be reduced from anything larger than 9 
N(N>9) = N(N>9) - 7;
end
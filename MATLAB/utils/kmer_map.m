function kmers = kmer_map(idx, alphabet, A, k)
    %lazy converter from indices of k-mers with alphabet to strings.
    nidx = (idx > A^k) | (idx < 1);
    kmers = repmat('~', length(idx), k); %default char is for invalid indices
    if ~all(nidx)
        kmers(~nidx, :) = alphabet(bchr2num(dec2base(idx(~nidx)-1, A, k))+1);
    end
end

 
function N = bchr2num(C)
% C is assumed to be a numeric representation in chars of a number, e.g. 
% in base 12 (A=10, B=11), so 'A2'~10*12+2*1=122. one number representation
% per line, for example: C = ['A24';'3B5';'CC3'];
N = C - '0';

% in ASCII, 0..9 are consecutive, and then there's a gap of 8 chars 'till A,
% so 7 should be reduced from anything larger than 9 
N(N>9) = N(N>9) - 7;
end
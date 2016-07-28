function [s2k, kmer, ab, pad] = seqs2kmer(seqs, k, varargin)
% Efficient calculation of kmer representation.
%
% Arguments:
%  seqs - a cell array of sequences, or a matrix of chars.
%  k - the kmer size.
% 
% Name/Value Arguments:
%  alphabet - the alphabet for kmer counting. 'dna' and
%             'aminoacids' are also valid options. default is unique over
%             input.
%  len - #columns of the output matrix. 'min' and 'max' can also be given,
%        in which case the minimal/maximal sequence length is used. shorter
%        sequences will be padded. default is the .95 length percentile
%        of the sequences. 

% Returns:
%  s2k - a sparse counting matrix of seqeunces vs kmers.
%  kmer - a function handle that maps indices in 1..length(alphabet)^k to
%         corresponding kmers
%  ab - alphabet
%  pad - pad char
%
% USAGE:
%  >> [s2k,kmap] = seqs2kmer({'BCBBCBBDEFGB','JKMMNABABDCE'}, 3, ...
%                             'alphabet', 'ABCDEFGHIJKLMNOP');
%  >> kmap(find(s2k(1,:)==2))
%  ans =
%
%  BCB
%  CBB

%validations and other stuff
if size(seqs,2) > size(seqs,1), seqs = seqs.'; end;
N = length(seqs);
args = parse_namevalue_pairs(struct('alphabet','', 'len', -1), ...
                             varargin);
if strcmpi(args.alphabet,'dna'), args.alphabet = 'ACGT'; end
if strcmpi(args.alphabet,'aminoacids'), args.alphabet = 'ACDEFGHIKLMNPQRSTVWY'; end
if iscell(seqs)
    seqs = seqs2mat(seqs, 'len', args.len);
end
empiric_ab = unique(unique(seqs(:)));
if isempty(args.alphabet),  args.alphabet = empiric_ab;
else
    if any('_'==empiric_ab), args.alphabet = [args.alphabet,'_']; end
    assert(length(unique(args.alphabet))==length(args.alphabet), ...
           'Alphabet should be unique!');
    ok = any(repmat(empiric_ab,1,length(args.alphabet)) == ...
             repmat(args.alphabet,length(empiric_ab),1),2);
    assert(all(ok), 'Missing chars in given alphabet (%s)', empiric_ab(~ok));
end

A = length(args.alphabet);
mA = min(args.alphabet);
m = size(seqs,2);

%real code from here
kmer = @(idx)kmer_map(idx, args.alphabet, A, k);            %get a mapping from k-mer index to k-mer string
seqs = seqs - mA;                                           %convert to ASCII matrix
for i = 1:A, seqs(seqs==args.alphabet(i)-mA) = i-1; end;    %replace each char with ordinal in alphabet
kidx = conv2(seqs, A.^(0:k-1));                             %convolve with a base-computation kernel = map text indices to kmer inidces
kidx = kidx(:,k:(end-k+1)) + 1;                             %take only relevant enries, +1 for matlab indexing
sidx = repmat((1:N)', 1, m-k+1);                            %get corresponding sequence indices
s2k = sparse(sidx(:),kidx(:),ones(numel(sidx),1), N, A.^k, numel(sidx)); %generate sparse matrix
ab = args.alphabet;
pad = '_';
end
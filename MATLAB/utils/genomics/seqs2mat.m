function [seqmat] = seqs2mat(seqarr, varargin)
% Convert strings of arbitrary length to a matrix. Useful for efficient
% kmerization.
%
% Arguments:
%  seqarr - a cell array of sequences.
%
% Name/Value Arguments:
%  len - #columns of the output matrix. 'min' and 'max' can also be given,
%        in which case the minimal/maximal sequence length is used. shorter
%        sequences will be padded. default is the .95 length percentile
%        of the sequences. 
%  pad_char - with which defficient sequences are padded. default = '_'.
%
% Returns:
%  seqmat - a char matrix.
% 

%validations and other stuff
N = length(seqarr);
sl = cellfun('length',seqarr);
args = parse_namevalue_pairs(struct('len',-1,'pad_char', '_'), varargin);
if ischar(args.len)
    if strcmpi(args.len,'max'), args.len = max(sl);
    else
        assert(strcmpi(args.len,'min'), ...
               'The only allowed string inputs for "len" are "min"/"max"');
        args.len = min(sl);
    end
else
    if args.len < 0, args.len = round(prctile(sl,95)); end
end
padding = @(x)[x(1:min(length(x),args.len)),...
               repmat(args.pad_char, 1, max(0,args.len-length(x)))];
seqarr = cellfun(padding, seqarr, 'uniformoutput', false);
seqmat = cell2mat(seqarr);
end
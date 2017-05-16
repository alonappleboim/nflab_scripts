function [meta] = reshape_tracks(tracks, chrs, poss, dirs, varargin)
% Aligns track data to annotations
%
% Arguments:
%  tracks - a cell array, cell per chr, with a matrix of Txlen(chr), where
%           T is the number of tracks in data (chrM=17).
%  chrs/poss/dirs - chromosome number, position in chromosome and direction
%                   of annotations. All three must have same shape (length P).
% Name/Value Arguments:
%  range - a pair of offsets relative to position, default: [-500,1000]
%
% Returns
%  meta - A TxBxP array, where T is the number of tracks, B is the size of
%         range difference (e.g. 1501 in the default), and P is the length
%         of positional annotations.
%
args = parse_namevalue_pairs(struct('range',[-500,1000]),varargin);
T = size(tracks{1},1);
meta = nan(T,args.range(2)-args.range(1)+1,length(chrs));
for i = 1:length(poss)
    ci = chrs(i);
    di = (-1)^(1-dirs(i));
    pi = poss(i);
    if any(isnan([pi,ci,di])), continue; end;
    fr = min(max(pi + di*args.range(1),1), size(tracks{ci},2));
    to = min(max(pi + di*args.range(2),1), size(tracks{ci},2));
    d = tracks{ci}(:,fr:di:to);
    fr = di*(fr-pi)-args.range(1)+1;
    to = di*(to-pi)-args.range(1)+1;
    meta(:,fr:to,i) = d;
end

end

function [arr] = tracks2annotarr(tracks, annot, win)
% Align track data to annotations
%
% Arguments:
%  tracks - a cell array, cell per chr, holding  a matrix of Txlen(chr),
%           where T is the number of tracks in data (chrM=tracks{17}).
%  annot - a struct with 3 fields:
%            chr - annotation chromosome (Ax1) index into tracks
%            pos - position in chromosome
%            str - strand of annotation (1/-1)
%  win - window around position e.g. [-500,500];
%
% Returns
%  arr - A x W x T array, where W = w(2) - w(2) + 1;
%

if size(annot.chr,1)==1, annot.chr = annot.chr.'; end
if size(annot.pos,1)==1, annot.pos= annot.pos.'; end
if size(annot.str,1)==1, annot.str = annot.str.'; end

if size(tracks{1},1) > size(tracks{1},2)
    for ci = 1:length(tracks)
        tracks{ci} = tracks{ci}.';
    end
end
assert(length(annot.chr)==length(annot.pos),...
       'all annotation fields should have equal lengths')
assert(length(annot.chr)==length(annot.str),...
       'all annotation fields should have equal lengths')

A = length(annot.chr);
T = size(tracks{1},1);
W = win(2) - win(1) + 1;
arr = nan(W,A,T);
for ci = 1:length(tracks) % iterate over chromosomes
    cmat = tracks{ci};
    Cl = size(cmat,2);
    aidx = find(annot.chr == ci & ~isnan(annot.pos));
    bounds = annot.pos(aidx)*ones(1,2) + annot.str(aidx) * win;
    lidx = ~any(bounds<0|bounds>Cl, 2);
    bounds = bounds(lidx,:); %only legal annotations
    aidx = aidx(lidx);
    start = min(bounds,[],2);
    cidx = (repmat(start,1,W) + repmat(1:W,size(aidx,1),1)).';
    c = repmat(cidx(:),T,1);
    r = repmat(1:T,numel(cidx),1);
    r = r(:);
    Cd = cmat(sub2ind(size(cmat),r,c));
    arr(:,aidx,:) = reshape(full(Cd),W,length(aidx),T);
end
arr(:,annot.str==-1,:) = flip(arr(:,annot.str==-1,:),1);
arr = permute(arr,[2,1,3]);
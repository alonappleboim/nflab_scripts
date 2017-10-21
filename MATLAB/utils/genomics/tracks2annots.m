function [meta] = tracks2annots(tracks, annot)
% Aligns track data to annotations
%
% Arguments:
%  tracks - a cell array, cell per chr, with a matrix of Txlen(chr), where
%           T is the number of tracks in data (chrM=tracks{17}).
%  annot - a struct with 3 fields:
%            chr - annotation chromosome (Px1) index into tracks
%            fr - position along chromosome where annotation starts (Px1)
%            to - position along chromosome where annotation ends (Px1)
%
% Returns
%  meta - Px1 cell array, with entry i populated by a matrix of
%         dimensions TxL_i [where L_i is abs(fr(i)-to(i))+1].
%
if size(annot.chr,1)==1, annot.chr = annot.chr.'; end
if size(annot.fr,1)==1, annot.fr = annot.fr.'; end
if size(annot.to,1)==1, annot.to = annot.to.'; end

if size(tracks{1},1) > size(tracks{1},2)
    for ci = 1:length(tracks)
        tracks{ci} = tracks{ci}.';
    end
end

P = length(annot.chr);
assert(P == length(annot.to) & P == length(annot.fr), ...
       'annotation fields should have same dimensions');

T = size(tracks{1},1);
meta = cell(P,1);
for i = 1:length(annot.chr)
    dir = (-1)^(annot.fr(i)>annot.to(i));
    try
        meta{i} = tracks{annot.chr(i)}(:,annot.fr(i):dir:annot.to(i));
    catch
        fprintf('Could not extract data from chr: %i %i-%i\n', annot.chr(i), annot.fr(i), annot.to(i));
    end
end

end
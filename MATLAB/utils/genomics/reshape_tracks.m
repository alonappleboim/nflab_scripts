function [meta] = reshape_tracks(tracks, annot, varargin)
% Aligns track data to annotations
%
% Arguments:
%  tracks - a cell array, cell per chr, with a matrix of Txlen(chr), where
%           T is the number of tracks in data (chrM=tracks{17}).
%  annot - a struct with 3 fields:
%            chr - annotation chromosome (Px1) index into tracks
%            pos - position along chromosome (Px1)
%            dir - direction, 1 for watson, 0 for crick (Px1)
% Name/Value Arguments:
%  range - a pair of offsets relative to position, default: [-500,1000]
%
% Returns
%  meta - A TxBxP array, where T is the number of tracks, B is the size of
%         range difference (i.e. 1501 in the default), and P is the length
%         of positinal annotations.
%
if size(annot.chr,1)==1, annot.chr = annot.chr.'; end
if size(annot.pos,1)==1, annot.pos = annot.pos.'; end
if size(annot.dir,1)==1, annot.dir = annot.dir.'; end

P = length(annot.chr);
assert(P == length(annot.pos) & P == length(annot.dir), ...
       'annotation fields should have same length') 

args = parse_namevalue_pairs(struct('range',[-500,1000]),varargin);
T = size(tracks{1},1);
meta = nan(T,args.range(2)-args.range(1)+1,length(annot.chr));
for i = 1:length(annot.pos)
    ci = annot.chr(i);
    di = (-1)^(1-annot.dir(i));
    pi = annot.pos(i);
    if any(isnan([pi,ci,di])), continue; end;
    fr = min(max(pi + di*args.range(1),1), size(tracks{ci},2));
    to = min(max(pi + di*args.range(2),1), size(tracks{ci},2));
    d = tracks{ci}(:,fr:di:to);
    fr = di*(fr-pi)-args.range(1)+1;
    to = di*(to-pi)-args.range(1)+1;
    if fr < to
        meta(:,fr:to,i) = d;
    else
        disp([fr,to])
    end
end

end

function [] = test()
%% test code
    d = {}; for i = 1:3, d{i} = rand(3,1e5); end;
    a = struct();
    a.chr = randi(3,[300,1]);
    a.pos = randi(1e5,[300,1]);
    %forward values
    for i = 1:300, d{a.chr(i)}(1:3,a.pos(i):a.pos(i)+9) = [20;10;5]*rand(1,10); end
    % and reverse values (20 bp)
    for i = 1:300, d{a.chr(i)}(1:3,a.pos(i)-19:a.pos(i)) = -[20;10;5]*rand(1,20); end
    %test forward
    a.dir = ones(300,1);
    r = [-50,100];
    x = reshape_tracks(d, a, 'range',r);
    clf;
    plot(r(1):r(2),mean(mean(x,3)));
    hold all
    a.dir = zeros(300,1);
    x = reshape_tracks(d, a, 'range',r);
    plot(r(1):r(2),mean(mean(x,3)));
    legend('fwd','rev');
end
function [G, lg] = tracks2windows(tracks, varargin)
%
% Arguments:
%  tracks - a cell array with an entry per chromosome, of size Txlen(Chr)
%
% Name/Value pairs:
%  w - window size, default = 100.
%  f - function handle that reduces windows (along 1st dimension) to
%      scalars, default = @(x)mean(x).
%
% Returns 
%  G - A NxT matrix, with N being the number of non-overlapping windows in
%      the genome, and T being the number of tracks in the provided data.
%  lg - mapping rows 1:N to lg.chr (chromosome) and lg.start (window start).

args = parse_namevalue_pairs(struct('w',100,'f',@(x)mean(x)),varargin);

if size(tracks{1},1) > size(tracks{1},2)
    for ci = 1:length(tracks)
        tracks{ci} = tracks{ci}.';
    end
end

N = sum(cellfun(@(x)floor(size(x,2)/args.w), tracks));
lg.chr = zeros(N,1);
lg.start = zeros(N,1);

T = size(tracks{1},1);
G = nan(N, T);
fr = 0;
for ci = 1:length(tracks)
    cdata = tracks{ci};
    len = floor(size(cdata,2)/args.w);
    G(fr+1:fr+len,:) = args.f(reshape(full(tracks{ci}(:,1:len*args.w)).',[args.w,len,T]));
    lg.chr(fr+1:fr+len) = ci;
    lg.start(fr+1:fr+len) = 1:args.w:len*args.w;
    fr = fr+len;
end
function [D] = read_bed_files(folder, sparse)
% read BED files from directory into a struct
% This function is built to read SacCer bed files from a directory into a
% single matlab struct.
% 
% Arguments:
%  folder - path to folder containing bed files
%  sparse - if true (default=False), returned struct will contain a sparse
%           matrix.
%
% Returns:
%  D - struct with fields:
%   chrs - chromosome names
%   tracks - track names, simply the bed file names
%   files - full paths to original bed files.
%   data - a 1x17 cell array, with each entry corresonding to a single
%          chromsome. Each entry contains a matrix of TxL_i where T is the
%          number of tracks, and L(i) is the length of chromosome i.

%parse file names
filedata = dir(folder);
files = {};
track_names = {};
for fi = 1:length(filedata)
    fn = filedata(fi).name;
    if isempty(strfind(fn,'.bed')), continue; end;
    files = {files{:}, [folder,'/',fn]};
    parts = strsplit(fn,'.');
    track_names = {track_names{:}, parts{1}};
end

T = length(track_names);

%prep chrs
C = CONFIG();
chr_len = load(C('saccer3_chrlens_path'));
CN = length(keys(chr_len));
chrs = cell(CN,1);
for ci = 1:CN
    if ci == 17
        crom = 'chrM';
    else
        crom = ['chr',num2roman(ci)];
    end
    chrs{ci} = crom;
end
[~, cord] = sort(chrs);

%and data storage
data = cell(T,1);
for ti = 1:T
    for ci = 1:CN
        data{ti}{ci} = zeros(1,chr_len(chrs{ci}));
    end
end

%iterate over tracks and fill data, PARALLEL!
parfor ti = 1:T
    tic;
    fid = fopen(files{ti});
    for ci = 1:CN
        cii = cord(ci);
        fprintf('processing %s, %s (elapsed: %.2fsec)\n',...
                track_names{ti}, chrs{cii}, toc);
        B = textscan(fid, [chrs{cii}, ' %u %u %f\n']);
        cidx = double(cell2mat(arrayfun(@(i1,i2)i1:i2-1, B{1}+1, B{2}+1,'uniformoutput', false)'));
        vals = cell2mat(arrayfun(@(i1,i2,v)ones(i2-i1,1).*v, B{1}, B{2}, B{3}, 'uniformoutput', false));
        data{ti}{cii}(cidx) = vals;
        if ~feof(fid)
            %cleanup the line that was just partially read
            B = textscan(fid, '%s %u %u %f\n', 1);
            data{ti}{cord(ci+1)}(B{2}(1)+1:B{3}(1)) = B{4}(1);
        end
    end
    fclose(fid);
end

%merge results to matrices, one per chromosome
D.data = cell(1,CN);
for ci = 1:CN
    D.data{ci} = zeros(T,chr_len(chrs{ci}));
    for ti = 1:T
        D.data{ci}(ti,:) = data{ti}{ci};
    end
end
D.chrs = chrs;
D.tracks = track_names;
D.files = files;
end
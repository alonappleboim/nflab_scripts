function [S] = file2strct(fname, delim, empty)
% Load a struct from a delimited file.
%
% Arguments:
%  fname - A file name from which data is read. It is assumed that first
%          2 lines are a header describing field names and types.
%  delim - Defaults to tab.
%  empty - A numeric value with any string of this list will be read as
%          NaN. Defaults to {'na'}.



if ~exist('delim','var') || isempty(delim) delim = '\t'; end
if ~exist('empty','var') || isempty(empty) empty = {'na'}; end

[fid, err] = fopen(fname);
assert(fid > 0, sprintf('could not open file name. - %s', err));
fclose(fid);

[data, fields] = parse_file(fname, delim, empty);

for fi = 1:length(fields)
    S.(fields{fi}) = data{fi};
end
end

function [data, fields] = parse_file(fname, delim, empty)
fid = fopen(fname);

fields = regexp(fgetl(fid),delim,'split');
fields = regexprep(fields,' ', '_');
row_format = fgetl(fid);

data = textscan(fid, row_format, 'delimiter', delim, 'TreatAsEmpty', empty);

fclose(fid);
end
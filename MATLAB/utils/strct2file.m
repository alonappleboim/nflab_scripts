function [] = strct2file(S, fname, header, delim)
% Save a delimited file to a struct.
%
% Arguments:
%  S - The struct, assumed to be a colelction of string/number vectors.
%  fname - A file name to which data is written.
%  header - a boolean indiciating whether a header should be written.
%           Default = true.
%  delim - Defaults to tab.

if ~exist('delim','var') || isempty(delim) delim = '\t'; end
if ~exist('header','var') || isempty(header) header = true; end

[fid, err] = fopen(fname, 'w');
assert(fid > 0, sprintf('could not open file name. - %s', err));

assert(numel(S) <= 1, 'This function does not handle sruct arrays.')

fields = fieldnames(S);
F = length(fields);
N = size(S.(fields{1}),1);
values = cell(N,F);

format = repmat(['%s', delim], 1, F);
format = [format(1:end-length(delim)), '\n'];
dtypes = {};
for fi = 1:F
    fname = fields{fi};
    assert(size(S.(fname),1) == N, 'Size mismatch in fields');
    assert(size(S.(fname),2) == 1, 'fields should be column vectors');
    data = S.(fname);
    f = '%s';
    if isnumeric(data)
        data = cellstr(num2str(data));
        f = '%f';
    end
    dtypes{fi} = f;
    values(:,fi) = data;
end

if header
    %write header
    fprintf(fid, format, fields{:});
    fprintf(fid, format, dtypes{:});
end

for row = 1:N
    fprintf(fid, format, values{row,:});
end

fclose(fid);
end
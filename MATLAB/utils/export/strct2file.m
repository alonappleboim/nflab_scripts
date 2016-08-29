function [] = strct2file(S, fname, varargin)
% Save a struct to a delimited file.
%
% Arguments:
%  S - The struct, assumed to be a collection of string/number vectors with
%      the same length.
%  fname - A file name to which data is written.
%
% Name/Value Arguments:
%  header - a boolean indiciating whether a header should be written.
%           default = true.
%  delim - File delimiter. defulat = tab.

args = parse_namevalue_pairs(struct('header',true,'delim','\t'), varargin);

[fid, err] = fopen(fname, 'w');
assert(fid > 0, sprintf('could not open file name. - %s', err));

assert(numel(S) <= 1, 'This function does not handle sruct arrays.')

fields = fieldnames(S);
F = length(fields);
N = size(S.(fields{1}),1);
values = cell(N,F);

format = repmat(['%s', args.delim], 1, F);
format = [format(1:end-length(args.delim)), '\n'];
dtypes = {};
for fi = 1:F
    fname = fields{fi};
    assert(size(S.(fname),2) == 1, 'fields should be column vectors');
    assert(size(S.(fname),1) == N, 'Size mismatch in fields');
    data = S.(fname);
    f = '%s';
    if isnumeric(data)
        data = cellstr(num2str(data));
        f = '%f';
    end
    dtypes{fi} = f;
    values(:,fi) = data;
end

if args.header
    %write header
    fprintf(fid, format, fields{:});
    fprintf(fid, format, dtypes{:});
end

for row = 1:N
    fprintf(fid, format, values{row,:});
end

fclose(fid);
end
function [] = table2file(fname, data, col_header, row_header, varargin)
% Write a data table to a csv file with column and row headers
% 
% Arguments:
%  fname - target filename.  
%  data - a matrix.
%  col_header - the column dimension should match that of data, each row
%               will be written to a different header line.
%  row_header - the row dimension should match that of data, each column
%               will be written to a different header to the left of the data.
%
% Name/Value Arguments:
%  dt - datatype, a matlab format string for the data. default is '%g'.
%  delim - default is ','
%
args = parse_namevalue_pairs(struct('dt','%g','delim',','), varargin);

[R,C] = size(data);
[CH,CC] = size(col_header);
[RR,RH] = size(row_header);

assert(CC == C && RR == R, 'header/data size mismatch');
col_header = regexprep(col_header,delim,'\.');
row_header = regexprep(row_header,delim,'\.');

fid = fopen(fname,'w');

hdrfrmt = [repmat(delim,1,RH), repmat(['%s',delim],1,C)];
hdrfrmt = [hdrfrmt(1:end-1),'\n'];
for chi = 1:CH
    fprintf(fid, hdrfrmt, col_header{chi,:});
end

linefrmt = [repmat(['%s',args.delim],1,RH), ...
            repmat([args.dt,args.delim],1,C)];
linefrmt = [linefrmt(1:end-1),'\n'];

for i = 1:R
    fprintf(fid, linefrmt, row_header{i,:}, data(i,:));
end

fclose(fid);
end
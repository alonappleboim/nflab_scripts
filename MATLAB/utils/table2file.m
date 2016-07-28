function [] = table2file(fname, data, col_header, row_header, dt, delim)
% write a data table to a csv file with column and row headers
% 
% Arguments:
%  fname - target filename.  
%  data - a matrix.
%  col_header - the column dimension should match that of data, each row
%               will be written to a different header line.
%  row_header - the row dimension should match that of data, each column
%               will be written to a different header to the left of the data.
%  dt - datatype, a matlab format string for the data. default is '%g'.
%  delim - default is ','
%
if ~exist('dt','var') || isempty(dt), dt = '%g'; end
if ~exist('delim','var') || isempty(delim), delim = ','; end

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

linfrmt = [repmat(['%s',delim],1,RH), repmat([dt,delim],1,C)];
linfrmt = [linfrmt(1:end-1),'\n'];

for i = 1:R
    fprintf(fid, linfrmt, row_header{i,:}, data(i,:));
end

fclose(fid);
end
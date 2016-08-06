function [map] = chrlens(chrlen_file)
%return a map from chrom to length (roman numerics)
fid = fopen(chrlen_file);
map = containers.Map();
line = fgets(fid);
while ischar(line)
    line = strsplit(regexprep(line(1:end-1),'\s',':'),':');
    map(line{1}) = str2double(line{2});
    line = fgets(fid);
end

end


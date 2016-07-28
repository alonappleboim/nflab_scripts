function args = unpack_struct(s)
%unpack a struct into name value pair cell array.
fnames = fieldnames(s);
F = length(fnames);
args = cell(1,2*F);
for fi = 1:F
    args{2*fi-1} = fnames{fi};
    args{2*fi} = s.(fnames{fi});
end
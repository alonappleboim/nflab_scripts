function [ f_data, f_inds ] = filter_data(data, dataset_names, th)
%FILTER_DATA filters given data according to th
%   returns a subset of data (possibly indices as well) of genes whose
%   non-zero entries in the given datasets_names exceed threshold;
if nargin < 3
    th = 0.5;
end
if nargin < 2
    dataset_names = {'S_ES', 'Q_ES', 'Y_ES', 'I_ES'};
end

f_inds = true(length(data), 1)';

for d = 1:length(dataset_names)
    dset = dataset_names{d};
    f_name = [dset, '_nz'];
    f_inds = (f_inds) & ([data.(f_name)] / length([data(1).(dset)]) >= th);
end

f_data = data(f_inds);


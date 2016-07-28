function sp = strprod(str_arrs, varargin)
% given a collection of string arrays, generate their cartezian product, 
% with given delimiter
args = parse_namevalue_pairs(struct('delim', '_'), varargin);
while length(str_arrs) > 1
    last = str_arrs{end};
    llast = str_arrs{end-1};
    tmp = {};
    for i = 1:length(llast)
        for j = 1:length(last)
            tmp{end+1} = [llast{i}, args.delim, last{j}];
        end
    end
    str_arrs = {str_arrs{1:end-2}, tmp};
end
sp = str_arrs{1}';
end
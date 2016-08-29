function sp = str_product(str_arrs, varargin)
% given a collection of string arrays, generate their cartezian product, 
% with given delimiter.
%
% Written by Alon (2015).
%
% Arguments:
%  str_arrs = a cell array of (column) string cell arrays.
%
% Name/Value Arguments:
%  delim - delimiter to use in concatenation. default = '_'. 
%
% Returns:
%  The cartesian product of all strings in each argument.
%
% Example: 
%  >> sp = str_product({{'dad','mom'},{'loves','cares for'}, ...
%                       {'Jonny','Ramon';'Mike','Michel'}})
%  >>  length(sp)  % =16?
%  >> sp{12} % =mom_loves_Michel?
%
args = parse_namevalue_pairs(struct('delim', '_'), varargin);
while length(str_arrs) > 1
    last = str_arrs{end};
    llast = str_arrs{end-1};
    tmp = {};
    for i = 1:length(llast)
        for j = 1:length(last(:))
            tmp{end+1} = [llast{i}, args.delim, last{j}];
        end
    end
    str_arrs = {str_arrs{1:end-2}, tmp};
end
sp = str_arrs{1}';
end
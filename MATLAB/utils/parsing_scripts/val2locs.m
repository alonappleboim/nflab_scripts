function ls = val2locs(v)
ls = regexprep(lower(v), ' ', '-');
ls = regexpi(ls, '(:|,)', 'split');
end

function [args, vin] = parse_namevalue_pairs(defaults, userpairs)
%parses whatever fields found in defaults, and returns a struct.
%also leaves the pairs which don't have defaults as is in vin.
assert(mod(length(userpairs),2)==0,'name/value pairs are required')

args = defaults;
vin = {};
for i = 1:length(userpairs)/2
    name = userpairs{i*2-1};
    val = userpairs{i*2};
    if ~isfield(args, name)
        vin{end+1} = name;
        vin{end+1} = val;
    end
	args.(name) = val;
end

function [S] = merge_structs(S1, S2, ID1, ID2, add1, add2, array, verbose)
% Merge structs according to ids 
%
% Arguments:
%  S1 - Main struct, note that any conflicting field name will be
%       overwritten by it.
%  S2 - Secondary struct.
%  ID1 - Name of ID field in S1, Defaults to "ID".
%  ID2 - Name of ID field in S2, Defaults to ID1.
%  add1 - Whether entries in S1, that have no matching entry in S2, should
%         be added to resulting struct with corresponding NaN/'' values.
%         Defaults to true.
%  add2 - Whether entries in S2, that have no matching entry in S1, should
%         be added to resulting struct with corresponding NaN/'' values.
%         Defaults to false.
%  array - either true or false. If false, the resulting struct will not be
%          an array, instead, it will have a vector entry per field. If
%          true, the resulting struct will be a struct array.
%  verbose - Default to true;
%
% note that all field names are lowered

if ~exist('ID1','var') || isempty(ID1) ID1 = 'ID'; end
if ~exist('ID2','var') || isempty(ID2) ID2 = ID1; end
if ~exist('add1','var') || isempty(add1) add1 = true; end
if ~exist('add2','var') || isempty(add2) add2 = false; end
if ~exist('array','var') || isempty(array) array = false; end
if ~exist('verbose','var') || isempty(verbose) verbose= true; end

ID1 = lower(ID1); ID2 = lower(ID2);

fields1 = lower(fieldnames(S1)); F1 = length(fields1);
fields2 = lower(fieldnames(S2)); F2 = length(fields2); 

assert(any(~cellfun('isempty',strfind(fields1, ID1))),...
       '%s is not a field in first struct.\n', ID1);
assert(any(~cellfun('isempty',strfind(fields2, ID2))),...
       '%s is not a field in second struct.\n', ID2);


if numel(S1) > 1 S1 = strct_vectorize(S1); end
if numel(S2) > 1 S2 = strct_vectorize(S2); end

S1 = lower_fields(S1);
S2 = lower_fields(S2);

IDS1 = S1.(ID1); N1 = length(IDS1);
IDS2 = S2.(ID2); N2 = length(IDS2);

is_id_str = iscell(IDS1);

used_in_2 = false(1,N2);

if verbose
	fprintf('merging... ');
end

for i1 = 1:N1
    if verbose && mod(i1, 50) == 0
        fprintf('at %f%%...\n', 100*i1/N1);
    end
    rec = [];
    
    key = IDS1(i1);
    if is_id_str 
        key = key{1};
        i2 = find(~cellfun('isempty', strfind(IDS2, key)));
    else
        i2 = find(IDS2==key);
    end
    
    if length(i2) > 1
        if ~is_id_str 
            key = num2str(key);
            error(sprintf(['key %s found more than once in struct 2, ',...
                           'merging with first occurance.\n'], key));
        end
        i2 = i2(1);
    end
    if length(i2) < 1
        if add1
            %no match
            rec = get_record(S2, inf, fields2, F2);
            rec = get_record(S1, i1, fields1, F1, rec);
            rec.(ID1) = key;
        end
    else
        rec = get_record(S2, i2, fields2, F2);
        rec = get_record(S1, i1, fields1, F1, rec);
        used_in_2(i2) = true;
    end
    
    if ~isempty(rec)
        if ~exist('S','var')
            S = rec;
        else
            S = [S; rec];
        end
    end
end

if add2
    %adding unused entries in S2
    for i2 = find(~used_in_2)
        rec = get_record(S2, i2, fields2, F2);
        rec = get_record(S1, inf, fields1, F1, rec);
        S = [S; rec];
    end
end

if ~array S = strct_vectorize(S); end

end


function vecS = strct_vectorize(S)
fields = fieldnames(S);
vecS = struct();
for fi = 1:length(fields)
    f = fields{fi};
    if isnumeric(S(1).(f))
        d = [S(:).(f)]';
    else
        d = {S(:).(f)}';
    end
    vecS.(f) = d;
end
end

function lS = lower_fields(S)
fs = fieldnames(S);
lS = struct();
for fi = 1:length(fs)
    f = fs{fi};
    lS.(lower(f)) = S.(f);
end
end

function rec = get_record(S, i, fields, F, rec)
if nargin < 5
    rec = struct();
end
for fi = 1:F
    f = fields{fi};
    d = S.(f);
    if iscell(d)
        %string
        if isinf(i) d = ''; else d = d{i}; end
    else
        if isinf(i) d = NaN; else d = d(i); end
    end
    rec.(f) = d;
end
end
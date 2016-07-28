function ind = GOind(dataLength, GOstruct, GOterm)
%GOIND get a logical vector for a go term
%   given the length of the data structure "dataLength", that was used to
%   construct the GOstruct, the GOsturct and the query go term, a logical
%   vector the length of data is returned marked with True in each index of
%   the go term.
%EXAMPLE:
% data(GOind(9872,go_strct,G1001); % get subset of data corresponding to go
%                                  % term G1001.
%

ind = false(dataLength,1);
ind(GOstruct.(GOterm)) = true;
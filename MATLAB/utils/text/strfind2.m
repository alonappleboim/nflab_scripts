function sf = strfind2(s1,s2)
% A 2d strfind, find s1s in s2s.
% Arguments:
%  s1 - a Nx1 cell array of strings
%  s2 - a 1xM cell array of strings
%
% Returns:
%  sf - a NxM cell array with each entry reporting on strfind results.
%
% Example - does strings in s1 appear in s2
%  >> x = strfind2({'ad','da'},{'dad','bad'});
%  >> idx = ~cellfun('isempty',x)
%
%  idx =
%
%       1     1
%       1     0
%

assert(any(size(s1)==1) && any(size(s2)==1))
if size(s1,1) == 1, s1 = s1.'; end;
if size(s2,2) == 1, s2 = s2.'; end;

sf = cell(length(s1),length(s2));
for si = 1:length(s1)
    sf(si,1:length(s2)) = strfind(s2, s1{si});
end
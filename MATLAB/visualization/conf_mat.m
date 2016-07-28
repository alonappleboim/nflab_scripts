function [cmat] = conf_mat(Y, C, labels)
% produce/plot a confusion matrix for Y,C.
%
%   Arguments:
%       Y - Original label, a vector of inegers.
%       C - Class labels, a vector of integers.
%       labels - a cell array with text labels. If given it is assumed that
%                the integers in Y and C are indices in labels.
%
%   Returns:
%       cmat - If requested, confusion matrix is returned:
%              cmat(i,j) = percent of samples labeled i that were
%                          classified as j.
%              If cmat = I classification is perfect.

if iscell(Y) Y = cell2mat(Y); end;
if iscell(C) C = cell2mat(C); end;

%to row vectors
if size(Y,1) > size(Y,2) Y = Y'; end;
if size(C,1) > size(C,2) C = C'; end;
assert(length(Y) == length(C), 'Y and C should have same length');

%labels census
if ~exist('labels', 'var')
    labels = unique([Y,C]);
end
U = length(labels);

cmat = zeros(U);
for y = 1:U
    for c = 1:U
        cmat(y,c) = sum(Y==y & C==c);
    end
end

cmat = cmat ./ (sum(cmat,2)*ones(1,U));
if nargout < 1
    imagesc(cmat, [0 1]);
    clear cmat;
    colorbar; axis square;
    set(gca, 'xtick',1:U, 'xticklabel',labels, 'ytick',1:U, 'yticklabel', labels);    
    xlabel classification;
    ylabel label;
    set(findall(gcf,'type','text'),'fontSize',15,'fontWeight','bold')
end
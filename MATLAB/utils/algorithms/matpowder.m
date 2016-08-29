function [dX, dXs] = matpowder(X,n)
%derivative of a matrix nth power (X should be sqaure)
%
% Returns:
%  dX = d/dX(X^n)
%  dXs(:,:,i) = d/dX(X^i) (i<=n)

%collect all powers of X, in an index offset :(
Xtothe = cell(1,n+1);
Xtothe{1} = eye(size(X));
for ni = 1:n
    Xtothe{ni+1} = Xtothe{ni}*X;
end

dXs = zeros([size(X),n]);
for l = 1:n
    dXs(:,:,l) = Xtothe{l}*X'*Xtothe{n-l+1};
end

dXs = cumsum(dXs,3);
dX = dXs(:,:,end);

end
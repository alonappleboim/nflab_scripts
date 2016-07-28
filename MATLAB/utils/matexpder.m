function [dX,err] = matexpder(X, prec)
%derivative of a matrix exponential up to precision prec (X should be sqaure)
%
% uses the fact that
%
%determine maximal power for approximation
if nargin < 2, prec = 1e-7; end;


%Calculate maximum integer for required precision with stirling's
%approximation
alphaX = size(X,1)*max(abs(X(:)));
minn = floor(exp(log(alphaX)+1));
ns = minn:minn+ceil(-log(prec));
n = minn + find(ns.*(log(alphaX)+1-log(ns))<log(prec),1,'first');

err = exp(n.*(log(alphaX)+1-log(n)));

[~,dXs] = matpowder(X,n);

coeffs = repmat(1./factorial(1:n)',[1,size(X)]);
coeffs = permute(coeffs,[2,3,1]);

dX = sum(coeffs.*dXs,3);
end
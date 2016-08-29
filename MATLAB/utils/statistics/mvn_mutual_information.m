function [gmi] = mvn_mutual_information(X, Y)
%Calculate the gaussian mutual information of X and Y.
%
% Arugments:
%  X - a MxD_1 matrix (M - observations, D_1 - dimension of X)
%  Y - a MxD_2 matrix (M - observations, D_2 - dimension of Y)
%
% Return:
%  The mutual information of X and Y assuming their joint is
%  gaussian distributed (and thus - so are their marginals).
%
nidx = any(isnan(X),2) | any(isnan(Y),2);
X = X(~nidx,:);
Y = Y(~nidx,:);
gmi = .5 * log2(det(nancov(X))) + .5 * log2(det(nancov(Y))) - ...
      .5 * log2(det(nancov([X,Y])));
end

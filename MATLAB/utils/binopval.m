function [en_p, dep_p] = binopval(x,n,p)
%BINOPVAL binomial p value for enrichment (and depletion).
%   P = HYGEPVAL(X,N,P) returns the binomial pvalue with parameters
%   N, P, with the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input
%   functions as a constant matrix of the same size as the other inputs.
%

en_p = 1 - binocdf(x-1,n,p);
dep_p = binocdf(x,n,p);
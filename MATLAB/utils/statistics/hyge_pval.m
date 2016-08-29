function [en_p, dep_p] = hyge_pval(x,m,k,n)
%HYGEPVAL Hypergeometric p value for enrichment (and depletion).
%   P = HYGEPVAL(X,M,K,N) returns the hypergeometric pvalue with parameters
%   M, K, and N with the values in X.
%
%   The size of P is the common size of the input arguments. A scalar input
%   functions as a constant matrix of the same size as the other inputs.
%
%   See also HYGEINV, HYGEPDF, HYGERND, HYGESTAT, CDF.

en_p = 1 - hygecdf(x-1,m,k,n);
dep_p = hygecdf(x,m,k,n);
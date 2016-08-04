function [ep, dp] = binopval(x,n,p)
%BINOPVAL binomial p value for enrichment (and depletion).
% Arguments:
%  see binocdf.
%
% returns:
%  ep - enrichment p-value
%  dp - depletion p-value

ep = 1 - binocdf(x-1,n,p);
dp = binocdf(x,n,p);
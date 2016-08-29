function S = logdot(A, B, varargin)
% LOGDOT executes: S = log(exp(A)*exp(B)), in a precision-aware manner.
%
% Arguments:
%  A - a log space matrix (MxN)
%  B - a log space matrix (NxK)
%  
% Name/Value Arguments:
%  logprec - argmax_s such that exp(-s) >> 0 in this machine. i.e.
%            maximal number such that its negative exponent is not
%            considered 0 by MATLAB. Defaults to 700.
%
args = parse_namevalue_pairs(struct('logprec',700), varargin);
    
if (max(abs(A(:))) < logprec/2) && (max(abs(B(:))) < logprec/2)
    %take the easy road
    S = log(exp(A)*exp(B));
else
    M = size(A,1);
    K = size(B,2);
    %replicate, add, and sum
    repB = permute(repmat(B, [1, 1, M]), [3,1,2]);
    repA = repmat(A, [1, 1, K]);
    S = logsum(repA+repB, 2);
end
end
function A = rate2prob_rate(R)
% Convert a matrix, R, with rate transitions:
%  R_ij = rate of transitioning from i to j
% To a corresponding probability rate transition matrix, A:
%  dP_i(t)/dt = A*P(t)
%
    A = R.';
    A(eye(size(A))==1) = -sum(A,1);
end
function x_t = solve_linODEsys(A, t, x0)
%solve system x' = A*x with initial values x0, and return x(t)
%
[U, D] = eig(A);
C = U\x0;
T = length(t);
x_t = real(U*((C*ones(1,T)).*exp(diag(D)*t)))';
end
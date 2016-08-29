function X = nearPD(X, varargin)
% nearPD.m
%  (project a matrix to the semi-definite matrices space)
%  This function is a Matlab rip-off of an R function called 'nearPD' in
%  the Matrix package:
%  http://rweb.stat.umn.edu/R/library/Matrix/html/nearPD.html
%  The complete text of the original R function appears below in a comment.

% Parse input.
parser = inputParser;
parser.FunctionName = 'nearPD';
parser.addRequired('X', @isnumeric);
parser.addParamValue('maxit', 5000, @(x)x>=1);
parser.addParamValue('isCorrMatrix', 1, @(x)or(x==0,x==1));
parser.parse(X, varargin{:});
X = parser.Results.X;
maxit = parser.Results.maxit;
isCorrMatrix = parser.Results.isCorrMatrix;

% Get sizes
[n n2] = size(X);
assert(n==n2,'X is not square.');

% Check symmetry.
SMALL_NUM = .0001;
assert(all(all(X-X'<SMALL_NUM)),'X is not symmetric.');

% Set params.
DO2EIGEN = true;
EIG_TOL = 1e-6;
CONV_TOL = .001; %1e-7;
POSD_TOL = 1e-8;

% Create U.
U = zeros(n);

% Set iteration params.
iter = 0;
converged = false;
conv = Inf;

% Iterate.
while(iter < maxit && ~converged)
   Y = X;
   T = Y - U;
   
   % Project onto PSD matrices.
   [Q,D] = eig(X);
   d = diag(D);
   
   % Create mask.
   p = d > EIG_TOL * d(1);
   
   % Use p mask.
   % NOTE: If this code runs slowly, see if there's a way to speed it up
   % like in the R function....
   Q = Q(:,p);
   X = Q * D(p,p) * Q';
   
   % Update Dykstra's correction.
   U = X - T;
   
   % Project onto symmetric and possibly 'given diag' matrices.
   X = (X + X')/2;
   if(isCorrMatrix)
       X(eye(n)==1)=1;
   end
   
   conv = norm(Y-X,inf) / norm(Y, inf);
   iter = iter + 1;
   
   converged = (conv <= CONV_TOL);
end

if(~converged)
    warning('nearPD did not converge in %i iterations.',iter);
end

if(DO2EIGEN)
   [Q,D] = eig(X);
   
   % Matlab reverses the eigenvalues from the way R does things.
   Q = fliplr(Q);
   d = fliplr(diag(D)');
   
   Eps = POSD_TOL * abs(d(1)); % The R code says to take d(1), but Matlab reverses the order of eigenvalues.
   if(d(n) < Eps)
      d(d < Eps) = Eps;
      oDiag = diag(X)';
      X = Q * (repmat(d',1,n) .* Q');
      D = sqrt(max(Eps, oDiag) ./ diag(X)');
      X = repmat(D',1,n) .* X .* repmat(D,n,1);
   end
end
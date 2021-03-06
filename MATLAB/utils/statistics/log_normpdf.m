function ly = log_normpdf(x,mu,sigma)
%LOGNORMPDF log of the Normal probability density function (pdf).
%   LY = LOGNORMPDF(X,MU,SIGMA) returns the log of the pdf of the normal
%   distribution with mean MU and standard deviation SIGMA, evaluated at
%   the values in X. The size of :Y is the common size of the input
%   arguments.  A scalar input functions as a constant matrix of the same
%   size as the other inputs.
%
%   Default values for MU and SIGMA are 0 and 1 respectively.
%
%   See also NORMCDF, NORMFIT, NORMINV, NORMLIKE, NORMRND, NORMSTAT.

%   References:
%      [1] Evans, M., Hastings, N., and Peacock, B. (1993) Statistical
%          Distributions, 2nd ed., Wiley, 170pp.

%   Copyright 1993-2004 The MathWorks, Inc. 


if nargin<1
    error(message('stats:normpdf:TooFewInputs'));
end
if nargin < 2
    mu = 0;
end
if nargin < 3
    sigma = 1;
end

% Return NaN for out of range parameters.
sigma(sigma <= 0) = NaN;

try
    ly = -0.5 * (((x - mu)./sigma).^2)  - log(sqrt(2*pi) .* sigma);
catch
    error(message('stats:normpdf:InputSizeMismatch'));
end

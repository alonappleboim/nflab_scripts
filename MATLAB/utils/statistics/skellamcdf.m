function y = skellamcdf(x,mu1,mu2)

if nargin <  2, error('Too Few Inputs'); end
if nargin < 3 mu2 = mu1; end

if isscalar(mu1), mu1 = mu1*ones(size(x)); end
if isscalar(mu2), mu2 = mu2*ones(size(x)); end

assert(all(size(mu1) == size(mu2)) && all(size(x) == size(mu1)),...
       'Input dimensions mismatch')
y = zeros(size(x));
x = floor(x);
y(x<=0) = ncx2cdf(2*mu2(x<=0), -2*x(x<=0), 2*mu1(x<=0));
y(x>0) = 1-ncx2cdf(2*mu1(x>0), 2*(x(x>0)+1), 2*mu2(x>0));
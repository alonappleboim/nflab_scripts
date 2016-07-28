function t = calc_max_separation_threshold(X,p)
% solve t* = argmax_t(f_t(X,p))
% where f_t(X,p) = log(Pr(X_i|p_i<t)Pr(X_i|p_i>t)/Pr(X))
% i.e. the maximum likelihood ratio upon separating X, based on information
% provided by the predictor p. Assuming all the distributions are normal.
%
% Arguments:
%   X - Data to be separated. A MxD matrix (M-#instances, D-#dimension)
%   p - Predictor variable. A Mx1 vector.
%

rmidx = isnan(p);
p = p(~rmidx);
X = X(~rmidx,:);
f = @(t)-likelihood_ratio(t,p,X);
t = fminbnd(f,min(p),max(p));
end

function lr = likelihood_ratio(t,p,X)
Xl = X(p<t,:);
Xu = X(p>=t,:);

u_mu = nanmean(Xu); l_mu = nanmean(Xl); mu = nanmean(X);
u_cov = nancov(Xu); l_cov = nancov(Xl); cov = nancov(X);

lr = sum(log_mvnpdf(Xu, u_mu, u_cov)) + sum(log_mvnpdf(Xl, l_mu, l_cov)) - ...
     sum(log_mvnpdf(X, mu, cov));
end
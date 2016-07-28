function [ratio] = mvn_likelihood_ratio(X, Y, nan_upto)
% calculates the likelihood ratio of X and Y coming from the same
% multivariate normal distribution or from different distributions.
% Arguments:
%   X - a NxD matrix with rows corresponding to instances and column to
%       dimensions.
%   Y - a NxD matrix with rows corresponding to instances and column to
%       dimensions.
%   nan_upto - for the likelihood calculations, consider instance with up
%              to how many NaNs? default = 0 (between 0 and D-1). to consider
%              an entry with NaNsthe relevant dimensions are marignalized.
%
% Returns:
%   ratio - log(maxPr(X|X)maxPr(Y|Y)/maxPr(X,Y|XandY))
%
if ~exist('nan_upto','var') || isempty(nan_upto) nan_upto = 0; end
D = size(X,2);
assert(nan_upto >= 0 & nan_upto < D, 'nan_upto must be between 0 and D-1');

xmu = nanmean(X);
ymu = nanmean(Y);
mu = nanmean([X;Y]);
xcov = nancov(X);
ycov = nancov(Y);
cov = nancov([X;Y]);
ratio = nan;

[~, px] = chol(xcov);
[~, py] = chol(ycov);
if px == 0 && py == 0
    for i = 0:nan_upto
        idx_sets = nchoosek(1:D,D-i);
        %iterating over all possible (D-i)-sized non-nan column combinations
        for si = 1:size(idx_sets,1) 
            set = idx_sets(si,:);
            nset = setdiff(1:D,set);

            %collect relevant samples
            xidx = sum(isnan(X),2) == i & sum(isnan(X(:,nset)),2) == i;
            yidx = sum(isnan(Y),2) == i & sum(isnan(Y(:,nset)),2) == i;
            nX = X(xidx, set);
            nY = Y(yidx, set);

            %taking only relevant dimensions from estimators (=marginalizing)
            xmu_marg = xmu(set);
            ymu_marg = ymu(set);
            mu_marg = mu(set);
            xcov_marg = xcov(set,:); xcov_marg = xcov_marg(:,set);
            ycov_marg = ycov(set,:); ycov_marg = ycov_marg(:,set);
            cov_marg = cov(set,:); cov_marg = cov_marg(:,set);

            if ~isempty(nX) && ~isempty(nY)
                if isnan(ratio) ratio = 0; end;
                ratio = ratio + sum(log_mvnpdf(nX,xmu_marg,xcov_marg)) + ...
                        sum(log_mvnpdf(nY,ymu_marg,ycov_marg)) - ...
                        sum(log_mvnpdf([nX;nY],mu_marg,cov_marg));
            end
        end
    end
ratio
end
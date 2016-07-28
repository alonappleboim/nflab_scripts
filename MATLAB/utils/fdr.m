function [inds, thresh] = fdr(pvals, alpha, toPlot)
% Returns indices to subset of pvals with fdr < alpha. Optional return is
% the fdr threshold found in data (i.e. what's the pvalue threshold
% under which the probability of finding a not significant experiment is
% lower than alpha).
%
% Arguments:
%   pvals - a vector of pvals corresponding to experiments
%   alpha - significance level desired (or false discovery rate). defautls
%           to 0.05.
%   toPlot - should p values and threhsold be plotted. defaults to false.
%
% A one-liner example of how to plot the number of experiments selected with
% increasing confidence (data is named pvals):
% alphas = exp([-20:1:-1]); n = []; for alph = alphas n = [n, sum(fdr(pvals, alph))];end;plot(log(alphas),n); clear alphas n;

if ~exist('alpha','var') || isempty(alpha)
    alpha = .05;
end
if nargin < 3
    toPlot = false;
end
pvals = pvals(:)';
nanidx = isnan(pvals);

pvals = pvals(~nanidx);
N = length(pvals);

s_pvals = sort(pvals);
thresh_i = find((1:N)./(s_pvals.*N) >= 1./alpha, 1, 'last');
thresh = s_pvals(thresh_i);
if isempty(thresh) thresh = 0; end

all = nan(length(nanidx),1);
all(~nanidx) = pvals;
inds = all <= thresh;

if toPlot
    set(0,'DefaultFigureWindowStyle','docked')
    figure;
    nz_pvals = s_pvals;
    nz_pvals(nz_pvals == 0) = min(nz_pvals(nz_pvals ~= 0));
    plot(nz_pvals, 'LineWidth', 2);
    hold on;
    %pValue is uniformly distributed under the null hypthesis:
    plot((1:N)./ N, 'g', 'LineWidth', 2);
    plot([thresh_i, thresh_i], ylim, 'r', 'LineWidth', 2);
    legend({'sorted P_{value}', 'Null hypothesis', 'Threshold'},...
           'Location', 'SouthEast');
    set(gca,'YGrid','on');
    xlabel('#Experiments \leq P_{value}');
    ylabel 'P_{value}';
    title(['FDR with {\alpha=',num2str(alpha),'}']);
    set(findall(gcf,'type','text'),'fontSize',14, 'fontWeight', 'demi')
end
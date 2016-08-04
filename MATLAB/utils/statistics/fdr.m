function [idx, thresh] = fdr(pvals, alpha, varargin)
% calculates FDR for a list of pvals.
%
% Arguments:
%   pvals - a vector of pvals corresponding to experiments
%   alpha - significance level desired (or false discovery rate). defautls
%           to 0.05.
%
% Name/Value Arguments:
%   to_plot - whether to plot the distribution of pvals vs. null
%             hypothesis, and the threshold. default: True iff nargout==0.
%
% Returns:
%  idx - indices that passed the FDR test.
%  thresh - the threshold found.
% 
% Example of how to plot the number of experiments selected with
% increasing confidence (data is named pvals):
% alphas = 10.^([-5:1:-1]); n = [];
% for alph = alphas
%    n = [n, sum(fdr(pvals, alph))];
% end;
% plot(log(alphas),n);

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
idx = all <= thresh;

if nargout == 0
    set(0,'DefaultFigureWindowStyle','docked')
    hold all;
    figure;
    nz_pvals = s_pvals;
    nz_pvals(nz_pvals == 0) = min(nz_pvals(nz_pvals ~= 0));
    plot(nz_pvals, 'LineWidth', 2);
    hold on;
    %pValue is uniformly distributed under the null hypthesis:
    plot((1:N)./ N, 'LineWidth', 2);
    if isempty(thresh_i), thresh_i = length(pvals); end;
    plot([thresh_i, thresh_i], ylim, 'LineWidth', 2);
    legend({'P_{value}', 'Null hypothesis', 'Threshold'},...
           'Location', 'SouthEast', 'fontsize', 14);
    set(gca,'YGrid','on');
    xlabel('#Experiments \leq P_{value}');
    ylabel 'P_{value}';
    title(['FDR with {\alpha=',num2str(alpha),'}']);
    set(findall(gcf,'type','text'),'fontSize',14, 'fontWeight', 'demi')
    clear idx
end
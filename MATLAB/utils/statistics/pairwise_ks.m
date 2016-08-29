function [pvals, kss, passed] = pairwise_ks(sets, feats, varargin)
% Calculates the (1-sided) pair-wise ks pvals for each feature and
% annotation-set-pair.
%
% Arguments:
%   sets - a SxE matrix where S is the number of sets and E is the total
%            number of elements.
%   feats - a ExF, where E is #elements, and F is the number of different
%           features.
% 
% Name/Value Arguments:
%  alpha - significance (FDR rate) level. default=.05.
%  correct - either 'fdr' (default), 'bonferroni' or 'none'.
%
% Returns:
%  pvals - a FxSxS array with p-values. (i,j,k) is the p-value associated
%          with the test that in feature i set j is left shifted relative
%          to set k. In the case that j==k, the test is for the set S_j and
%          the set ~S_j.
%  kss - the corresponding ks statistics.
%  passed - a corresponding logical matrix with true in all tests that
%           passed the significance/FDR test.
%
%
% Example:
%  >> feats = [randn(100,5),[1:100]'];
%  >> sets = rand(10,100)<.3;
%  >> sets(1,1:50) = rand(1,50)<.15;
%  >> sets(1,51:100) = rand(1,50)<.85;
%  >> sets(2,71:100) = rand(1,30)<.95;
%  >> [pvals,kss,passed] = pairwise_ks(sets,feats);
%  >> i = find(passed); [fi, s1i, s2i] = ind2sub(size(passed),i);
%  >> to_print = [fi, s1i, s2i, pvals(passed),kss(passed)]';
%  >> sprintf('fi=%i, s1i=%i, s2i=%i, pval=%.2f, ks=%.2f ++ ', to_print)
%

args = parse_namevalue_pairs(struct('alpha',.05, 'correct', 'fdr'), varargin);
assert(size(sets,2) == size(feats,1), 'Element set must be the same');
[S, ~] = size(sets);
[~, F] = size(feats);

pvals = nan(F,S,S);
kss = nan(size(pvals));
for fi = 1:F
    fprintf('at %.2f%%...\n',100.*fi./F)
    for si = 1:S
        idist = feats(sets(si,:),fi);
        for sj = 1:S
            if si==sj
                jdist = feats(~sets(sj,:),fi);
            else
                jdist = feats(sets(sj,:),fi);
            end
            if all(isnan(idist)) || all(isnan(jdist))
                continue
            end
            [~, p, s] = kstest2(idist, jdist, .1, 'smaller');
            pvals(fi,si,sj) = p;
            kss(fi,si,sj) = s;
        end
    end
end

switch args.correct
    case 'bonferroni'
        passed = pvals.*sum(~isnan(pvals(:))) < args.alpha;
    case 'fdr'
        passed = reshape(fdr(pvals(:),args.alpha),size(pvals));
    otherwise
        passed = pvals < args.alpha;
end
pvals = log10(pvals);
end
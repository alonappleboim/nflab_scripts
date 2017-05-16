function [pvals, passed] = pairwise_hyge_test(sets1, sets2, varargin)
% For each set in sets1 calculate hypergeometric enrichment and depletion
% with every set in set2.
% 
% Arguemnts:
%  sets1 - a S1xE logical incidence matrix where element e is in set s if
%          sets1(s,e) == true.
%  sets2 - a S2xE logical incidence matrix where element e is in set s if
%          sets2(s,e) == true.
%
% Name/Value Arguments:
%  alpha - significance (FDR rate) level. default=.05.
%  correct - either 'fdr' (default), 'bonferroni' or 'none'.
%
% Returns:
%  pvals - a S1xS2 matrix with signed log p-values, where (-) values mean
%          depletion and (+) means enrichment.
%  passed - a corresponding logical matrix with true in all tests that
%           passed the significance/FDR test
%  maxn - maximum number of elemtns in the computation. 4e5 is the default.
%         If S1xS2 is larger than this number then sets2 is split to
%         batches for inner calculations.
%
%
% Example:
%  >> s1 = rand(30,500)<.3;
%  >> s2 = rand(50,500)<.3;
%  >> s1(10,1:90) = true; %set 10 and set 20 gonna overlap
%  >> s2(20,20:100) = true;
%  >> s2(30,1:90) = false; % and set 30 is gonna un-overlap
%  >> s2(30,100:150) = true; %
%  >> [pvals, passed] = pairwise_hyge_test(s1,s2);
%  >> [s1i,s2i] = find(passed);
%  >> sprintf('s1i=%i, s2i=%i, pval=%.2f ++ ', [s1i,s2i,pvals(passed)]')
%

args = parse_namevalue_pairs(struct('alpha',.05, 'correct', 'fdr','maxn',6e4), varargin);
assert(size(sets1,2) == size(sets2,2), 'Element set must be the same');
S1 = size(sets1, 1);
S2 = size(sets2, 1);

nsets = ceil(S1*S2/args.maxn);
batch_size = ceil(S2/nsets);
nsets = ceil(S2/batch_size);
en = cell(1,nsets);
dep = cell(1,nsets);
for si = 1:nsets
    fr = (si-1)*batch_size+1;
    to = min(size(sets2,1),si*batch_size);
    [en{si}, dep{si}] = handle_subset(sets1,sets2(fr:to,:));
end
en = cat(1, en{:});
dep = cat(1, dep{:});
all = [en;dep];
switch args.correct
    case 'bonferroni'
        passed = all.*sum(~isnan(all(:))) < args.alpha;
    case 'fdr'
        passed = fdr(all(:),args.alpha);
    otherwise
        passed = all < args.alpha;
end
p_en = reshape(passed(1:S1*S2), [S1,S2]);
p_dep = reshape(passed(S1*S2+1:end), [S1,S2]);
passed = false(S1, S2);
pvals = nan(S1, S2);

en_i = en < dep;
dep_i = en > dep;
pvals(en_i) = -log10(en(en_i));
pvals(dep_i) = log10(dep(dep_i));
passed(en_i) = p_en(en_i);
passed(dep_i) = p_dep(dep_i);
end

function [en, dep] = handle_subset(sets1, sets2)
E = size(sets1, 2);
X = max(0, double(sets1) * double(sets2)');
K = repmat(sum(sets1,2), 1, size(sets2,1));
N = repmat(sum(sets2,2)', size(sets1,1), 1);

[en, dep] = hyge_pval(X(:),E,K(:),N(:));
end
function X = mediannorm(X)
% normalize samples (columns) to have the same median
% See DESeq for details:
%  https://genomebiology.biomedcentral.com/articles/10.1186/gb-2010-11-10-r106
%
%
gM = exp(nanmean(log(eps+X),2)); %geometric mean
sF = nanmedian(X./(gM*ones(1,size(X,2)))); %size factors
X = X./(ones(size(X,1),1) * sF);




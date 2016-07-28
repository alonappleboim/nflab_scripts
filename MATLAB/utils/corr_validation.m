function [] = corr_validation(data, thresholds, corr_type, th_datasets, mean_fields)
% plots correlation of field along different genes, in several subsets.
% data - the data struct.
% thresholds - a vector of thresholds in [0,1]. These define the subsets
%              plotted. A gene passes a threshold X if it has expression 
%              data in at least X% of cells in all datasets given in
%              th_datasets. optional, defaults to 0:1/9,0.99.
% corr_type - correlation type used. optional, defaults to 'Pearson'
% th_datasets - the datasets names used for thresholding. optioanl,
%               defaults to {'S_ES', 'Q_ES', 'Y_ES'}.
% mean_fields - fields extracted from data struct across which correlation
%               is calcualted. optional, defaults to:
%               {'S_ES_mean','Y_ES_mean','Q_ES_mean','I_ES_mean',...
%                'D_OOCYTE_mean', 'fpkm_G_es1', 'fpkm_G_es3',...
%                'fpkm_szulwach'}.

fig1 = figure;
if nargin < 2
    thresholds = 0:1/9:0.99;
end
if nargin < 3
    corr_type = 'Pearson';
end
if nargin < 4
    th_datasets = {'S_ES', 'Q_ES', 'Y_ES'};
end
if nargin < 5
    mean_fields = {'S_ES_mean','Y_ES_mean','Q_ES_mean','I_ES_mean',...
                   'D_OOCYTE_mean', 'fpkm_G_es1', 'fpkm_G_es3',...
                   'fpkm_szulwach'};
end

T = length(thresholds);
M = length(mean_fields);
% collecting gene mean data
mean_data = zeros(length(data),M);
for fi = 1:M
    mean_data(:,fi) = [data.(mean_fields{fi})]';
end

%plotting correlation for gene subsets that correspond to thresholds
C = ceil(sqrt(T));
R = ceil(T/C);
for i = 1:T
    [~, I] = filter_data(data, th_datasets,thresholds(i));
    subplot(R,C,i);
    imagesc(corr(mean_data(I,:), 'type', corr_type), [0,1]);
    set(gca, 'xtick', [], 'ytick', []);
    colorbar;
    title(['threshold: ', num2str(thresholds(i)), ', #genes: ', num2str(sum(I))]);
end;

%adding legend
text_pos = [0.007 0.674 0.118 0.256];
annotation(fig1,'textbox', text_pos,'FitBoxToText','on',...
           'LineStyle','none', 'String', regexprep(mean_fields, '_', ' '));

set(findall(gcf,'type','text'),'fontSize',12, 'fontWeight', 'demi')
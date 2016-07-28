function [corr_mat]= corr_enrich(data, I, N, toPlot, header, hypo, spInds)
%CORR_ENRICH get the correlation enrichment of a go term in a data set.
%   data - a gene list by cell count matrix of data.
%   indices - the gene indices in data to be considered
%   N - number of repititions for empricial pvalue calculation.
%   toPlot - ...
%   header - if toPlot - what is the header of the plots.
%   hypo - hypethesis, either 'pVal' in which case correlation is assumed to
%   be low, or high, and an empiric pValue is calculated for each. or 'bg',
%   in which case the background correlation distribution is the null
%   hypthesis, or another logical index from which correlation distrbution
%   of the null hypthesis is computed. in case of bg or indices the ratio
%   is shown and the pvalue is the KS test between the distributions of
%   correlations.
%   returns the correlation of the columns over the given subset of rows.
%   if hypo is 'lowCor' or 'highCor', a matrix of p values is returned, otherwise
%   a matrix of the background is returned.
%   spInds - subplot indices. if given, will be used to plot the 2 plots
%   generated, otherwise a new figure is generated.

disp(['Correlation enrichment for ', num2str(sum(I)), ' genes, with ',...
      'sensitivity of 1/', num2str(N), '...']);

corr_mat = corr(data(I,:));

if toPlot
    set(0,'DefaultFigureWindowStyle','docked')
    subplot(spInds{1}(1),spInds{1}(2),spInds{1}(3));
    imagesc(corr_mat, [0,1]);
    set(gca, 'XTick',[])
    set(gca, 'YTick',[])
    xlabel('cells')
    ylabel('cells')
    title([header, ' correlation_{N: ', num2str(sum(I)), '}']);
    
end

if strcmp(hypo,'pVal')
    %empirical p-value
    low_sum_mat = zeros(size(corr_mat));
    high_sum_mat = zeros(size(corr_mat));
    S = sum(I);
    L = length(I);
    for i = 1:N
        J = randi(L,[1,S]); %random indices
        K = randi(L,[1,S]); %random indices
        low_corr_mat = corr(data(J,:));
        high_corr_mat = corr(data(K,:));
        low_sum_mat = low_sum_mat + (low_corr_mat >= corr_mat);
        high_sum_mat = high_sum_mat  + (high_corr_mat <= corr_mat);
    end
    low_sum_mat = low_sum_mat ./ N;
    high_sum_mat = high_sum_mat ./ N;
    if toPlot
        clims = [-log10(N),log10(0.05)];
        subplot(spInds{2}(1),spInds{2}(2),spInds{2}(3));
        imagesc(log10(low_sum_mat), clims);
        orderFigure()
        title('log_{10}(p-value_{Null:low})')
        subplot(spInds{3}(1),spInds{3}(2),spInds{3}(3));
        imagesc(log10(high_sum_mat), clims);
        orderFigure()
        title('log_{10}(p-value_{Null:high})')
    end
else
    if strcmp(hypo,'bg')
        bg_corr = corr(data);
    else
        bg_corr = corr(data(I));
    end
    if toPlot
        subplot(spInds{2}(1),spInds{2}(2),spInds{2}(3));
        imagesc(log2(corr_mat./bg_corr), [-2,2]);
        orderFigure()
        [~, p, ~] = kstest2(bg_corr(:),corr_mat(:));
        title(['log-ratio to bg with KS_{p-value}: ', num2str(p)])
    end
end
set(findall(gcf,'type','text'),'fontSize',12,'fontWeight','bold')
end


function [] = orderFigure()
set(gca, 'XTick',[])
set(gca, 'YTick',[])
xlabel('cells')
ylabel('cells')
end
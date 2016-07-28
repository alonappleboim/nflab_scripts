function [] = corrInSets(sets)
%CORRINSETS plot images of correlation in each set.
%   sets is a list of matrices.

set(0,'DefaultFigureWindowStyle','docked')
figure
N = length(sets);
R = ceil(sqrt(N));
C = ceil(N/R);
handles = zeros(1,N);
for i = 1:N
    data = sets{i};
    subplot(R,C,i)
    imagesc(corr(data),[0,1]);
    set(gca,'YTick',[]);
    set(gca,'XTick',[]);
    handles(i) = gca;
end
linkaxes(handles);
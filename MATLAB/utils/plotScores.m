function [] = plotScores(properties, prop_names, kernel)
%PLOTSCORES plots the properties given smoothed by kernel.
%   poperties - a cell array of values
%   prop_names - for the legend
%   kernel - a smoothing kernel

if nargin < 4
    N = ceil(length(properties{1})/100);
    kernel = ones(N,1)./N;
end
N = length(properties); %1 is for the bars.
set(0,'DefaultFigureWindowStyle','docked')
figure
clrs = varycolor(N);
C = ceil(sqrt(N));
R = ceil(N/C);
for pi = 1 : N
    [~, rank] = sort(properties{pi});
    subplot(R,C,pi);
    hold on
    for pii = 1 : N
        prop = properties{pii}(rank);
        lw = 3;
        if pi ~= pii
            prop = conv(kernel,prop);
            prop = prop(length(kernel):end-length(kernel));
            lw = 1;
        end
        plot(prop, 'Color', clrs(pii,:), 'LineWidth', lw);
    end
    title(prop_names{pi});
    set(gca, 'XTick', []);
end
legend(prop_names)
end
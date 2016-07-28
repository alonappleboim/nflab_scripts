function [ ] = pyramid_plot(im, varargin)
%PYRAMID_PLOT given an image, plots the 45-degrees-rotated and
%smoothed image inside a pyramid-like axes
% K - smoothing kernel, default is 10x10 gaussian with std 5.
% lims - the actual limits of the image data (will be written on x-axis).
%        default is [0, size(im)-1]
% tickpos - the positions in which ticks will be drawn (in image units).
% cmap - colormap
% grid - on/off
% fontsize - tick font size.
args = parse_namevalue_pairs(struct('K', fspecial('gaussian', 10, 5),...
                                    'lims', [0, size(im,1)-1],...
                                    'tickpos', 0:100:size(im,1)-1,...
                                    'cmap', AdvancedColormap('w o r'),...
                                    'grid', 'off',...
                                    'fontsize', 12),...
                             varargin);
fr = args.lims(1); to = args.lims(2);
d = to-fr;
a = sqrt(2)/2;
b = d * a;
ticks = round(args.tickpos/a);
ticklabels = fr:to;
ticklabels = ticklabels(args.tickpos+1);
colormap(args.cmap)
set(gcf, 'color', 'w');

x = conv2(im,args.K,'same');
x = imrotate(x, 45);
imagesc(x);
set(gca, 'xtick', ticks, 'xticklabel', ticklabels, 'ytick', [],...
    'box', 'off', 'ycolor', get(gcf,'color'), 'fontsize', args.fontsize);
ylim([0, d*a]);
hold on %plot borders
plot([0, b], [d*a, 0], 'k');
plot([b, size(x,2)], [0, d*a], 'k');
if strcmp(args.grid,'on')
    for t = ticks
        plot([t, t/2], [d*a,d*a-t/2], 'k--', 'linewidth', .25);
        plot([t, d/(a*2)+t/2], [d*a,t/2], 'k--', 'linewidth', .25);
    end
end
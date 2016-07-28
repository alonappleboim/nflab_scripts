function bars_with_asterisks(x, y, asterisks, thresholds, bar_args)
% A bar plot with asterisks marking certain bars.
%   x - center of bars (obtained from hist).
%   y - height of bars (obtained from hist).
%   asterisks - a vector the same length as x and y, noting the
%               number of asterisks each bar should have.
%   thresholds - optional. If given (as a vector of doubles), a
%                legend for the asterisks thresholds is drawn as
%                well. Assumed to be the same length as the
%                different number of asterisks found in given
%                asterisks vector.
%   bar_args - optional. additional arguments for the bar
%              function. e.g. {'FaceColor', 'red'}.
%
%
%example:
%
% data = rand(1000,1);
% [y,x] = hist(data,50);
% asts = randi(4, [1,length(x)]) - 1;
% thres = [1e-6, 1e-20, 1e-35];
% bars_with_asterisks(x,y,asts, thres)
% data = rand(1000,1);
% [y,x] = hist(data,50);
% asts = randi(4, [1,length(x)]) - 1;
% thres = [];
% bars_with_asterisks(x,-y,asts, thres, {'FaceColor', 'red'})
%

if nargin < 5 bar_args = {}; end
if nargin < 4 thresholds = []; end

assert(length(x) == length(y))
assert(length(x) == length(asterisks))

bar(x,y, bar_args{:});
hold on;
ylims = ylim;
asterisk_unit = min((max(abs(ylims))- abs(y)) ./ max(asterisks) + 1);
asterisk_x = zeros(1,sum(asterisks));
asterisk_y = zeros(1,sum(asterisks));
filled = 1;
for i = 1:length(asterisks)
    ast = asterisks(i);
    for a = 1:ast
        asterisk_x(filled) = x(i);
        asterisk_y(filled) = y(i) + sign(y(i)) * asterisk_unit * a;
        filled = filled + 1;
    end
end
scatter(asterisk_x, asterisk_y, 50, '*k', 'LineWidth', 1);

% generating legend
if ~isempty(thresholds)
    legend_txt = {};
    for ast = unique(asterisks(asterisks > 0))
        txt = '';
        for i = 1:ast
            txt = [txt, '*'];
        end
        txt = [txt, ' ', num2str(thresholds(ast))];
        legend_txt = {legend_txt{:}, txt};
    end
    annotation('textbox', [0.14 0.78 0.14 0.13],...
               'String',legend_txt, 'FitBoxToText','on',...
               'LineWidth',1, 'BackgroundColor','white');
end
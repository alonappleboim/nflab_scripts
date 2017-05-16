function [od, t, fit] = fit_plate_growth(od_file, varargin)
% Extracts data from a growth experiment and fits it to a 4-phase model
% (see fit_growth).
% 
%
% Written by Jenia (2012), slightly modified by Alon (2016)

args = parse_namevalue_pairs(struct('to_plot', false), varargin);

od = importdata(od_file);
vec = repmat((1:12:96)', 1, 12) + repmat(1:12, 8, 1);
vec = vec(:);
t = datenum(od.textdata(:),'mm/dd/yyyy HH:MM:SS PM');
t = (t - t(1)) * 24;
od = od.data;

tmpfit = []; tic;
for i = 1:size(od, 2)
    if mod(i,10) == 0, fprintf('fitting %i/%i (elapsed: %.1f)\n', i, size(od, 2), toc); end;
    tmpfit = [tmpfit; fit_growth(t, od(:,i))];
end

fns = fieldnames(tmpfit);
for fi = 1:length(fns)
    fit.(fns{fi}) = [tmpfit.(fns{fi})]';
end

if args.to_plot, plot_growth_params(od, t, fit); end;

end
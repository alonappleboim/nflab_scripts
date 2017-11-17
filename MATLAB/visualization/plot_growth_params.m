function [] = plot_growth_params(od, t, fit, varargin)
%%

args = parse_namevalue_pairs(struct('log', false), varargin);
R = 8;
C = 12;
clf;
axs = tile_area([8, 12], 'gap', 0.01);

i = 1;
if args.log
    od = log2(od);
end
yl = [quantile(min(od),.01), quantile(max(od),.85)];
xl = [0, max(t)];
for ci = 1:12
    for ri = 1:R
        ax = axs(ri,ci).ax();
        hold on;
        plot(t, od(:,i));
        if ri == R
            xlabel('time [hrs]')
        else
            ax.XAxis.TickValues = [];
        end
        if ci == 1
            ylabel('OD')
        else
            ax.YAxis.TickValues = [];
        end
        ylim(yl);
        xlim(xl);
        plot(ones(2,1).*fit.t_d(i),ylim,'r--')
        plot(ones(2,1).*fit.t_l(i),ylim,'r--')
        i = i + 1;
    end
end

end
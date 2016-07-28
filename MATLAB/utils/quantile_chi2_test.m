function [p,s] = quantile_chi2_test(x,y,varargin)

args = parse_namevalue_pairs(struct('xqs',[.5],'yqs',[.5]), varargin);
LX = length(args.xqs);
LY = length(args.yqs);
s = nan(LX,LY);
for xqi = 1:LX
    xq = args.xqs(xqi);
    for yqi = 1:LY
        yq = args.yqs(yqi);
        o(1,1) = sum((x < quantile(x,xq)) & (y >= quantile(y,yq)));
        o(1,2) = sum((x >= quantile(x,xq)) & (y >= quantile(y,yq)));
        o(2,1) = sum((x < quantile(x,xq)) & (y < quantile(y,yq)));
        o(2,2) = sum((x >= quantile(x,xq)) & (y < quantile(y,yq)));
        e = (sum(o,2)./sum(o(:))) * (sum(o)./sum(o(:))).*sum(o(:));
        s(xqi,yqi) = sum(sum((o-e).^2./e));
    end
end
p = 1-chi2cdf(s,1);
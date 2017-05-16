function fitobj = fit_growth(t, od)
% Fit the OD data from a single growth experiment to 4 stages: lag,
% exponential growth, diauxic growth, and stationary phase.
%
% Arguments: 
%   t - measuremnt time points
%   od - measurements
% Returns:
%   fitobj - a struct with fields:
%     r - The fitted exponential growth rate.
%     R2 - The R-square of the fit.
%     dS - The slope of the diauxic phase.
%     dSS - The sum of squares of the diauxic fit. 
%     t_d - The time point of the intersection between the exponential phase
%           and the diaxuic phase fit.
%     OD_d - The OD at the intersection between the exponential phase
%            and the diaxuic phase fit.
%     t_l - The time point of the intersection between the exponential phase
%           and the line y=mean(data(1:3) ~= lag fit).
%     OD_l - The OD at the intersection between the exponential phase
%           and the line y=mean(data(1:3) ~= lag fit).
%
% Written by Jenia (2012), slightly modified by Alon (2016)

regdata = od;
od = log2(od);
sigmoid = @(p,x) p(1)+(p(2)./(1+exp((-p(3))*(x-p(4)))));
options = optimset('Display','off');
[p, ~, ~] = lsqcurvefit(sigmoid,[-6 6 0.1 6],t,od,[-15 2 0 0],[inf inf inf max(t)],options);

minDoubling = 1/6;
len = size(od,1);
range = 7;
rs = zeros(1,len-range+1);

for i = 5:len-range+1
    [fitobject,param] = fit(t(i:i+range-1),od(i:i+range-1),'poly1');
    if fitobject.p1>minDoubling
        rs(i) = param.rsquare;
    else
        rs(i) = 0;
    end
end


[RSgr,place] = max(rs);
linpart = regdata(place:place+range-1);
[logFit] = polyfit(t(place:place+range-1),od(place:place+range-1),1);
growthRate = 1/polyder(logFit);

range2=4;
berech=1;

if len-place-range-range2-berech > 0
        
    if len-place-range-6-berech>0
        range2=6;
    elseif len-place-range-5-berech>0
        range2=5;
    else
        range2=4;
    end
        
    place2=len-range2+1;
    [fitobject,param] = fit(t(place2:place2+range2-1),od(place2:place2+range2-1),'poly1' );
    SSEdioxic=param.sse;
    linpart2=regdata(place2:place2+range2-1);
    [dioxicFit]=polyfit(t(place2:place2+range2-1),od(place2:place2+range2-1),1);
    dioxicSlope=polyder(dioxicFit);
    maxSlope=0.1;
    if dioxicSlope<maxSlope
        xinter1=(dioxicFit(2)-logFit(2))/(logFit(1)-dioxicFit(1));
        yinter1=sigmoid(p,xinter1);
    else
        dioxicSlope = nan;
        SSEdioxic = nan;
        xinter1 = nan;
        yinter1 = nan;
    end
        
else
    dioxicSlope = nan;
    SSEdioxic = nan;
    xinter1 = nan;
    yinter1 = nan;
end

xinter2 = (mean(od(1:3))-logFit(2))/(logFit(1)-0);
yinter2 = sigmoid(p,xinter2);

fitobj.r = growthRate;
fitobj.R2 = RSgr;
fitobj.dS = dioxicSlope;
fitobj.dSS = SSEdioxic;
fitobj.t_d = xinter1;
fitobj.OD_d = yinter1;
fitobj.t_l = xinter2;
fitobj.OD_l = yinter2;
end

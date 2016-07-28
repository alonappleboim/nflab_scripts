function phist(N,X,varargin)
% Polar histogram
% Syntax: phist(N,X,varargin);
% Import: N,X = frequency and positions of bin centres
% eg. [N,X]=hist(a,20);
% varargin = [1 1 1],[0.2 0.3 0.4] (optional)
% Export: None

if nargin<=1; help phist; return; end

if nargin<3; linecol=[0 0 0]; 
else linecol=varargin{1}; end

if nargin<4; fillcol=[0.5 0.5 0.5]; 
else fillcol=varargin{2}; end

pieslc = X(2)-X(1);
dang = pieslc/10;
figure; hold on;

for k = 1:length(X);
   
   start = X(k)-pieslc/2;
   stop = X(k)+pieslc/2;
   r = N(k);
   
   % Plot the arc
   a=[start:dang:stop];
   a=pi*a/180;
   xa=r*cos(a); ya=r*sin(a);
   line(xa,ya,'Color',linecol);
   
   % Plot the rays
   xr = [0,xa(1)]; yr = [0,ya(1)];
   line(xr,yr,'Color',linecol);
   xr2 = [0,xa(length(xa))]; yr2 = [0,ya(length(ya))];
   line(xr2,yr2,'Color',linecol);
   
   % Fill it
   tempx = [xr xa xr2];
   tempy = [yr ya yr2];
   patch(tempx,tempy,fillcol);
end
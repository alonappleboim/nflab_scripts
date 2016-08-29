function sx = stretch(x,L)
% Stretch vector x to have length L
%
% Arguments:
%  x - Vector to stretch.
%  L - Target length.
%
% Returns:
%  linearly interpolated vector sxwith length(sx) == L.
%
% Example:
%  >> x = [1:10].^2;
%  >> sx = stretch(x,20);
%  >> plot(1:10,x,1:20,sx);
%

sx = interp1(x,1:(length(x)-1)/(L-1):length(x));

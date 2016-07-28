function sx = stretch(x,L)
%stretch vector x to have length L
sx = interp1(x,1:(length(x)-1)/(L-1):length(x));

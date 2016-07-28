function [smoothed, unordered] = smooth_with_dist(data, pos, kernel)
% smoothes data row vector according to positions and a kernel function.
%
%   data - a vector of values to be smoothed (e.g. methylation%);
%   pos - a corresponding vector with positions of data points along some
%         linear space (e.g. position on chromosome).
%   kernel - a struct triplet:
%            func - either a string in ['gaussian', 'gaussian_abs', 'uniform']
%                   or a function handle that is given:
%                      v: a row vector of data to smooth
%                      d: corresponding distances (that can be negative,
%                         indicating directionality)
%                      params: a struct with parameters used by the function.
%               and returns a scalar value. (see 3 examples below).
%            window - the window size to be passed to the function
%            params - to be passed to the function
%
%   returns the sorted, smoothed vector, and the smoothed, original order
%   vector.
%

if nargin < 3
    kernel = struct('func', 'gaussian','window', 50,'params',...
                    struct('sigma', 1e-3));
end;

if ischar(kernel.func)
    switch kernel.func
        case 'gaussian'
            kernel.func = @(d,v,params)gaussian_dist_smooth(d, v, params);
        case 'abs_gaussian'
            kernel.func = @(d,v,params)gaussian_abs_dist_smooth(d, v, params);
        case 'uniform'
            kernel.func = @(d,v,params)no_dist_smooth(d, v, params);
        otherwise
            error('kernel name not known');
    end;
end;

D = length(data);

[sorted_pos, ord] = sort(pos);
sorted_data = data(ord);
smoothed = zeros(1,D);
for i = 1:D
    start_i = max(1, ceil(i-kernel.window/2));
    end_i = min(D, floor(i+kernel.window/2));
    dists = sorted_pos(start_i:end_i) - sorted_pos(i);
    vals = sorted_data(start_i:end_i);
    smoothed(i) = kernel.func(dists, vals, kernel.params);
end

[~, inv_ord] = sort(ord);
unordered = smoothed(inv_ord);
end

function v_i = gaussian_dist_smooth(d, v, params)
%v is a row vector of data to smoothe, d is the corresponding distance
%vector (that can be negative, indicating directionality), and params are
%kernel parameters, in this case - a sigma for the exponent weighing function.
    w = exp(-d.*d.*params.sigma);
    w = w./sum(w);
    v_i = w*v';
end

function v_i = gaussian_abs_dist_smooth(d, v, params)
%v is a row vector of data to smoothe, d is the corresponding distance
%vector (that can be negative, indicating directionality), and params are
%kernel parameters, in this case - a sigma for the exponent weighing function.
    w = exp(-abs(d).*params.sigma);
    w = w./sum(w);
    v_i = w*v';
end

function v_i = no_dist_smooth(d, v, params)
%v is a row vector of data to smoothe, d is the corresponding distance
%vector (that can be negative, indicating directionality), and params are
%kernel parameters, in this case - a sigma for the exponent weighing function.
    w = ones(1,length(d));
    w = w./sum(w);
    v_i = w*v';
end
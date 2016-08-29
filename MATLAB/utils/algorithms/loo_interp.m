function [iy, ix, fitinfo] = loo_interp(y, x, varargin)
% leave-one-out interpolation.
%
% Arguments:
%  y - A matrix of samples over free variable x (NxM).
%  x - Free variable values (1xM). Should be monotonically increasing.
%
% Name/Value Arguments:
%  wout - Weighted outliers. When calculating the model, whether every
%         partition will be weighted by its relative error, or will all
%         paritions be treated as equals (effectiely gives less weight to
%         outliers).
%  type - interpolation type: linear/spline/pchip (see MATLAB's interp).
%         default = pchip.
%  ix - The interpolated free variable values (1xMM). default is
%       between min(x) and max(x), with 3xM points linearly spaced.
%  ss - Whether to add "steady state" values:
%           y(min(x)-(max-min)) = y(min(x))
%          y(max(x)+(max-min)) = y(max(x))
%       (otherwise, end points are not considered). default is true.
%  warn - Whether warnings should not be suprassed when interpolating.
%         default = true.
% Returns:
%  iy - The interpolated response (NxMM).
%  ix - The free variable values (1xMM).
%  err - error per sample and value omitted
%
[N, M] = size(y);
assert(size(x,1) == 1 & size(x,2) == M & all(diff(x)>0), ...
       'x should be a row vector with M monotonically ascending entries')
def = struct('wout', true, 'type', 'pchip',...
             'ix', linspace(x(1), x(end), 3*M), 'ss', true, ...
             'warn', false);
args = parse_namevalue_pairs(def, varargin);
assert(all(x(1) <= args.ix & args.ix <= x(end)), ...
       'ix should lie in the interval [min(x), max(x)]');
if args.ss
    x = [x(1)-(x(end)-x(1)), x, x(:,end)+(x(end)-x(1))];
    y = [y(:,1), y, y(:,end)];
end
ix = args.ix;
warning on;
if ~args.warn, warning off; end;
M = length(x); % note that only internal points are considered (M-2 points)
MM = length(ix);

err = nan(N, M-2);
iy = nan(N, MM, M-2);
for looi = 2:M-1
    in = 1:M ~= looi;
    kx = x(in);
    nidx = sum(~isnan(y(:,in)),2) >= 2; % only keeping samples with more than two numbers
    ky = y(nidx, in);
    if isempty(ky), continue, end;
    kix = [x(looi), ix];
    kiy = interp1(kx, ky.', kix, args.type).';
    if size(kiy,1)==MM+1, kiy = kiy.'; end
    err(nidx,looi-1) = abs(kiy(:,1)-y(nidx,looi));
    iy(nidx, :, looi-1) = kiy(:,2:end);
end
if ~args.wout
    iy = nanmean(iy, 3); %average over exclusions
else
    w = normat(1./(err+eps), 2); % and normalize per partition
    w = permute(repmat(w,[1,1,MM]),[1,3,2]);
    iy = nansum(iy.*w,3);
end

fitinfo = struct();
fitinfo.err = nanmean(err,3);
end
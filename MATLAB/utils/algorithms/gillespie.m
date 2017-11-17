function traj = gillespie(s0, R, T)
% Sample trajectories from a rate matrix R, untile time T
%
% Arguments:
%   s0 - System state at t=0, a column vector with an entry per trajectory
%   R - In the finite homogeneous case:
%           A matrix (sparse/full) mapping transition rates
%       In the infinite/inhomogeneous case:
%           A function handle mapping a vector pair (state, time) to a
%           matrix pair (states, rates)
%   T - End time for simulation, all trajectories will have t, with T <= t,
%       by the end of the simulation.
%
% Returns:
%   traj - a struct with 2 fields:
%          times - elapsed time, an NxT matrix, with rows corresponding to
%                  independent trajectories.
%          states - states corresponding to traj.times.
%          synced - a function handle res-> [t,s], that returns a synced
%                   version of times and states with desired res (default
%                   is the length of times);
%
% Usage:
% >> tic; traj = gillespie(randi(3,[1000,1]), exp(.5.*randn(3)).*(1-eye(3)), 500); toc;
% Elapsed time is 0.539782 seconds.
% >> stairs(traj.times(:,1000).',traj.states(:,1000).');
%
% % RNA simulation with deg=2, prod=1|10, and open promoter when 100<t<400 || 1000<t
% >> R = @(i,t)group_inputs([i-1,i+1],[i.*2,1+10.*((t>1000)|(t>100&t<500))]);
% >> tic; traj = gillespie(randi(15,[1000,1]), R, 1000); toc;
% Elapsed time is 0.723300 seconds.
% >> stairs(traj.times(:,1:10).',traj.states(:,1:10).');
%

MIN_SIZE = 10;

assert(isvector(s0), 's0 should be a column vector');
if size(s0,1) < size(s0,2), s0 = s0.'; end
N = length(s0);

traj.states = NaN(N, MIN_SIZE);
traj.times = NaN(N, MIN_SIZE);

traj.states = NaN(N, MIN_SIZE);
traj.times = NaN(N, MIN_SIZE);
traj.times(:,1) = 0;
traj.states(:,1) = s0;

isfinite = ~isa(R, 'function_handle');

if isfinite
    sR = sum(R,2);
    nR = normat(R,2);
end

i = 2; next = [];

while true
    % update next
    if ~isfinite
        [next, r] = R(traj.states(:,i-1),traj.times(:,i-1));
        sr = sum(r,2);
        nr = normat(r,2);
    else
        sr = sR(traj.states(:,i-1));
        nr = nR(traj.states(:,i-1),:);
    end
    traj.times(:,i) = traj.times(:,i-1) + exprnd(1./sr); %notice that exprnd uses 1/lambda parametrization!
    traj.states(:,i) = sample_next(nr, next);
    
    % housekeeping
    if all(traj.times(:,i-1) >= T), break; end
    i = i + 1;
    next = [];
    if i > size(traj.times,2) % increase size
        traj.times = [traj.times, nan(size(traj.times))];
        traj.states = [traj.states, nan(size(traj.times))];
    end
end

traj.times = rmnan(traj.times);
traj.states = rmnan(traj.states);
traj.sync = @(varargin)sync_traj(traj, varargin{:});
end

function s = sample_next(p, next) % p sums to 1 row-wise, next (optional) is the corresponding states
    ind = mnrnd(ones(size(p,1),1),p);    
    if isempty(next) % finite case
        [i,j] = find(ind);
        [~,ord] = sort(i);
        s = j(ord);
    else
        next = next.';
        s = next(ind.'==1);
    end
end

function [s, t] = sync_traj(traj, varargin)
    % generate a state matrix with a synced time vector, t
    [N,T] = size(traj.times);
    if isempty(varargin), res = T; else res = varargin{1}; end
    rows = (1:N)';
    t = linspace(0, min(traj.times(:,end)),res);
    s = nan(N,res);
    for ti = 1:res
        [~, first] = max(traj.times>t(ti),[],2); % find first later than t(ti), its index-1 corresponds to state at t(ti)
        first(first==1) = T; % handle unique case of max(traj.times,2)==min(traj.times(:,end)), i.e. no traj.times>t(ti), hence first==0.
        linidx = sub2ind([N,T], rows, first-1);
        s(:,ti) = traj.states(linidx);
    end
end

%% debug 
% for i = 1: N
%     clf;
%     stairs(traj.times(i,:), traj.states(i,:));
%     hold on; 
%     plot(t(ti)*[1,1],ylim,'r');
%     scatter(traj.times(i,:),traj.states(i,:),25,traj.states(i,:),'filled');
%     xlim([t(ti)-T/res,t(ti)+T/res]);
%     title(s(i,ti))
%     pause;
% end
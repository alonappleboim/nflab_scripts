function varargout = group_inputs(varargin)
% Accesory function to group variables so they can be returned by an
% anonymous function.
% 
% Example:
% >> w = @(x,y,z)group_inputs(x+y,x/z,y*z);
% >> [i,j,k] = w(1,2,3)
% i =
% 
%      3
% 
% 
% j =
% 
%     0.3333
% 
% 
% k =
% 
%      6
varargout = varargin;
end
classdef LinODESys < handle
    %LinODESys A system of linear ODEs: x' = A*x
    
    properties
        A %the system parameters
        U %the eigenvectors of the system
        D %the eigenvalues of the system
        N %number of system variables
    end
    
    methods
        
        function self = LinODESys(A)
            self.A = A;
            self.N = size(A,1);
            [self.U, self.D] = eig(A);
            self.D = diag(self.D);
        end
        
        function [x_ss] = steady_state(self, x0)
            % Solve steady state solution
            % 
            % Arguments:
            %  x0 - initial conditions.
            %  
            % Returns:
            %  x_ss - the steady state solution.
            %
            C = self.U\x0;
            if all(real(self.D) <= 0)
                i = find(any(abs(self.D) < eps));
                if isempty(i)
                    x_ss = zeros(self.N,1);
                else
                    x_ss = real(self.U(:,i)*(C(i)));                    
                end
            else
                x_ss = [];
            end
        end
        
        
        function [x_t] = dynamics(self, x0, t)
            % Solve system dynamics
            % 
            % Arguments:
            %  x0 - initial conditions.
            %  t - time points at which variables should be evluated.
            %  
            % Returns:
            %  x_t - variable values at requested time points.
            %
            C = self.U\x0;
            T = length(t);
            x_t = real(self.U*((C*ones(1,T)).*exp(self.D*t)))';
        end
    end
end


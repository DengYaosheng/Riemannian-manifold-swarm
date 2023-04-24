% Define the Riemannian manifold (a 2D sphere)
manifold = spherefactory(2);

% Define the dynamics of the particle
classdef ParticleDynamics < gctDynamics
    methods
        function obj = ParticleDynamics(manifold)
            obj = obj@gctDynamics(manifold);
        end
        
        function xdot = dynamics(obj, t, x, u)
            xdot = u;  % Control input is the velocity
        end
    end
end

% Define the initial state of the particle
x0 = manifold.rand();

% Define the dynamics of the particle
dynamics = ParticleDynamics(manifold);

% Simulate the motion of the particle
tspan = linspace(0, 10, 1000);
dt = tspan(2) - tspan(1);
us = zeros(2, 1);  % Constant control input (velocity)
x = x0;
for t = tspan
    xdot = dynamics.dynamics(t, x, us);
    x = manifold.integrate(x, dynamics, t, dt, xdot);
end

% Plot the trajectory of the particle
plot(manifold.exp(xspan(:,1)), manifold.exp(xspan(:,2)), 'b-');

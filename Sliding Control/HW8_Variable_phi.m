% ------------------------------------------------------------------------
% University of Maryland, College Park
% ENME 808B - Applied Nonlinear Controls
% Homework #8
% Due November 5, 2018
%
% David A Smart
% November 1, 2018
% ------------------------------------------------------------------------
%% Problem Statement
% Consider the nonlinear system 
%       x_dotdot + a(t)*x_dot^2*cos(3*x) = u
%       1 <= a(t) <= 2
%       x_d(t) = sin((pi/2)*t)
%
% variable phi interpolated control law
%       u = u_hat - k_bar*sat(s/phi)
%       phi_dot = k_d - lambda*phi;
%       k_bar = k - phi_dot;
%       eta = 0.1;
%       phi = 0.1;
%       lambda = 20;
% ------------------------------------------------------------------------
%% clean up
close all
clear
clc

% ------------------------------------------------------------------------
%% setup
% controller parameters
eta = 0.1;
lambda = 20;
phi(1) = 0.1;

% simulation time-step
dt = 0.0001;

%% initial conditions
% time
t(1) = 0;

% state
x(1) = 0;
x_dot(1) = 0;
x_dotdot(1) = 0;
a(1) = 1 + abs(sin(t(1)));
f(1) = 0;

% desired trajectory
x_d(1) = sin((pi/2)*t(1));
x_d_dot(1) = (x_d(1)-0)/dt;
x_d_dotdot(1) = (x_d_dot(1)-0)/dt;

% error
x_tilda(1) = x(1) - x_d(1);
x_tilda_dot(1) = (x_tilda(1) - 0)/dt;
x_tilda_dotdot(1) = (x_tilda_dot(1) - 0)/dt;

% control input
f_hat(1) = -1.5*x_dot(1)^2*cos(3*x(1));
v(1) = x_d_dotdot(1) - lambda*x_tilda_dot(1);
u_hat(1) = -f_hat(1) + v(1);
F(1) = 0.5*x_dot(1)^2*abs(cos(3*x(1)));
k(1) = F(1) + eta;
s(1) = x_tilda_dot(1) + lambda*x_tilda(1);
F_d(1) = 0.5*x_d_dot(1)^2*abs(cos(3*x_d(1)));
k_d(1) = F_d(1) + eta;
phi_dot(1) = k_d(1) - lambda*phi(1);
k_bar(1) = k(1) - phi_dot(1);
u(1) = u_hat(1) - k_bar(1)*sat(s(1), phi(1));
 
% ------------------------------------------------------------------------
%% time-loop
for i = 2:(4/dt)
    % time
    t(i) = t(i-1) + dt;

    % state
    a(i) = 1 + abs(sin(t(i)));
    f(i) = a(i)*x_dot(i-1)^2*cos(3*x(i-1));
    x_dotdot(i) = u(i-1) - f(i);
    x_dot(i) = x_dot(i-1) + dt*x_dotdot(i-1);
    x(i) = x(i-1) + dt*x_dot(i-1);

    % desired trajectory
    x_d(i) = sin((pi/2)*t(i));
    x_d_dot(i) = (x_d(i) - x_d(i-1))/dt;
    x_d_dotdot(i) = (x_d_dot(i) - x_d_dot(i-1))/dt;

    % error
    x_tilda(i) = x(i) - x_d(i);
    x_tilda_dot(i) = (x_tilda(i) - x_tilda(i-1))/dt;
    x_tilda_dotdot(i) = (x_tilda_dot(i) - x_tilda_dot(i-1))/dt;

    % control input
    phi(i) = phi(i-1) + phi_dot(i-1)*dt;
    f_hat(i) = -1.5*x_dot(i)^2*cos(3*x(i));
    v(i) = x_d_dotdot(i) - lambda*x_tilda_dot(i);
    u_hat(i) = -f_hat(i) + v(i);
    F(i) = 0.5*x_dot(i)^2*abs(cos(3*x(i)));
    k(i) = F(i) + eta;
    s(i) = x_tilda_dot(i) + lambda*x_tilda(i);
    F_d(i) = 0.5*x_d_dot(i)^2*abs(cos(3*x_d(i)));
    k_d(i) = F_d(i) + eta;
    phi_dot(i) = k_d(i) - lambda*phi(i);
    k_bar(i) = k(i) - phi_dot(i);
    u(i) = u_hat(i) - k_bar(i)*sat(s(i), phi(i));
end
% -------------------------------------------------------------------------
%% Display
figure(1)
set(gcf,'Units','normalized','Position',[0.1 0.1 0.8 0.8]); % large

subplot(1,2,1);
plot(t, u);
xlabel('time (s)')
ylabel('control input')
title('EXTRA - Variable Phi')
axis([0 4 -6 6])

subplot(1,2,2);
plot(t, x_tilda);
xlabel('time (s)')
ylabel('tracking error')
title('EXTRA - Variable Phi')
axis([0 4 -5*10^-3 5*10^-3])
%% ------------------------------------------------------------------------
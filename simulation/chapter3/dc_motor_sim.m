% DC_MOTOR_SIM  Step response of a brushed DC motor (ME 435, Chapter 3).
%
% Simulates the coupled electrical + mechanical state-space model in
% dc_motor_ode.m and plots the armature current and shaft speed when a
% step voltage is applied to a motor starting from rest.
%
% HOW TO RUN: keep this file and dc_motor_ode.m in the same folder,
%             open this file in MATLAB, and press Run (F5).

clc; clear; close all;

% ---------------- Motor parameters ----------------
p.Ra = 1.0;     % Armature resistance         [Ohm]
p.La = 0.01;    % Armature inductance         [H]
p.K  = 0.1;     % Motor constant Kt = Ke = K  [N*m/A = V*s/rad]
p.J  = 0.01;    % Rotor inertia               [kg*m^2]
p.b  = 0.001;   % Viscous damping             [N*m/(rad/s)]

% ---------------- Inputs --------------------------
p.v_a   = 15;   % Step armature voltage        [V]
p.tau_L = 0;    % Load torque (disturbance)    [N*m]

% ---------------- Simulate ------------------------
tspan = [0 5];          % time window [s]
x0    = [0; 0];         % start from rest:  omega = 0,  i_a = 0

[t, x] = ode45(@(t,x) dc_motor_ode(t, x, p), tspan, x0);

omega = x(:,1);         % shaft speed     [rad/s]
i_a   = x(:,2);         % armature current [A]

% ---------------- Plot ----------------------------
figure('Name', 'DC motor step response', 'Color', 'w');

subplot(2,1,1)
plot(t, i_a, 'LineWidth', 1.5); grid on
ylabel('Armature current  i_a  [A]')
title(sprintf('DC motor step response   (v_a = %g V,  \\tau_L = %g N\\cdotm)', ...
              p.v_a, p.tau_L))

subplot(2,1,2)
plot(t, omega, 'LineWidth', 1.5); grid on
ylabel('Shaft speed  \omega  [rad/s]')
xlabel('Time  [s]')

% ---------------- Steady-state check --------------
% Setting both derivatives to zero gives:
%   omega_ss = v_a * K / (K^2 + Ra*b),   i_a_ss = b*omega_ss / K
omega_ss = p.v_a * p.K / (p.K^2 + p.Ra*p.b);
i_a_ss   = p.b * omega_ss / p.K;
fprintf('Steady state:  omega ~ %.1f rad/s,  i_a ~ %.3f A\n', omega_ss, i_a_ss);

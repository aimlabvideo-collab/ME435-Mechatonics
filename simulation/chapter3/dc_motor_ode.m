function dxdt = dc_motor_ode(t, x, p)
% DC_MOTOR_ODE  State-space model of a brushed DC motor (ME 435, Chapter 3).
%
%   The two coupled first-order ODEs derived in class (electrical + mechanical):
%
%       d(omega)/dt = -(b/J)  * omega + (K/J)  * i_a - (1/J) * tau_L
%       d(i_a)/dt   = -(K/La) * omega - (Ra/La)* i_a + (1/La)* v_a
%
%   State vector:
%       x(1) = omega   angular speed     [rad/s]
%       x(2) = i_a     armature current  [A]
%
%   p is a struct of parameters/inputs (see dc_motor_sim.m):
%       p.Ra, p.La, p.K, p.J, p.b, p.v_a, p.tau_L
%
%   The -(K/La)*omega term is the BACK-EMF: the motor opposing its own
%   supply. It is the coupling that makes the motor self-regulate its speed.

    omega = x(1);
    i_a   = x(2);

    domega_dt = -(p.b/p.J) *omega + (p.K/p.J) *i_a - (1/p.J) *p.tau_L;   % Newton
    dia_dt    = -(p.K/p.La)*omega - (p.Ra/p.La)*i_a + (1/p.La)*p.v_a;    % KVL

    dxdt = [domega_dt; dia_dt];
end

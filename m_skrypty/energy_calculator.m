% Script to calculate energy of the inverted pendulum
J = 0.0064;
M = 0.768;
m = 0.033 * 2;
L = 0.25;
g = 9.81;

fprintf("Total energy to control the pendulum: %.4f\n", m*g*L*cos(0.2));

% Wagi
1.0;    % K_reg(1)
0.1;    % K_reg(2)
0.5;    % K_reg(3)
0.05;   % K_reg(4)

clear all;
close all;

% Parametry układu
J = 0.0064;
M = 0.768;
m = 0.033 * 2;
L = 0.25;
g = 9.81;
x_pocz = pi - 0.01;
x_konc = pi;
Q2 = (J*(M+m) + M*m*L*L);

% Macierze stanu
A = [ 0 1 0 0;
    0 0 -m*m*g*L*L/(J*(M+m) + m*M*L*L) 0;
    0 0 0 1;
    0 0 ((M+m)*m*g*L)/(J*(M+m) + m*M*L*L) 0];

B = [0;
    0.5*(J + m*L*L)/(J*(M+m) + m*M*L*L);
    0
    -0.5*m*L/(J*(M+m) + m*M*L*L)];

Q = [100 0 0 0; 
    0 100 0 0;
    0 0 3600 0; 
    0 0 0 100]; % Macierz obserwatora
R = 0.5; % Macierz regulacji

% Obliczenie macierzy LQR
K_reg = lqr(A,B,Q,R);

A_N = (A - B*K_reg);
syms s
Im = s.*[1 0 0 0; 
        0 1 0 0; 
        0 0 1 0;
        0 0 0 1];
eqs = det(Im - A_N);
vpa(solve(eqs, s))
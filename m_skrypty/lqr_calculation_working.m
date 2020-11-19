clear all;
close all;

% Parametry układu
J = 0.0064;
J_w = J;
M = 0.768;
m = 0.033 * 2;
L = 0.25;
g = 9.81;
th_pocz = pi - 0.25;
th_konc = 0;
Q2 = (J*(M+m) + M*m*L*L);
Cntrl = 0.1;

% Macierze stanu
A = [ 0 1 0 0;
    0 0 m*m*g*L*L/(J*(M+m) + m*M*L*L) 0;
    0 0 0 1;
    0 0 ((M+m)*m*g*L)/(J*(M+m) + m*M*L*L) 0];

B = [0;
    -(J + m*L*L)/(J*(M+m) + m*M*L*L);
    0;
    m*L/(J*(M+m) + m*M*L*L)];

C = [1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1];

D = [0; 0; 0; 0];

tf = ss2tf(A, B, C, D);

Q = [1000 0 0 0; 
    0 1000 0 0;
    0 0 3600 0; 
    0 0 0 1000]; % Macierz obserwatora
R = 10; % Macierz regulacji

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
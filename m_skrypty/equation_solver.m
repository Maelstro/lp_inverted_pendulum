clear all;
close all;

% Definicja rownan
syms D2x D2th Dth th M m F L J P N g
eqn1 = (M + m)*D2x - m*L*D2th*cos(th) + m*L*sin(th)*Dth^2 == F;
eqn2 = (J + m*L^2)*D2th - m*L*D2x*cos(th) + m*g*L*sin(th) == 0;
eqns = [eqn1 eqn2];

simplify(eqn2)

% Solver
S = solve(eqns, [D2x D2th]);
fprintf("D2x = \n");
pretty(S.D2x)

fprintf("\n");
fprintf("\n");

fprintf("D2th = \n");
pretty(S.D2th)

%% Linearyzacja

% Definicja rownan
syms D2x D2th Dth th M m F L J P N g
eqn1 = (M + m)*D2x + m*L*D2th == F;
eqn2 = (J + m*L^2)*D2th +m*L*D2x - m*g*L*th == 0;
eqns = [eqn1 eqn2];

simplify(eqn2)

% Solver
S = solve(eqns, [D2x D2th]);
fprintf("D2x = \n");
pretty(S.D2x)

fprintf("\n");
fprintf("\n");

fprintf("D2th = \n");
pretty(S.D2th)
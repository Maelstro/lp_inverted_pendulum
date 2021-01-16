% Wykresy
figure(1)
set(gcf,'position',[0,0,1000,2500])
subplot(5,1,1);
plot(P1_ExpData.time, P1_ExpData.signals(1).values);
grid on;
title('Sygnał sterowania');
xlabel('Czas [s]');
ylabel('Sygnał sterowania [-]');
axis([0 90 min(P1_ExpData.signals(1).values)-0.2 max(P1_ExpData.signals(1).values)+0.2]);
ytickangle(90);

subplot(5,1,2);
plot(P1_ExpData.time, P1_ExpData.signals(2).values);
grid on;
title('Położenie wózka');
xlabel('Czas [s]');
ylabel('Położenie wózka [m]');
axis([0 90 min(P1_ExpData.signals(2).values)-1 max(P1_ExpData.signals(2).values)+1]);
ytickangle(0);

subplot(5,1,3);
plot(P1_ExpData.time, P1_ExpData.signals(3).values);
grid on;
title('Prędkość wózka');
xlabel('Czas [s]');
ylabel("Prędkość wózka [m/s]");
axis([0 90 -2 2]);
ytickangle(0);

subplot(5,1,4);
plot(P1_ExpData.time, P1_ExpData.signals(4).values);
grid on;
title('Położenie wahadła');
xlabel('Czas [s]');
ylabel('Położenie wahadła [rad]');
axis([0 90 min(P1_ExpData.signals(4).values)-1 max(P1_ExpData.signals(4).values)+1]);
ytickangle(0);

subplot(5,1,5);
plot(P1_ExpData.time, P1_ExpData.signals(5).values);
grid on;
title('Prędkość wahadła');
xlabel('Czas [s]');
ylabel('Prędkość wahadła [1/s]');
axis([0 90 -10 10]);
ytickangle(0);
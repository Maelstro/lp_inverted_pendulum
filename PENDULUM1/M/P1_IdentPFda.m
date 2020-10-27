disp('Pendulum friction - Data analysis');

save p1_ident_pf
load p1_ident_pf

Time = P1_ExpData.time;
PendPos = P1_ExpData.signals(2).values;

plot(Time, PendPos);
grid on;
xlabel('Time [s]');
ylabel('Pendulum angle [rad]');

SmplT = Time(2)-Time(1);
t = SmplT;

%---------------------------------------------------------
tAngH=[];
AngH=[];
lastH=0;
gl=0;

 w = PendPos + pi;
 for i=1:length(w)-1,
  if w(i) > pi,
   if (w(i+1) < w(i)) & (lastH==0) ,
    tAngH=[tAngH i];
    AngH=[AngH w(i)];
    lastH=1;
   end;
  else
   lastH=0;
  end;
 end;
 tAngH(1)=[];
 tAngH(length(tAngH))=[];
 AngH(1)=[];
 AngH(length(AngH))=[];
 gl=length(tAngH);
Okresy=[];
n=1;
while n<gl,
 Okresy(n)=tAngH(n+1)-tAngH(n);
 n=n+1;
end
Okr=sort(Okresy);
Okr(1)=[];
Okr(length(Okr))=[];
gl=length(Okr);

T=t*sum(Okr)/(gl);		%Period

%------------------------------------------

tData = Time;
Data = PendPos + pi;

tData=tData-tData(1,1);
w=Data;
tAngH=[];
AngH=[];
posAH=[];
lastH=0;
gl=0;
for i=1:length(w)-1,
 if w(i) > pi,
  if (w(i+1) < w(i)) & (lastH==0) ,
   tAngH=[tAngH tData(i)];
   AngH=[AngH w(i)];
   posAH=[posAH i];
   lastH=1;
  end;
 else
  lastH=0;
 end;
end;
tAngH(1)=[];
tAngH(length(tAngH))=[];
AngH(1)=[];
AngH(length(AngH))=[];
gl=length(tAngH);



%subplot(311);
plot(tData-tData(1,1),w);
hold on
title('Pendulum angle');
xlabel('Time [s]');
ylabel('Angle [rad]');
plot(tAngH-tData(1,1),AngH,'ro');
x1=pi-AngH(1);
%axis([0 tData(1,length(w))-tData(1,1) pi+x1 pi-x1]);
grid;
hold off


dAngH=AngH-AngH(1);

a=[];
ta=[];
qw=dAngH(1);
st=qw;
for i=1:length(dAngH),
   if dAngH(i)<qw,
      a=[a dAngH(i)];
      ta=[ta tAngH(i)]; 
     qw=dAngH(i);
   end
end
aa=[];
for i=1:length(a)-1,
   aa=[aa a(i+1)-a(i)];
end;

Lta=length(ta);

%subplot(312);
%plot(tData(ceil(ta(Lta-3)/SmplT):ceil(ta(Lta-1)/SmplT)-1),Data(ceil(ta(Lta-3)/SmplT):ceil(ta(Lta-1)/SmplT)-1));
%axis([tData(ceil(ta(Lta-3)/SmplT)) tData(ceil(ta(Lta-1)/SmplT)-1) Data(ceil(ta(Lta-3)/SmplT))-0.01 Data(ceil(ta(Lta-3)/SmplT))]);
%xlabel('Time [s]');
%ylabel('Angle [rad]');
%grid;
%a(1:3);
%ta(1:3);

AmplA=AngH-pi;
x1=1;
x2=length(AmplA)-1;

fpc=2*log(AmplA(x1)/AmplA(x2))/(((2*x2-1)-x1)*T);

disp('-----------------------------------------------------------------------------');
disp('Pendulum friction identification results:');
s = sprintf('\nPendulum period = %f',T);
disp(s);
s = sprintf('\nPendulum friction coefficient = %f',fpc);
disp(s);





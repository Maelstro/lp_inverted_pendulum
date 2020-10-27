function P1_IdentTMC

PEND_POS_ID	= 4;
CART_POS_ID	= 5;
CONTROL_ID	= 2;
PWM_VALUES	= [0 0 0];
D_PWM		= 0.005;
D_POS		= 0.05;		% [m]
DELAY_TIME	= 0.1;		% [s]
EXP_NAME	= 'Try to move the cart';

p1 = pendulum1;
PWM_VALUES	= [0 0 0];  
set(p1,'pwm',PWM_VALUES);


answer = p_lib('quest','Question','Is the motor switched on ?');
Cnt = 0;
while answer==0,
  dummy = p_lib('inf','Information','Turn motor on and press OK !');
  answer = p_lib('quest','Question','Is the motor switched on ?');
  Cnt = Cnt + 1;
  if Cnt == 2,
     answer1 = p_lib('quest','Question','Would you like to terminate the experiment?');
     if answer1==1,
        disp('User break !');
        return;
     else
        Cnt = 0;
     end
  end
  
end;

p1=pendulum1;

set(p1,'pwmprescaler',0);

CartPositions = [];
ControlValues = [];

dummy = p_lib('inf',EXP_NAME,'Set the cart at the left side!');
set(p1,'resetencoder',[0 0 0 1 1]);
set(p1,'resetencoder',[0 0 0 0 0]);
h = P1_InfoMsgBox(EXP_NAME, 'The cart is moving from the left to the right' );


for Direction = -1:2:1,

   if Direction == 1,
      dummy = p_lib('inf',EXP_NAME,'Set the cart at the right side!');      
      h = P1_InfoMsgBox(EXP_NAME, 'The cart is moving from the right to the left' );
   end

    while 1
    PWMVal = 0; 
    Pos = get(p1,'position');
    CartPosB = Pos(CART_POS_ID);

        while 1,
           PWM_VALUES(CONTROL_ID) = PWM_VALUES(CONTROL_ID) + D_PWM*Direction;
           set(p1,'pwm',PWM_VALUES);
           pause(0.300)
           Pos = get(p1,'position');
           CartPosE = Pos(CART_POS_ID);
           if abs(CartPosE-CartPosB) > D_POS,
              PWMVal = PWM_VALUES(CONTROL_ID);
              PWM_VALUES(CONTROL_ID) = 0;
              set(p1,'pwm',PWM_VALUES);
              break;
           end
        end;

    CartPositions = [CartPositions; CartPosB];
    ControlValues = [ControlValues; PWMVal];
    pause(DELAY_TIME);

    if CartPosE > 1.8 & Direction == -1, break; end;
    if CartPosE < 0.2 & Direction == 1, break; end;

    end;
    close(h);
end;

i    = find(ControlValues<0);
idxp = i(1);
idxk = i(end);
len  = length(ControlValues);

figure(1);
subplot(211);
bar(CartPositions(idxp:idxk), abs(ControlValues(idxp:idxk)));
xlabel('Cart position [m]'); ylabel('abs(PWM Control)');
grid; axis([0 2 0 max(abs(ControlValues(idxp:idxk))) ]);
title('Cart movement: Left to Right');

subplot(212);
bar(CartPositions(idxk+1:len), abs(ControlValues(idxk+1:len)));
xlabel('Cart position [m]'); ylabel('abs(PWM Control)');
grid; axis([0 2 0 max(abs(ControlValues(idxk+1:len))) ]);
title('Cart movement: Right to Left');

CVl2r = mean(ControlValues(idxp:idxk));
CVr2l = mean(ControlValues(idxk+1:len));

disp(CVl2r);
disp(CVr2l);
DZu = mean(abs([CVl2r CVr2l]));

save p1_ident_tmc


disp('-----------------------------------------------------------------------------');
disp('Minimum force needed to move the cart. Results:');
s = sprintf('Medium value of the Control signal value over the rail is: %f',DZu);
disp(s);

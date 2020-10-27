%
% P1_parameters.m
% 
% Pendulum 1 parameters
% 
% Copyright (c) 2002 by InTeCo/AT/AP
% All Rights Reserved
%  
%
% ***************************************************************************************************************************
% Constant
   g		=	9.81;		% [kg*m/s2]

% ***************************************************************************************************************************
% Measured

    m1		=	0.298;		% [kg]	%cart mass
    m2		=	0.024;		% [kg]	%pendulum holder mass
    m3		=	0.161;		% [kg]	%teeth wheel mass
    mzL		=	0.1458;		% [kg]	%left mass (DC rotor + pulley)
    mzP		=	0.0805;		% [kg]	%right mass (pulley)

    mc		=	m1+2*m2+mzL+mzP;% [kg]	%toal cart mass

    mps		=	0.0360;    	% [kg]	
    mpw		=	0.0240; 	% [kg]	
    mp		=	2*(mps+mpw);	% [kg]	% total pendulum mass

    lp		=	0.4810;		% [m]
    rp		=	0.00305;	% [m]
    lpw		=	0.0500;		% [m]
    rpw		=	0.0060;		% [m]

    lpwo	=	0.3540;		% [m]
    lpo		=	0.1075;		% [m]

% ***************************************************************************************************************************
% Identified
    M		=	12.86;		% [N]
    T		=	1.1514972;	% [s]
    fpc		=	0.066319;	% [1/s]
    FSpwm	=	0.093125;	% [PWM duty]
    FS		=	FSpwm*M;	% [N]

    FC		=	0.5;		% [N]

    DZu		=	FSpwm;		% [PWM duty]
    DZcv	=	0.1;		% [m/s]
    DZpv	=	1.5;		% [rad/s]

% ***************************************************************************************************************************
% Calculated
    
    Jp  = (1/12)*mpw*(lpw^2 + 4*rpw^2) + mpw*lpwo^2 + (1/12)*mps*(lp^2 + 4*rp^2) + mps*lpo^2;
    fp  = Jp * fpc;
    l   = (lpo*mps + lpwo*mpw)/(mc+mps+mpw);
    J   = Jp - l*l*(mc+mp);

% ***************************************************************************************************************************
% Screen report

disp('Pendulum 1 parameters:');
disp(' ');
s = sprintf('Cart mass [kg]:                   \t%10.8f',mc); disp(s);
s = sprintf('Pendulum mass [kg]:               \t%10.8f',mp); disp(s);
s = sprintf('Pendulum friction [kg*m2/s]:      \t%10.8f',fp); disp(s);
s = sprintf('Static friction [N]:              \t%10.8f',FS); disp(s);
s = sprintf('Coulomb friction [N]:             \t%10.8f',FC); disp(s);
s = sprintf('Distance l [m]:                   \t%10.8f',l); disp(s);
s = sprintf('Moment of inertia J [kg*m2]:      \t%10.8f',J); disp(s);
s = sprintf('Gravity acceleration g [kg*m/s2]: \t%10.8f',g); disp(s);
s = sprintf('Control magnitude M [N]:          \t%10.8f',M); disp(s);
s = sprintf('Control dead zone DZu:            \t%10.8f',FSpwm); disp(s);
s = sprintf('Cart dead zone DZcv [m/s]:        \t%10.8f',DZcv); disp(s);
s = sprintf('Pendulum dead zone DZpv [rad/s]:  \t%10.8f',DZpv); disp(s);


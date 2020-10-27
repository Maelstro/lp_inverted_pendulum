function display( p1 )

% ------------------------------------------------------------------------
% Display properties of the pendulum1 object
%
%   Copyright (c) 2000 by InTeCo, Inc.  (2K/AP)
% ------------------------------------------------------------------------

p1.Encoder           = get( p1, 'Encoder' );
p1.PWM               = get( p1, 'PWM' );
p1.PWMPrescaler      = get( p1, 'PWMPrescaler' );
p1.RailLimit         = get( p1, 'RailLimit' );
p1.RailLimitFlag     = get( p1, 'RailLimitFlag' );

p1.Therm             = get( p1, 'Therm' );
p1.ThermFlag         = get( p1, 'ThermFlag' );

name = inputname(1);
assignin( 'caller', name, p1 );

disp( [ 'Type:            '   p1.Type ] )
disp( [ 'BaseAddress:     '   num2str( p1.BaseAddress ) ' / ' ...
                              dec2hex( p1.BaseAddress ) 'Hex'] )
disp( [ 'Bitstream ver.:  x'  dec2hex( p1.BitstreamVersion ) ] )
aux = p1.Encoder;
disp( [ 'Encoder:         [ ' num2str( aux ) ' ][bit]' ] )


% 2 Enkodery
%
for i=1:5
  if aux(i) > 60000.0 
     aux(i) = aux(i) - 65536.0;
  end
end

disp( [ '                 [ ' num2str( aux(1)*p1.ScaleCoeff(1) ) '[m] ' ... 
                              num2str( aux(2)*p1.ScaleCoeff(2) ) '[m] ' ...
                              num2str( aux(3)*p1.ScaleCoeff(3) ) '[m] ' ...
                              num2str( aux(4)*p1.ScaleCoeff(4) ) '[rad] ' ...
                              num2str( aux(5)*p1.ScaleCoeff(5) ) '[rad]' ' ]' ] )

disp( [ 'PWM:             [ ' num2str( p1.PWM ) ' ]' ] )
disp( [ 'PWMPrescaler:    '   num2str( p1.PWMPrescaler ) ] )
disp( [ 'RailLimit:       [ ' num2str( p1.RailLimit ) ' ]*64[bit] <--> [' num2str( 64*p1.RailLimit ) ' ][bit]' ])
disp( [ '                 [ ' num2str( 64*p1.RailLimit.*p1.ScaleCoeff(1:3) ) ' ][m]' ])
disp( [ 'RailLimitFlag:   [ ' num2str( p1.RailLimitFlag ) ' ]' ] )

disp( [ 'Therm:           [ ' num2str( p1.Therm ) ' ]' ] )
disp( [ 'ThermFlag:       [ ' num2str( p1.ThermFlag ) ' ]' ] )
disp( [ 'Time:            '   num2str( get( p1, 'Time' )/1000 ) ' [sec]' ] )

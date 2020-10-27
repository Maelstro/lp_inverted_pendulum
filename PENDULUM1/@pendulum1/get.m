function Value = get( p1, Property )

% ------------------------------------------------------------------------
% Get properties of the pendulum1 class
%   Reads data from the RTDAC4/PCI board

%   Copyright (c) 2002 by InTeCo, Inc.  (2K/AP)
% ------------------------------------------------------------------------

Property = lower( Property );

switch Property
   case 'baseaddress'
      Value = p1.BaseAddress;
   
   case 'bitstreamversion'
      Value = inport( p1.BaseAddress+4*63 );
   
   case 'encoder'      
      p1.Encoder(1) = inport( p1.BaseAddress+4*0 );
      p1.Encoder(2) = inport( p1.BaseAddress+4*1 );
      p1.Encoder(3) = inport( p1.BaseAddress+4*2 );
      p1.Encoder(4) = inport( p1.BaseAddress+4*3 );
      p1.Encoder(5) = inport( p1.BaseAddress+4*4 );
      Value = p1.Encoder;
      
   case 'position'      
      Value = get( p1, 'encoder' );  
      for i=1:5
        Value(i) = int32(Value(i));
        Value(i) = bitand(Value(i), hex2dec('FFFF'));
        Value(i) = double(Value(i));
        if Value(i) > 60000.0 
           Value(i) = Value(i) - 65536.0;
        end
      end
      Value = Value.*p1.ScaleCoeff;

   case 'pwm'
      Value(1) = inport( p1.BaseAddress+4*33 ) / 1023;
      aux = inportb( p1.BaseAddress+4*36 );
      if bitand( uint32(aux), 1 ) ~=0
         Value(1) = -Value(1);
      end
      Value(2) = inport( p1.BaseAddress+4*34 ) / 1023;
      aux = inportb( p1.BaseAddress+4*36 );
      if bitand( uint32(aux), 2 ) ~=0
         Value(2) = -Value(2);
      end
      Value(3) = inport( p1.BaseAddress+4*35 ) / 1023;
      aux = inportb( p1.BaseAddress+4*36 );
      if bitand( uint32(aux), 4 ) ~=0
         Value(3) = -Value(3);
      end
      
   case 'pwmprescaler'
      Value = inportb( p1.BaseAddress+4*24 );
      p1.PWMPrescaler = Value;
      
   case 'raillimit'
      Value(1) = inport( p1.BaseAddress+4*17 );
      Value(2) = inport( p1.BaseAddress+4*18 );
      Value(3) = inport( p1.BaseAddress+4*19 );
      
   case 'raillimitflag'
      aux = inportb( p1.BaseAddress+4*20 ); 
      Value(1) = ( bitand(uint32(aux),1) ~= 0 );
      Value(2) = ( bitand(uint32(aux),2) ~= 0 );
      Value(3) = ( bitand(uint32(aux),4) ~= 0 );
      
   case 'therm'
      aux = inportb( p1.BaseAddress+4*38 ); 
      Value(1) = ( bitand(uint32(aux),1) ~= 0 );
      Value(2) = ( bitand(uint32(aux),2) ~= 0 );
      Value(3) = ( bitand(uint32(aux),4) ~= 0 );
      
   case 'thermflag'
      aux = inportb( p1.BaseAddress+4*39 ); 
      Value(1) = ( bitand(uint32(aux),1) ~= 0 );
      Value(2) = ( bitand(uint32(aux),2) ~= 0 );
      Value(3) = ( bitand(uint32(aux),4) ~= 0 );
      p1.ThermFlag = Value;
      
   case 'scalecoeff'
      Value = p1.ScaleCoeff;
      
   case 'time'
      Value = GetTime - p1.Time;
      
   otherwise
      % This should not happen
      error('Unexpected property name.')
      
   end % switch
   
% Finally, assign p1 in caller's workspace
name = inputname(1);
assignin( 'caller', name, p1 )
   
return;


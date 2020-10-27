function Out = set( p1 , varargin )

% ------------------------------------------------------------------------
% Set properties of the Pendulum 1 class
%   Writes data from the p1 board
%
%   Copyright (c) 2002 by InTeCo, Inc.  (2K/AP)
% ------------------------------------------------------------------------

ni = nargin;


% Now left with SET(p1,'Prop1',Value1)
name = inputname(1);
for i=1:2:ni-1,
   Property = lower( varargin{i} );
   if ni > i+1
      Value = varargin{i+1};
   end;

   switch Property
     case 'baseaddress'
        p1.BaseAddress = Value(1);
        
     case 'pwm'
        p1.PWM(1) = SetPWM( p1, 0, Value(1) );
        p1.PWM(2) = SetPWM( p1, 1, Value(2) );
        p1.PWM(3) = SetPWM( p1, 2, Value(3) );
        
     case 'pwmprescaler'
        Value = max( min( Value, 63 ), 0 );
        outportb( p1.BaseAddress+4*24, Value );
        Value = inportb( p1.BaseAddress+4*24 );
        p1.PWMPrescaler = Value;
        
     case 'raillimit'
        if( Value(1) >= 0 ) & ( Value(1) < 1024 )
          outport(  p1.BaseAddress+4*17, Value(1) );
        end;
        Value(1) = inport( p1.BaseAddress+2 );
        if( Value(2) >= 0 ) & ( Value(2) < 1024 )
          outport(  p1.BaseAddress+4*18, Value(2) );
        end;
        Value(2) = inport( p1.BaseAddress+2 );
        if( Value(3) >= 0 ) & ( Value(3) < 1024 )
          outport(  p1.BaseAddress+4*19, Value(3) );
        end
        Value(3) = inport( p1.BaseAddress+2 );
        p1.RailLimit = Value;
      
     case 'raillimitflag'
        aux = inportb( p1.BaseAddress+4*20 ); 
        if( Value(1) == 0.0 )  aux = bitand(uint32(aux),hex2dec('FE')); end;
        if( Value(1) == 1.0 )  aux = bitor( uint32(aux),hex2dec('01')); end;
        if( Value(2) == 0.0 )  aux = bitand(uint32(aux),hex2dec('FD')); end;
        if( Value(2) == 1.0 )  aux = bitor( uint32(aux),hex2dec('02')); end;
        if( Value(3) == 0.0 )  aux = bitand(uint32(aux),hex2dec('FB')); end;
        if( Value(3) == 1.0 )  aux = bitor( uint32(aux),hex2dec('04')); end;
        outportb( p1.BaseAddress+4*20, double(aux) );
        aux = inportb( p1.BaseAddress+4*20 ); 
        Value(1) = ( bitand(uint32(aux),1) ~= 0 );
        Value(2) = ( bitand(uint32(aux),2) ~= 0 );
        Value(3) = ( bitand(uint32(aux),4) ~= 0 );
        p1.RailLimitFlag = Value;
        
     case 'resetencoder'
        val = 0;
        if Value(1) > 0,  val = val +  1; end
        if Value(2) > 0,  val = val +  2; end
        if Value(3) > 0,  val = val +  4; end
        if Value(4) > 0,  val = val +  8; end
        if Value(5) > 0,  val = val + 16; end
        outportb( p1.BaseAddress+4*5, val);
        outportb( p1.BaseAddress+4*5, 0);
   
   case 'thermflag'
        aux = inportb( p1.BaseAddress+4*39 ); 
        if( Value(1) == 0.0 )  aux = bitand(uint32(aux),hex2dec('FE')); end;
        if( Value(1) == 1.0 )  aux = bitor( uint32(aux),hex2dec('01')); end;
        if( Value(2) == 0.0 )  aux = bitand(uint32(aux),hex2dec('FD')); end;
        if( Value(2) == 1.0 )  aux = bitor( uint32(aux),hex2dec('02')); end;
        if( Value(3) == 0.0 )  aux = bitand(uint32(aux),hex2dec('FB')); end;
        if( Value(3) == 1.0 )  aux = bitor( uint32(aux),hex2dec('04')); end;
        outportb( p1.BaseAddress+4*39, double(aux) );
        aux = inportb( p1.BaseAddress+4*39 ); 
        Value(1) = ( bitand(uint32(aux),1) ~= 0 );
        Value(2) = ( bitand(uint32(aux),2) ~= 0 );
        Value(3) = ( bitand(uint32(aux),4) ~= 0 );
        p1.ThermFlag = Value;
        
   case 'stop'
      set( p1, 'PWM', [ 0 0 0 ] );
      
   otherwise
      % This should not happen
      error('Unexpected property name.')

   end % switch
end % for


% Finally, assign p1 in caller's workspace
assignin( 'caller', name, p1 )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set PWM value
%
function ret = SetPWM( p1, ChanNo, PWM )

if ChanNo == 0
   PWMAdr  = 33;
   MaskOr  = 1;
   MaskAnd = 6;   
elseif ChanNo == 1
   PWMAdr  = 34;
   MaskOr  = 2;
   MaskAnd = 5;      
elseif ChanNo == 2
   PWMAdr  = 35;
   MaskOr  = 4;
   MaskAnd = 3;      
else
   error( 'Uncorrect PWM channel number.' )
end

DirAdr   = 36;

if( abs(PWM) <= 1 )
  % Set/reset brake
  if PWM == 0
    SetBrake( p1, ChanNo );
  else
    ResetBrake( p1, ChanNo );
  end;

  % Set direction
  aux = inportb( p1.BaseAddress+4*DirAdr );
  if PWM > 0
    outportb( p1.BaseAddress+4*DirAdr, double(bitand( uint32(aux), MaskAnd )) );
  else
    outportb( p1.BaseAddress+4*DirAdr, double(bitor( uint32(aux), MaskOr )) );   
    PWM = -PWM;
  end

  % PWM0 duty cycle
  outport( p1.BaseAddress+4*PWMAdr, round(1023*PWM) );
end

ret = inport( p1.BaseAddress+4*PWMAdr ) / 1023;
aux = inportb( p1.BaseAddress+4*DirAdr );
if bitand( uint32(aux), MaskAnd ) ~=0
   ret = -ret;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Clear brake signal 
%
function ret = ResetBrake( p1, ChanNo )

if ChanNo == 0
   Mask = 6;
elseif ChanNo == 1
   Mask = 5;
elseif ChanNo == 2
   Mask = 3;
else
   error( 'Uncorrect PWM channel number.' )
end

BrakeAdr = 37;
aux = inportb( p1.BaseAddress+4*BrakeAdr );
outportb( p1.BaseAddress+4*BrakeAdr, double(bitand( uint32(aux), Mask )) );
ret = inportb( p1.BaseAddress+4*BrakeAdr );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Activate brake signal 
%
function ret = SetBrake( p1, ChanNo )

if ChanNo == 0
   Mask = 1;
elseif ChanNo == 1
   Mask = 2;
elseif ChanNo == 2
   Mask = 4;
else
   error( 'Uncorrect PWM channel number.' )
end

BrakeAdr = 37;
aux = inportb( p1.BaseAddress+4*BrakeAdr );
outportb( p1.BaseAddress+4*BrakeAdr, double(bitor( uint32(aux), Mask )) );
ret = inportb( p1.BaseAddress+4*BrakeAdr );

function p1 = pendulum1

% ------------------------------------------------------------------------
% Pendulum 1 constructor function
%
% Properties of the Pendulum 1 class:
%   (sg) 'BaseAddress'      - base address of the RTDAC4/PCI board
%   ( g) 'BitstreamVersion' - bitstream version of the XILINX chip logic
%   ( g) 'Encoder'          - read encoders
%   (sg) 'PWM'              - PWM duty cycle
%   (sg) 'PWMPrescaler'     - PWM frequency prescaler
%   (s ) 'ResetEncoder'     - reset encoder(s)
%   (sg) 'RailLimit'        - rail range limits
%   (sg) 'RailLimitFlag'    - rail range limit flags
%   ( g) 'Therm'            - read thermal state
%   (sg) 'ThermFlag'        - state of the thermal flags
%   ( g) 'ScaleCoeff'       - encoder pulse/physical units coefficients
%   ( g) 'Time'             - time in ms since object was created
%
%
%   ( g) - available for the get function
%   ( s) - available for the set function
%   (sg) - available for the get and set functions

%   Copyright (c) 2002 by InTeCo, Inc.  (2K/AP)
%   Last updated: 2002-08-19
% ------------------------------------------------------------------------



p1.Type = 'InTeCo pendulum1 Object';
p1.BaseAddress      = NaN;
p1.BitstreamVersion = NaN;
p1.Encoder          = NaN;
p1.PWM              = NaN;
p1.PWMPrescaler     = NaN;
p1.RailLimit        = NaN;
p1.RailLimitFlag    = NaN;
p1.RailLimitSwitch  = NaN;
p1.ResetSwitchFlag  = NaN;
p1.Therm            = NaN;
p1.ThermFlag        = NaN;
p1.ScaleCoeff       = NaN;


p1.Time             = GetTime;

p1=class(p1,'pendulum1');

p1.BaseAddress      = BaseAddressDetect;
p1.BitstreamVersion = get( p1, 'BitstreamVersion' );
p1.Encoder          = get( p1, 'Encoder' );
p1.PWM              = get( p1, 'PWM' );
p1.PWMPrescaler     = get( p1, 'PWMPrescaler' );
p1.RailLimit        = get( p1, 'RailLimit' );
p1.RailLimitFlag    = get( p1, 'RailLimitFlag' );

p1.Therm            = get( p1, 'Therm' );
p1.ThermFlag        = get( p1, 'ThermFlag' );
% Encoder type dependent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For 1000 PPR encoders, small driving wheels
% p1.ScaleCoeff       = [ 3.9739e-005 3.9739e-005 2*pi*0.0278/2/4096 0.001571 0.001571 ];
% For 500 PPR encoders, small driving wheels
% p1.ScaleCoeff       = 2*[ 4.01e-005 4.01e-005 2.09e-005 0.001534 0.001534 ];

% For 1000 PPR encoders, big driving wheels
% Encoder type HEDM-5505 BO6  0048A
% p1.ScaleCoeff       = [ 5.9484e-005 5.9484e-005 2*pi*0.0292/2/4096 0.001571 0.001571 ];

% For 1024 PPR encoders, big driving wheels
% Encoder type HEDM-5505 JO6  0133A
% {AP} Modyfikacja skalowania dla Pozycji wózka
p1.ScaleCoeff       = [ 5.8090e-005 5.8090e-005 2*pi*0.0285/2/4096 0.001534 5.7053e-5];

p1.RailLimit   = get( p1, 'RailLimit' );

if p1.BaseAddress < 0 
  p1.BaseAddress = BaseAddressDetect;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Base address autodetection function
%
function BaseAddr = BaseAddressDetect

BaseAddr = RTDAC4PCIBaseAddress(-1,-1);
if exist('P1_SelectBoard.mat') == 2
    load P1_SelectBoard;
    BaseAddr = BaseAddr(SelectBoard);
end
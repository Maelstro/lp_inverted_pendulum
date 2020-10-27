/*
 * P1_Encoder.c
 *
 * S-Function device driver for the Pendulum 1 model. 
 * RTDAC4/PCI board
 *
 * Copyright (c) 2002 by InTeCo/2K/AP
 * All Rights Reserved
 *
 */

#define S_FUNCTION_NAME P1_Encoder
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include <conio.h>

static int WriteByte( int port, int value ) { 
    return( _outpd( (unsigned short)port, value ) );
}
static unsigned short WriteWord( int port, unsigned int value ) { 
    return( _outpd( (unsigned short)port, (unsigned short)value ) );
}
static int ReadByte( int port ) { 
    return( _inpd( (unsigned short)port ) );
}
static unsigned int ReadWord( int port ) { 
    return( _inpd( (unsigned short)port ) );
}
static unsigned int ReadDWord( int port ) { 
    return( _inpd( (unsigned short)port ) );
}

/* Input Arguments */
#define BASE_ADDRESS_ARG        (ssGetSFcnParam(S,0))
#define SAMPLE_TIME_ARG         (ssGetSFcnParam(S,1))
#define NUMBER_OF_ARGS          (2)
#define NSAMPLE_TIMES           (1)

#define BASE_ADDRESS            ((real_T) mxGetPr(BASE_ADDRESS_ARG)[0])
#define SAMPLE_TIME             ((real_T) mxGetPr(SAMPLE_TIME_ARG)[0])


static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, NUMBER_OF_ARGS);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }

    if (!ssSetNumInputPorts(S, 0)) return;

    if (!ssSetNumOutputPorts(S,1)) return;
    ssSetOutputPortWidth(S, 0, 5);

    ssSetNumSampleTimes(S, 1);

    /* Take care when specifying exception free code */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}
 
 
/* Function to initialize sample times */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0);
}
 


static void mdlOutputs(SimStruct *S, int_T tid)
{
  real_T *y               = ssGetOutputPortRealSignal(S,0);

#ifndef MATLAB_MEX_FILE
  int BaseAddress = (int)BASE_ADDRESS;
  int i;

  if ( BaseAddress == 0 )  
  {
    y[0] = y[1] = y[2] = y[3] = y[4] = 0.0;
    return;
  }

  y[0] = ReadWord( BaseAddress+4*0 ); 
  y[1] = ReadWord( BaseAddress+4*1 ); 
  y[2] = ReadWord( BaseAddress+4*2 ); 
  y[3] = ReadWord( BaseAddress+4*3 ); 
  y[4] = ReadWord( BaseAddress+4*4 ); 

  for( i=0; i<5; i++ )
    if( y[i] > 60000.0 )
      y[i] = y[i] - 65536.0;
#else
    y[0] = y[1] = y[2] = y[3] = y[4] = 0.0;
#endif
}

 
/* Function to perform cleanup at execution termination */
static void mdlTerminate(SimStruct *S)
{
}

#ifdef MATLAB_MEX_FILE  /* Is this file being compiled as a MEX-file? */
#include "simulink.c"        /* MEX-File interface mechanism */
#else
#include "cg_sfun.h"    /* Code generation registration function */
#endif

/*
 * P1_BaseAddress.c
 *
 * S-Function device driver for the Pendulum 1 model. 
 * RTDAC4/PCI board
 *
 * Copyright (c) 2002 by InTeCo/2K/AP
 * All Rights Reserved
 *
 */

#define S_FUNCTION_NAME P1_BaseAddress
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
#define SAMPLE_TIME_ARG         (ssGetSFcnParam(S,0))
#define NUMBER_OF_ARGS          (1)
#define NSAMPLE_TIMES           (1)

#define SAMPLE_TIME             ((real_T) mxGetPr(SAMPLE_TIME_ARG)[0])


static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, NUMBER_OF_ARGS);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }

    /* Set-up size information */
    if (!ssSetNumInputPorts(S, 0)) return;

    if (!ssSetNumOutputPorts(S,1)) return;
    ssSetOutputPortWidth(S, 0, 1);

    ssSetNumSampleTimes(S, 1);

    /* Take care when specifying exception free code */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}
 
 
/* Function to initialize sample times */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}
 
/* Function to compute outputs */
static void mdlOutputs( SimStruct *S, int_T tid )
{
  real_T *y      = ssGetOutputPortRealSignal(S,0);
#ifndef MATLAB_MEX_FILE
  int BaseAddr;
  int i;
  int BA[ ]      = { 0x200, 0x210, 0x220, 0x230, 0x240, 0x250, 0x260, 0x270 };
  int Pattern[ ] = { 0x00, 0xFF, 0x55, 0xAA };
  int pat[4];
  int sum;

  BaseAddr = -1;
  for( i=0; i<8; i++ )
  {
    WriteByte( BA[i]+0, 0xF0 );
    WriteByte( BA[i]+2, 0 );  pat[0] = ReadByte( BA[i]+2 );
    WriteByte( BA[i]+2, 1 );  pat[1] = ReadByte( BA[i]+2 );
    WriteByte( BA[i]+2, 2 );  pat[2] = ReadByte( BA[i]+2 );   
    WriteByte( BA[i]+2, 3 );  pat[3] = ReadByte( BA[i]+2 );   
    sum = (pat[0] == Pattern[0]) + (pat[1] == Pattern[1]) +
          (pat[2] == Pattern[2]) + (pat[3] == Pattern[3]);
    if ( sum == 4 )
    {
       BaseAddr = BA[i];
       break;
    }
  }
  y[0] = BaseAddr;
#else
  y[0] = -1;
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

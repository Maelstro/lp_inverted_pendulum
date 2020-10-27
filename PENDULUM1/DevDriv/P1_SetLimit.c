/*
 * P1_SetLimit.c
 *
 * S-Function device driver for the Pendulum 1 model. 
 * RTDAC4/PCI board
 *
 * Copyright (c) 2002 by InTeCo/2K/AP
 * All Rights Reserved
 *
 */

#include <conio.h>

#define S_FUNCTION_NAME P1_SetLimit
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

    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, 3);
    ssSetInputPortDirectFeedThrough(S, 0, 0);

    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 3);

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
 

/* Function to compute outputs */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
  real_T *y               = ssGetOutputPortRealSignal(S,0);

#ifndef MATLAB_MEX_FILE
  int BaseAddress = (int)BASE_ADDRESS;

  if ( BaseAddress == 0 )  
  {
    y[0] = y[1] = y[2] = 0.0;
    return;
  }

  if( (*uPtrs[0]) > 0 )
  {
    WriteWord(  BaseAddress+4*0x11, (int) (*uPtrs[0]) );
  }
  y[0] = ReadWord(  BaseAddress+4*0x11 );
  if( (*uPtrs[1]) > 0 )
  {
    WriteWord(  BaseAddress+4*0x12, (int) (*uPtrs[1]) );
  }
  y[1] = ReadWord(  BaseAddress+4*0x12 );
  if( (*uPtrs[2]) > 0 )
  {
    WriteWord(  BaseAddress+4*0x13, (int) (*uPtrs[2]) );
  }
  y[2] = ReadWord(  BaseAddress+4*0x13 );
#else
  y[0] = (*uPtrs[0]);
  y[1] = (*uPtrs[1]);
  y[2] = (*uPtrs[2]);
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

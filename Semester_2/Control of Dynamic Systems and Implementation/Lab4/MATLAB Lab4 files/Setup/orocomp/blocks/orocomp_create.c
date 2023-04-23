//==========================================================================
// (c)2013 Institut Superieur de l'Aeronautique et de l'Espace
//    Laurent Alloza (laurent.alloza(a)isae.fr)
//    Version 1.0 (R2012b)
//    Date : 08/2013
//==========================================================================
#define S_FUNCTION_NAME  orocomp_create
#define S_FUNCTION_LEVEL 2
#include "simstruc.h"

/*  Bloc Parameters ==========================================================
 *  NAMESPACE  - namespace string for the component
 *  USEINLIB   - true to use component in a shared library
 */
enum { NAMESPACE, USEINLIB };

#define N_PAR     2
#define PARAM(n)  (ssGetSFcnParam(S,n))

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Initialize the sizes array
 */
static void mdlInitializeSizes(SimStruct *S) {
  //if( ssGetSolverMode(S)==SOLVER_MODE_MULTITASKING ) ssSetErrorStatus(S,"Multitasking solver mode not supported by OROCOS Component.");
  /* Set and Check parameter count  */
  ssSetNumSFcnParams(S, N_PAR);
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) return;
  ssSetSFcnParamTunable(S, NAMESPACE, SS_PRM_NOT_TUNABLE);
  ssSetSFcnParamTunable(S, USEINLIB,  SS_PRM_NOT_TUNABLE);

  /* Internal States */
  ssSetNumContStates(S, 0);
  ssSetNumDiscStates(S, 0);

  /* Work Vectors */
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumPWork(S, 0);

  /*  Input ports */
  if ( !ssSetNumInputPorts(  S, 0 ) ) return;

  /* Output ports */
  if ( !ssSetNumOutputPorts( S, 0 ) ) return;

  /* sample times */
  ssSetNumSampleTimes( S, 1 );

  /* options */
  ssSetOptions(S, SS_OPTION_WORKS_WITH_CODE_REUSE | SS_OPTION_EXCEPTION_FREE_CODE);
}
/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Initialize the sample times array.
 */
static void mdlInitializeSampleTimes(SimStruct *S) {
 	ssSetSampleTime(S, 0,INHERITED_SAMPLE_TIME);
 	ssSetOffsetTime(S, 0, 0);
}
/* Function: mdlOutputs =======================================================
 * Abstract:
 *   Compute the outputs of the S-function.
 */
static void mdlOutputs(SimStruct *S, int_T tid) {
}
/* Function: mdlTerminate =====================================================
 * Abstract:
 *    Called when the simulation is terminated.
 */
static void mdlTerminate(SimStruct *S) {
}
/* Function: mdlRTW ===========================================================
 * Abstract:
 *    This function is called when the Real-Time Workshop is generating
 *    the model.rtw file.
 */
#define MDL_RTW
static void mdlRTW(SimStruct *S) {
  // Write out parameters for this block.
  // To use in .tlc file :
  // %assign name = SFcnParamSettings.NAME
  boolean_T useinlib  = * mxGetPr(PARAM(USEINLIB));

  ssWriteRTWParamSettings(S, 2
    ,SSWRITE_VALUE_QSTR,      "NAMESPACE", mxArrayToString(PARAM(NAMESPACE))
    ,SSWRITE_VALUE_DTYPE_NUM, "USEINLIB",  &useinlib, DTINFO(SS_BOOLEAN, COMPLEX_NO)
    );
}
/*==============================================*
 * Enforce use of inlined S-function.           *
 * Must have a TLC file.                        *
 *==============================================*/
#ifdef    MATLAB_MEX_FILE  /* Is this file being compiled as a MEX-file?    */
# include "simulink.c"     /* MEX-file interface mechanism                  */
#else                      /* Prevent usage by RTW if TLC file is not found */
# error "Attempted use non-inlined S-function."
#endif


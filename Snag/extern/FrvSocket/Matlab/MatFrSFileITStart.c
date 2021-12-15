#include "mex.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *in_fd;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 double GPSstart; 

 in_fd = prhs[0];
 
/* Check for proper number of arguments. */
  if (nrhs != 1) {
    mexErrMsgTxt("One input required.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments");
  }
 fd = (SOCKET) mxGetScalar(in_fd);

 GPSstart= FrSFileITStart(fd);
 plhs[0]=mxCreateDoubleScalar(GPSstart);
/*  FrvS_close_Connection(fd); */
return;
}





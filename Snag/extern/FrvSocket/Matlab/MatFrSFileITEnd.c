#include "mex.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *in_fd;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 double GPSend; 

 in_fd = prhs[0];
 
/* Check for proper number of arguments. */
  if (nrhs != 1) {
    mexErrMsgTxt("One input required.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments");
  }
 fd = (SOCKET) mxGetScalar(in_fd);

 GPSend= FrSFileITEnd(fd);
 plhs[0]=mxCreateDoubleScalar(GPSend);
/*  FrvS_close_Connection(fd); */
return;
}





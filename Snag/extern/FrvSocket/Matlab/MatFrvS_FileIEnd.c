#include "mex.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *in_fd;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 int ans;
 

 in_fd = prhs[0];
 
/* Check for proper number of arguments. */
  if (nrhs != 1) {
    mexErrMsgTxt("One inputs required.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments");
  }
 fd = (SOCKET) mxGetScalar(in_fd);
 ans = FrvS_FileIEnd(fd);
 plhs[0]=mxCreateDoubleScalar((double) ans);
 
return;
}





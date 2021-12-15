#include "mex.h"
#include "matrix.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *in_fd;
 int i;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 MatFrVect *ans;
 

 in_fd =  prhs[0];

 
/* Check for proper number of arguments. */
  if (nrhs != 1) {
    mexErrMsgTxt("One input required: socket");
  } else if (nlhs > 2) {
    mexErrMsgTxt("Too many output arguments");
  }
 

 fd = (SOCKET) mxGetScalar(in_fd);
 
 
 if ((ans=FrvSFileIGetAdcNames(fd)) == NULL ) 
    { 
      printf("Error reading remote TOC\n");
      return;
     }
 /* printf("ndata %d, dx %f, type %d\n",ans->nData, ans->dx, ans->type); */
 plhs[0]=mxCreateDoubleScalar((double) ans->nData);  /* number of data */
 plhs[1]=mxCreateCharMatrixFromStrings(ans->nData, (const char **) ans->dataQ);
 
 
 MatFree(ans);
 return;
}





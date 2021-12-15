#include "mex.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *inFileName, *in_fd;
 int inLength;
 char *file_name;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 int ans;
 

 in_fd =  prhs[0];
 inFileName = prhs[1];
 
/* Check for proper number of arguments. */
  if (nrhs != 2) {
    mexErrMsgTxt("Two inputs required.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments");
  }
 
/* evaluate the string lenght */
 inLength = mxGetN(inFileName)+1;
 file_name = mxCalloc(inLength,sizeof(char));
 mxGetString(inFileName,file_name,inLength);

 fd = (SOCKET) mxGetScalar(in_fd);
 
 if ((ans=FrvS_FrIfile(fd, file_name)) <0 ) printf("Error opening remote file\n");
 
 
 plhs[0]=mxCreateDoubleScalar((double) ans);
/*  FrvS_close_Connection(fd); */
return;
}





#include "mex.h"
#include "matrix.h"
#include "../FrvSclient.c"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *in_fd;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 struct FrvS_Frame_info *ans;
 

 in_fd =  prhs[0];
 
/* Check for proper number of arguments. */
  if (nrhs != 1) {
    mexErrMsgTxt("One input required: socket_fd");
  } else if (nlhs > 8) {
    mexErrMsgTxt("Too many output arguments");
  }
 
 fd = (SOCKET) mxGetScalar(in_fd);
 
 
 if ((ans=FrvSFrameInfoDownload(fd)) == NULL ) printf("Error reading remote frame info\n");
 
 
 plhs[0]=mxCreateString(ans->name);  /* name of the experiment */
 plhs[1]=mxCreateDoubleScalar((double) ans->run);  /* Run number */
 plhs[2]=mxCreateDoubleScalar((double) ans->frame);  /* Data Quality word */
 plhs[3]=mxCreateDoubleScalar((double) ans->dataQuality);  /* Data Quality word */
 plhs[4]=mxCreateDoubleScalar((double) ans->GTimeS);  /* GPS time */
 plhs[5]=mxCreateDoubleScalar((double) ans->GTimeN);  /* nseconds modulo 1 */
 plhs[6]=mxCreateDoubleScalar((double) ans->ULeapS);  /* leap seconds between GPS and UTC */
 plhs[7]=mxCreateDoubleScalar((double) ans->dt);  /* frame duration */
 
 
/*  FrvS_close_Connection(fd); */
return;
}





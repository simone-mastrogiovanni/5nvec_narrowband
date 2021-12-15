#include "mex.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *inName, *inPort;
 int inLength;
 char *server_name;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 double *out_fd;
 long port;
 

 inName = prhs[0];
 inPort = prhs[1];
 
/* Check for proper number of arguments. */
  if (nrhs != 2) {
    mexErrMsgTxt("Two inputs required.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments");
  }
 
/* evaluate the string lenght */
 inLength = mxGetN(inName)+1;
 server_name = mxCalloc(inLength,sizeof(char));
 mxGetString(inName,server_name,inLength);

 FrvSinitLogFile("test.log");
 port = (SOCKET) mxGetScalar(inPort);

 if ((fd = FrvSconnect( server_name, port)) == INVALID_SOCKET)
#ifdef WINDOWS
		error("Client: socket not connected ");
#else
 		perror("Client: socket not connected ");  
#endif  		
 
 printf("connection open: socket %d \n",fd);
 
 plhs[0]=mxCreateDoubleScalar((double) fd);
/*  FrvS_close_Connection(fd); */
return;
}





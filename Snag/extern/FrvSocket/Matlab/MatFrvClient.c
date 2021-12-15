#include "mex.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *inName;
 int inLength;
 char *server_name;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 long port;
 char filename[]="/users/punturo/analisi/C5/C5data.ffl";
 double GPSstart;

 inName = prhs[0];
 
/* Check for proper number of arguments. */
  if (nrhs != 1) {
    mexErrMsgTxt("One input required.");
  } else if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments");
  }
 
/* evaluate the string lenght */
 inLength = mxGetN(inName)+1;
 printf("Lunghezza nome %d \n", inLength);
 server_name = mxCalloc(inLength,sizeof(char));
 mxGetString(inName,server_name,inLength);

 printf("Server name %s\n",server_name);

 FrvSinitLogFile("test.log");
 port =1490;
 printf("log file open \n");
 if ((fd = FrvSconnect( server_name, port)) == INVALID_SOCKET)
		error("Client: socket not connected ");
 
 printf("connection open \n");
 
 if (FrvS_FrIfile(fd, filename) <0 ) fprintf(stderr,"Error opening remote file\n");
 
 GPSstart= FrSFileITStart(fd);
 printf("GPS Start Time %f\n",GPSstart);
 
 FrvS_FileIEnd(fd);
 
 FrvS_close_Connection(fd);
 
 /*
	if (closesocket(fd) == SOCKET_ERROR)
		error("Client: closing socket "); */
 
return;
}





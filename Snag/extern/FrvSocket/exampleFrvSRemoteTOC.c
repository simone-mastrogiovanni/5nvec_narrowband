// FrvRemoteTOC.cpp : Defines the entry point for the console application.
//

/* #include "stdafx.h" */
#include "FrvSclient.h"



int main(int argc, char* const argv[])
{
  int i=0;
  int socket_fd;
  FrVect *vect;  
  long port;
  char* end;

  FrvSinitLogFile("Client_logFile.log");

  port = strtol(argv[2],&end,10);  
  if(*end != '\0')
    {
      fprintf(stderr,"Incorrect Port %s\n", argv[2]);
      exit(-1);
    }

  socket_fd = FrvSconnect(argv[1], port); /* connect remote FrvS server */
  if (socket_fd == -1) /* connection failed */
    exit(-1);

  if(FrvS_FrIfile(socket_fd, argv[3]) < 0)
    exit(-1);   /* file not found */

  vect = FrvSFileIGetAdcNames(socket_fd);
  /* close remote file */
  fprintf(stdout,"TOC of the file %s contains %d channels\n",argv[3], vect->nData);
  fprintf(stdout,"dataQ[%d]= %s\n",0,vect->dataQ[0]);
  fprintf(stdout,"dataQ[%d]= %s\n",vect->nData-1,vect->dataQ[vect->nData-1]);

#ifdef NOFRVLIB
		MatFree(vect);
#else
        FrVectFree(vect);
#endif

  if(FrvS_FileIEnd(socket_fd) < 0)
    fprintf(stdout,"Error closing file %s\n", argv[3]);

  /* close connection */

  if(FrvS_close_Connection(socket_fd) == CODE_CLCN)
    exit(0);
  else
    exit(-1);
}


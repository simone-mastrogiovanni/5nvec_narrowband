#include "FrvSclient.h"

#define NSECONDS 50

int main (int argc, char* const argv[])
{ 

  int i=0;
  int socket_fd;

  long port;
  char* end;
 
  FrVect *vect;

  double GPSstart, GPSend;
 
  fprintf(stdout, "Download %d seconds of data\n",NSECONDS);

  if(argc != 5) 
    {
      fprintf(stderr,"Some parameter is missing\n");
      fprintf(stderr,"Usage:\n");
      fprintf(stderr,"%s server_node_name port RemoteFrFileName ChannelName\n",argv[0]);
      exit(-1);
	}
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

 
  GPSstart = FrSFileITStart(socket_fd);
  /* GPSstart=834331232; */
  fprintf(stdout,"Start GPS time = %f\n",GPSstart);
  fflush(stdout);

  GPSend = FrSFileITEnd(socket_fd);
  fprintf(stdout,"End GPS time = %f\n",GPSend);
  fflush(stdout);


  /* download vector */

  
   vect = FrvSFileIGetV(socket_fd, argv[4], GPSstart,NSECONDS);
   
      if (vect !=NULL)
       {
        fprintf(stdout,"Vector Name %s\n",vect->name);
        fprintf(stdout,"nData = %d\n",vect->nData);
	for(i=0;i<40;i++) fprintf(stdout,"Data[%d]=%e, ",i,vect->dataF[i]);
        fprintf(stdout,"\n");
        fprintf(stdout,"...\n");
        fprintf(stdout,"data[%d]=%e\n",vect->nData-1,vect->dataF[vect->nData-1]);
        fflush(stdout);
           /* insert here your analysis */
           /* end of the analysis section*/
#ifdef NOFRVLIB
		MatFree(vect);
#else
        FrVectFree(vect);
#endif
       }

  /* close remote file */

  if(FrvS_FileIEnd(socket_fd) < 0)
    fprintf(stdout,"Error closing file %s\n", argv[3]);

  /* close connection */

  if(FrvS_close_Connection(socket_fd) == CODE_CLCN)
    exit(0);
  else
    exit(-1);


}

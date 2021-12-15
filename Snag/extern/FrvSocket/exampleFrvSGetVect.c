#include "FrvSclient.h"
#define NFRAMES 10

int main (int argc, char* const argv[])
{ 

  int i=0, k=0;
  int socket_fd;

  long port;
  char* end;
  int err_ans;
 
  FrVect *vect;

  struct FrvS_Frame_info *frameInfo;

  char message[MAX_MESSAGE_SIZE];

  if(argc != 5) 
    {
      fprintf(stderr,"Some parameter is missing\n");
      fprintf(stderr,"Usage:\n");
      fprintf(stderr,"%s server_node_name port RemoteFrFileName FrVect\n",argv[0]);
      exit(-1);
    }
 
  FrvSinitLogFile("Client_logFile.log"); /* initialize local log file */

  port = strtol(argv[2],&end,10);  /* read TCP port */
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

 


  /* loop over data download */

  k=0;

  while((FrvSIncrFrame(socket_fd)) > 0 && (k<NFRAMES))
    {
      k++;
      frameInfo = FrvSFrameInfoDownload(socket_fd);
      if(frameInfo == NULL) continue; /* Frame error */
      fprintf(stdout,"GPS time %d\n",frameInfo->GTimeS);
      free(frameInfo);

      vect = FrvSGetVect(socket_fd, argv[4]);    
      if (vect !=NULL)
		{
			if(!strcmp(vect->name,"Empty"))
				fprintf(stdout,"Vector %s not found in current frame\n",argv[4]);
			else
			{
	      /* insert here your analysis */

				fprintf(stdout,"Vector Name %s\n",vect->name);
				for(i=0;i<5;i++) fprintf(stdout,"Data[%d]=%e, ",i,vect->dataF[i]);
				fprintf(stdout,"\n");

	      /* end of the analysis section*/
#ifdef NOFRVLIB
				MatFree(vect);
#else
				FrVectFree(vect);
#endif
			}
		}
      else
			fprintf(stdout,"NULL pointer returned\n");

      fflush(stdout);
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



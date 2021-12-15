#include "FrvSclient.h"

/* this version compiles both on Win32 and Unix platform, with or without FRV libraries 
    Changes made by M.Punturo  18/1/2006
	- macro NOFRVLIB to compile without FRVlibaries 
    Changes made by A. Eleuteri 1/6/2005
    - macro definitions for conditional compilation
    - modifications of comments according to ANSI C
  */
FILE *GLOBAL_DEBUG=NULL;
char OK_MESSAGE[]= "OK";

double FrSFileITStart(int socket_fd)
{
	return FrSFileITime(socket_fd, CONN_CMD_TSTART);
}

double FrSFileITEnd(int socket_fd)
{
	return FrSFileITime(socket_fd, CONN_CMD_TEND);
}

double FrSFileITime(int socket_fd, int StartEnd)
{
   char *message;
   char *position;
   int answer;
   double RequestedTime;

   message = (char *) malloc(MAX_MESSAGE_SIZE);

   answer = FrvSrequest_server(socket_fd, StartEnd, message);

   if (answer < 0)
	{
	  free(message );
	  return (double) answer;
	}
   
   position = strstr(message,"=");
   position++;
   RequestedTime=atof(position);
   free(message );
   return RequestedTime;	
}


FrVect *FrvSFileIGetAdcNames(int socket_fd)  
     /* downloader of the remote TOC */
{
	int answer;
	int i;
	ssize_t number_characters_read;
	struct my_info_Vect info;  
	FrVect *vect;
	char *tmpCh;
	

	answer = FrvSrequest_server(socket_fd, CONN_CMD_TOC, NULL);
	if (answer == (-1*CODE_FILE))
	{
		printf("TOC command failed because any file has been open = %d\n",answer);
		if (GLOBAL_DEBUG != NULL)
			fprintf(GLOBAL_DEBUG,"TOC command failed because any file has been open = %d\n",answer);
		return (NULL);
	}
	if (answer == (-1*CODE_TOC))
	{
		printf("No TOC info available = %d\n",answer);
		if (GLOBAL_DEBUG != NULL)
			fprintf(GLOBAL_DEBUG,"No TOC info available = %d\n",answer);
		return (NULL);
	}
	if (answer <0)
	{
		printf("error retrieving the TOC = %d\n",answer);
		if (GLOBAL_DEBUG != NULL)
			fprintf(GLOBAL_DEBUG,"error retrieving the TOC = %d\n",answer);
		return (NULL);
	}

	fflush(stdout);

/* the answer was positive: it is ok */

#ifdef WINDOWS    
	send(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1,0);
	number_characters_read = recv (socket_fd,&info, MAX_MESSAGE_SIZE,0); /* read infos */
#else
	write(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1);
	number_characters_read = read (socket_fd,&info, MAX_MESSAGE_SIZE); /* read infos */  
#endif  
	
	if (number_characters_read == 0)	
		{	
			printf("No characters read B\n");
			fflush(stderr);
			if(GLOBAL_DEBUG != NULL) 
				{
					fprintf(GLOBAL_DEBUG,"No characters read B\n");
					fflush(GLOBAL_DEBUG);
				}
			return (NULL);
		}
 
  
	info.compress = ntohs(info.compress);
	info.VectType = ntohs(info.VectType);
	info.nData    = ntohl(info.nData);
	if(GLOBAL_DEBUG != NULL) 
		{
          fprintf(GLOBAL_DEBUG,"remote TOC vector name  = %s \n",info.VectName);
	      fprintf(GLOBAL_DEBUG,"remote TOC vector comp  = %d \n",info.compress);
          fprintf(GLOBAL_DEBUG,"remote TOC vector type  = %d \n",info.VectType);
          fprintf(GLOBAL_DEBUG,"remote TOC vector ndata = %d \n",info.nData);
          fprintf(GLOBAL_DEBUG,"remote TOC vector step  = %f \n",info.step);
          fflush(GLOBAL_DEBUG);
         }

#ifdef NOFRVLIB
  vect = MatFrVectNew1D(info.VectName,info.VectType,info.nData,info.step,"time (s)");
#else
  vect = FrVectNew1D(info.VectName,info.VectType,info.nData,info.step,"time (s)",NULL);
#endif
  if(vect == NULL) return(NULL);
  
  vect->compress = info.compress;

#ifdef WINDOWS    
	send(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1,0); /* sincronize */
#else
	write(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1); 
#endif 
  tmpCh = malloc(MAX_MESSAGE_SIZE);  /* temporary string */
  for (i=0;i<info.nData;i++)
  {
#ifdef WINDOWS  
	number_characters_read = recv (socket_fd,tmpCh,MAX_MESSAGE_SIZE,0); /* read presence */
#else
	number_characters_read = read (socket_fd,tmpCh,MAX_MESSAGE_SIZE-1); /* read presence */
#endif
	tmpCh[number_characters_read]= '\0'; 
	if (number_characters_read == 0)
		{	
			printf("No characters read A\n");
			if(GLOBAL_DEBUG != NULL) 
				{
					fprintf(GLOBAL_DEBUG,"No characters read A\n");
					fflush(GLOBAL_DEBUG);
				}
			fflush(stderr);
			/* return (NULL); */
		}
	vect->dataQ[i]= (char *) malloc(strlen(tmpCh)+1);
	strcpy(vect->dataQ[i],tmpCh);
/*	printf("ricevuto[%d]= %s\n",i,vect->dataQ[i]); */
#ifdef WINDOWS    
	send(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1,0);
#else
	write(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1); 
#endif 
  }

  free(tmpCh);
  return(vect);
}
struct FrvS_Frame_info *FrvSFrameInfoDownload(int socket_fd)
{
  struct FrvS_Frame_info *local_info;
  char *message;
  ssize_t number_characters_read;

  message = malloc(MAX_MESSAGE_SIZE);


#ifdef WINDOWS
  _snprintf(message,MAX_MESSAGE_SIZE,"FrameInfo");
  if(send(socket_fd,message,strlen(message)+1,0) < 0 ) /* send the request to the server */
#else
  snprintf(message,MAX_MESSAGE_SIZE,"FrameInfo");
  if(write(socket_fd,message,strlen(message)+1) < 0 ) /* send the request to the server */
#endif
    {
      printf("Error Writing message %s\n", message);
      if(GLOBAL_DEBUG != NULL) 
       {
        fprintf(GLOBAL_DEBUG,"Error Writing message %s\n", message);
        fflush(GLOBAL_DEBUG);
       }
      free(message);
      return NULL;
    }

  free(message);
  local_info = malloc(sizeof(struct FrvS_Frame_info));
 /* read the server answer */
#ifdef WINDOWS 
  number_characters_read = recv (socket_fd,(char *) local_info , sizeof(struct FrvS_Frame_info),0);
#else
  number_characters_read = read (socket_fd,local_info , sizeof(struct FrvS_Frame_info));
#endif
  
  if (number_characters_read == 0)	
    {
      free(local_info);
      return NULL;
    }
  
  local_info->run         = ntohl(local_info->run);
  local_info->frame       = ntohl(local_info->frame);
  local_info->dataQuality = ntohl(local_info->dataQuality);
  local_info->GTimeS      = ntohl(local_info->GTimeS);
  local_info->GTimeN      = ntohl(local_info->GTimeN);
  local_info->ULeapS      = ntohs(local_info->ULeapS);

  if(GLOBAL_DEBUG != NULL) 
         {
          fprintf(GLOBAL_DEBUG,"remote frame name   = %s \n",local_info->name);
	  fprintf(GLOBAL_DEBUG,"remote run   number = %d \n",local_info->run);
	  fprintf(GLOBAL_DEBUG,"remote frame number = %u \n",local_info->frame);
	  fprintf(GLOBAL_DEBUG,"remote dataQuality  = %u \n",local_info->dataQuality);
	  fprintf(GLOBAL_DEBUG,"remote GTimeS       = %u \n",local_info->GTimeS);
	  fprintf(GLOBAL_DEBUG,"remote GTimeN       = %u \n",local_info->GTimeN);
	  fprintf(GLOBAL_DEBUG,"remote UleapS       = %u \n",local_info->ULeapS);
	  fprintf(GLOBAL_DEBUG,"remote frame durat. = %f \n",local_info->dt    );
          fflush(GLOBAL_DEBUG);
         }

  if (local_info->dt == 0.0)
    {
      free(local_info);
      return NULL;
    }

  return (local_info);

}

void FrvSinitLogFile(char *filename)
{
   
  if(!(GLOBAL_DEBUG=fopen(filename,"w")))
    {
      printf("Cannot open log file %s\n",filename);
      fflush(stderr);
      exit(-1);
    } 

}

SOCKET FrvSconnect(char *remote_hostname, long port)
{ /* connect remote FrvS server */
  struct in_addr remote_address;
  SOCKET socket_fd;
  struct sockaddr_in name;
  struct hostent* remote_host_name;
  int sendbuffSize = 131072;
  ssize_t number_characters_read;
  char tmpCh[MAX_MESSAGE_SIZE];

  
#ifdef WINDOWS  
  if (!InitializeWinsock (MAKEWORD(1,1) ) )  /* Win32 initialization of the socket */
      {
        printf("Error in Winsock \n");
        return INVALID_SOCKET;
      }  

  socket_fd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP); /* create the socket */
#else
  /* modified by A. Eleuteri. We check if there is a valid descriptor */
  socket_fd = socket(PF_INET, SOCK_STREAM,0); /* create the socket */    
  if (socket_fd==-1)
  {
      perror("socket");
      return INVALID_SOCKET;
  }
#endif

  name.sin_family = AF_INET;                  /* TCP SOCKET */

  remote_host_name = gethostbyname(remote_hostname); /* find IP address */
  
  if(remote_host_name == NULL || remote_host_name->h_length == 0)
    {
      printf("Remote Host not found\n");
      if(GLOBAL_DEBUG != NULL) 
        fprintf(GLOBAL_DEBUG,"Remote Host %s not found\n",remote_hostname);
      return -1;
    }
  else
    name.sin_addr = *((struct in_addr *) (remote_host_name->h_addr));

  
  if(GLOBAL_DEBUG != NULL)
    {
      fprintf(GLOBAL_DEBUG,"Host name: %s\n",remote_host_name->h_name);
#ifdef WINDOWS
      fprintf(GLOBAL_DEBUG,"Host IP: %d.%d.%d.%d\n",
	      ((short)remote_host_name->h_addr  & 0x000000FF),
	      (((short)remote_host_name->h_addr & 0x0000FF00)>>8),
	      (((short)remote_host_name->h_addr & 0x00FF0000)>>16),
	      (((short)remote_host_name->h_addr & 0xFF000000)>>24)); 
#else
      fprintf(GLOBAL_DEBUG,"Host IP: %d.%d.%d.%d\n",
	      (remote_address.s_addr  & 0x000000FF),
	      ((remote_address.s_addr & 0x0000FF00)>>8),
	      ((remote_address.s_addr & 0x00FF0000)>>16),
	      ((remote_address.s_addr & 0xFF000000)>>24)); 
#endif      
      fflush(GLOBAL_DEBUG);
    }


  name.sin_port =  htons(port);  /* convert TCP port number */
  
  
  if (connect (socket_fd, (struct sockaddr *) &name, sizeof (struct sockaddr_in)) == -1)
    {
      printf("Unable to open connection\n");
      if(GLOBAL_DEBUG != NULL)
	fprintf(GLOBAL_DEBUG,"Unable to open connection\n");
      return -1;
    }
  if(( setsockopt(socket_fd, SOL_SOCKET, SO_RCVBUF, (char *)&sendbuffSize, sizeof(sendbuffSize)) < 0)
     &&
     (GLOBAL_DEBUG != NULL))  fprintf(GLOBAL_DEBUG,"setsockopt error \n"); 

#ifdef WINDOWS  
  number_characters_read = recv (socket_fd,tmpCh,MAX_MESSAGE_SIZE,0); /* read presence */
#else
  number_characters_read = read (socket_fd,tmpCh,MAX_MESSAGE_SIZE-1); /* read presence */
#endif
  tmpCh[number_characters_read]= '\0';
  if (GLOBAL_DEBUG != NULL)  fprintf(GLOBAL_DEBUG,"HandShaking String %s \n",tmpCh);
  
/*  if(( setsockopt(socket_fd, SOL_SOCKET, SO_SNDBUF, (char *)&sendbuffSize, sizeof(sendbuffSize)) < 0)
     &&
     (GLOBAL_DEBUG != NULL))  fprintf(GLOBAL_DEBUG,"setsockopt error \n"); */ /* buffer size */

  return socket_fd;

}


int FrvSinterpreter(char *message) /* interpreter of the server messages */
{
  int rcode=0;
  char scode[3];

  scode[2]='\0';

  if(strstr(message,"MSG:")) /* all ok */
    {
      if(GLOBAL_DEBUG != NULL) fprintf(GLOBAL_DEBUG,"%s\n",message);
      scode[0]=message[4];
      scode[1]=message[5];
      rcode = atoi(scode);
    }
  else if(strstr(message,"ERR:")) /* some error occurred */
    {
      if(GLOBAL_DEBUG != NULL) fprintf(GLOBAL_DEBUG,"%s\n",message);
      scode[0]=message[4];
      scode[1]=message[5];
      rcode = -1*atoi(scode);
    }
  else 
   if(GLOBAL_DEBUG != NULL)
     {
      fprintf(GLOBAL_DEBUG,"Unknown message received %s\n",message);
      fflush(GLOBAL_DEBUG);
     }

  return rcode; /* return the code > 0 if ok, <0 if error occurred */
}

int FrvSIncrFrame(int socket_fd) /* increment frame */
{
  return(FrvSrequest_server(socket_fd, CONN_CMD_FRAME, NULL));
}

FrVect *FrvSGetVect(int socket_fd, char *FrVectName)
{
  return(FrvSGetVectInternal(socket_fd,FrVectName,CONN_CMD_SREAD,0,0));
}

FrVect *FrvSFileIGetV(int socket_fd, char *FrVectName, double tStart, double tDuration)
{
	FILE *fcache;
	FrVect *vect;
	char tmpCh[VECT_NAME_LENGTH];
	int wSize[FR_VECT_END];
	int i;
	double tStartFile, tDurationFile;
	char vectNameFile[VECT_NAME_LENGTH];
	unsigned short compress;       /* 0 = no compression; 1 = gzip             */
	FRVECTTYPES    type;           /* vector type  (see below)                 */
	FRULONG        nData,toBeReject,toBeRead;
	FRULONG        nBytes;         /* number of bytes                          */
	char          *data;           /* pointer to the data area.                */
	unsigned int   nDim;           /* number of dimension                      */
	FRULONG nx;                   /* number of element for this dimension     */
	double dx;                    /* step size value (express in above unit)  */
	double tEnd,tEndFile;
	int tmpFileFlag;
	char *tmpbuff;

	assignDataSize(wSize); 

#ifdef WINDOWS
	_snprintf(tmpCh,MAX_MESSAGE_SIZE-1,"%s.tmp",FrVectName);
#else
	snprintf(tmpCh,MAX_MESSAGE_SIZE-1,"%s.tmp",FrVectName);
#endif

	tmpFileFlag=0;
	if((fcache=fopen(tmpCh,"rb"))!=NULL) /* look for cache file */
		{  /* it exists, check if it is the right one */
			fread(&tStartFile,sizeof(tStart),1,fcache);
			fread(&tDurationFile,sizeof(tDuration),1,fcache);
			tEnd=tStart+tDuration;
			tEndFile=tStartFile+tDurationFile;
			if (tStartFile<=tStart && tEndFile>=tEnd)
			{	
				tmpFileFlag=1;
				if(GLOBAL_DEBUG != NULL) 
				{
					fprintf(GLOBAL_DEBUG,"reading from cache file =%s\n",tmpCh );
					fflush(GLOBAL_DEBUG);
				}
				fread(vectNameFile,VECT_NAME_LENGTH,1,fcache);
				fread(&type,sizeof(FRVECTTYPES),1,fcache);
				fread(&nData,sizeof(FRULONG),1,fcache);
				fread(&dx,sizeof(double),1,fcache);
				fread(&compress,sizeof(unsigned short),1,fcache);
				if(GLOBAL_DEBUG != NULL) 
				{
					fprintf(GLOBAL_DEBUG,"Data read from the file: \n");
					fprintf(GLOBAL_DEBUG,"File begins at GPS %f\n",tStartFile);
					fprintf(GLOBAL_DEBUG,"Duration %f\n",tDurationFile);
					fprintf(GLOBAL_DEBUG,"filename %s\n",vectNameFile);
					fprintf(GLOBAL_DEBUG,"type %d\n",tDurationFile);
					fprintf(GLOBAL_DEBUG,"nData %d\n",nData);
					fprintf(GLOBAL_DEBUG,"dx = %f \n",dx);
					fflush(GLOBAL_DEBUG);
				}

				nData=tDuration/dx;
				toBeReject=(tStart-tStartFile)/dx*wSize[type]; /* bytes to be rejected */				
				if(GLOBAL_DEBUG != NULL) 
				{
					fprintf(GLOBAL_DEBUG,"toBeRejected = %d\n",toBeReject);
					fflush(GLOBAL_DEBUG);
				}
				if(toBeReject>0)
				{
/*					tmpbuff=malloc(toBeReject);
					if(tmpbuff!=NULL)
						{
						fread(tmpbuff,toBeReject,1,fcache); 
						free(tmpbuff);
						} */
					fseek(tmpbuff,toBeReject,SEEK_CUR);
				}

				toBeRead=(tDuration/dx+1E-2);
				if(GLOBAL_DEBUG != NULL) 
				{
					fprintf(GLOBAL_DEBUG,"to be read from disk = %d\n",toBeRead);
					fflush(GLOBAL_DEBUG);
				}


#ifdef NOFRVLIB
				vect = MatFrVectNew1D(vectNameFile,type,toBeRead,dx,"time (s)");
#else
				vect = FrVectNew1D(vectNameFile,type,toBeRead,dx,"time (s)",NULL);
#endif
				if(vect != NULL) 
				{
					fread(vect->data,vect->nBytes,1,fcache); /* read the full buffer of bytes*/
					vect->compress = compress;
				}

			}
			fclose(fcache);
			if (tmpFileFlag==1) return(vect);
		}

	vect=FrvSGetVectInternal(socket_fd,FrVectName,CONN_CMD_FRFLVEC,tStart,tDuration);
    if(vect==NULL) return(vect);


	/* create a cache file */

	if((fcache=fopen(tmpCh,"wb"))!=NULL)
		{
			fwrite(&tStart,sizeof(tStart),1,fcache);
			fwrite(&tDuration,sizeof(tDuration),1,fcache);
			fwrite(vect->name,VECT_NAME_LENGTH,1,fcache);			
			fwrite(&vect->type,sizeof(FRVECTTYPES),1,fcache);			
			fwrite(&vect->nData,sizeof(FRULONG),1,fcache);	
#ifdef NOFRVLIB
			fwrite(&vect->dx,sizeof(double),1,fcache);	
#else
			fwrite(&vect->dx[0],sizeof(double),1,fcache);
#endif
			fwrite(&vect->compress,sizeof(unsigned short),1,fcache);
			fwrite(vect->data,vect->nBytes,1,fcache); /* write the full buffer of bytes*/
			fclose(fcache);
		}
	else
		{
			if(GLOBAL_DEBUG != NULL) 
				{
					fprintf(GLOBAL_DEBUG,"Error opening cache file =%s\n",tmpCh );
					fflush(GLOBAL_DEBUG);
				}
		}
		 


  return(vect);
}

FrVect *FrvSGetVectInternal(int socket_fd, char *FrVectName, 
			    int mode,double tStart, double tDuration)  
     /* downloader of the remote vector data */
{
  ssize_t number_characters_read, nchar_tmp;
#ifdef WINDOWS
  ssize_t char_to_read;
  ssize_t number_characters_to_read;
#endif  
  char vector_name[MAX_MESSAGE_SIZE];
  char tmpCh[MAX_MESSAGE_SIZE];
  char Empty[]="Empty";
  struct my_info_Vect info;  
  FrVect *vect;
  int err_ans=0;
  int wSize[FR_VECT_END];
  long j;
  

  assignDataSize(wSize);

#ifdef WINDOWS
  _snprintf(tmpCh,MAX_MESSAGE_SIZE-1,"%s",FrVectName);
#else
  snprintf(tmpCh,MAX_MESSAGE_SIZE-1,"%s",FrVectName);
#endif

  tmpCh[MAX_MESSAGE_SIZE-1]='\0';
  

  
  err_ans=FrvSrequest_server(socket_fd,CONN_CMD_VECTN,tmpCh); /* Select FrVect */
 
  if(err_ans <= 0)
    {
      printf("Vector %s cannot be selected, error code = %d\n",tmpCh,err_ans);
      if (GLOBAL_DEBUG != NULL)
	fprintf(GLOBAL_DEBUG,"Vector %s cannot be selected, error code = %d\n",tmpCh,err_ans);
      if(err_ans == (-1*CODE_VECTN))
	{
	  printf("Too many vectors declared (max=%d)\n",NMAXVECT);
	  if (GLOBAL_DEBUG != NULL) 
	    fprintf(GLOBAL_DEBUG,"Too many vectors declared (max=%d)\n",NMAXVECT);
	}
      return (NULL);
    }
   
  if (mode == CONN_CMD_SREAD)
    err_ans=FrvSrequest_server(socket_fd,CONN_CMD_SREAD, NULL); /* pull FrVect */
  else
    {
#ifdef WINDOWS
      _snprintf(tmpCh,MAX_MESSAGE_SIZE-1," tStart=%1.8e  tDuration#%e",tStart, tDuration);
#else
	  snprintf(tmpCh,MAX_MESSAGE_SIZE-1," tStart=%1.8e  tDuration#%e",tStart, tDuration);
#endif
      tmpCh[MAX_MESSAGE_SIZE-1]='\0';
      err_ans=FrvSrequest_server(socket_fd,CONN_CMD_FRFLVEC, tmpCh);
    }
  if(err_ans <= 0)
    {
      printf("Reading Error = %d",err_ans);
      if (GLOBAL_DEBUG != NULL) fprintf(GLOBAL_DEBUG,"Reading Error = %d",err_ans);
      if(err_ans == (-1*CODE_VECT0))
       {
	   printf("Any vectors declared \n");
         if (GLOBAL_DEBUG != NULL) fprintf(GLOBAL_DEBUG,"Any vectors declared \n");
       }
	fflush(stderr);
	if(GLOBAL_DEBUG != NULL) fflush(GLOBAL_DEBUG);
      return (NULL);
    }
  
#ifdef WINDOWS  
  number_characters_read = recv (socket_fd,tmpCh,MAX_MESSAGE_SIZE,0); /* read presence */
#else
  number_characters_read = read (socket_fd,tmpCh,MAX_MESSAGE_SIZE-1); /* read presence */
#endif
  
  tmpCh[number_characters_read]= '\0'; 
  if (number_characters_read == 0)
    {	
      printf("No characters read A\n");
      if(GLOBAL_DEBUG != NULL) 
         {
           fprintf(GLOBAL_DEBUG,"No characters read A\n");
           fflush(GLOBAL_DEBUG);
         }
      fflush(stderr);
      return (NULL);
    }
  err_ans = FrvSinterpreter(tmpCh);
  switch(err_ans)
    {	
      case (-1*CODE_FILEE):    /* end of file */
       return NULL;
       break;
      case (-1*CODE_VECTA):    /* vector absent in frame */
#ifdef NOFRVLIB
       vect = MatFrVectNew1D(Empty,3,0,1,"time (s)");
#else
       vect = FrVectNew1D(Empty,3,0,1,"time (s)",NULL);
#endif
       return vect;
       break;
    }

 /* strcpy(tmpCh,"OK"); */

#ifdef WINDOWS    
  send(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1,0);
  number_characters_read = recv (socket_fd,&info, MAX_MESSAGE_SIZE,0); /* read infos */
#else
  write(socket_fd,OK_MESSAGE,strlen(OK_MESSAGE)+1);
  number_characters_read = read (socket_fd,&info, MAX_MESSAGE_SIZE); /* read infos */  
#endif  

  if (number_characters_read == 0)	
    {	
      printf("No characters read B\n");
      fflush(stderr);
      if(GLOBAL_DEBUG != NULL) 
         {
           fprintf(GLOBAL_DEBUG,"No characters read B\n");
           fflush(GLOBAL_DEBUG);
         }
      return (NULL);
    }
 
/* check sum */  
#ifdef WINDOWS    
  send(socket_fd,&info,sizeof(struct my_info_Vect),0);
#else  
  write(socket_fd,&info,sizeof(struct my_info_Vect));
#endif
  
  info.compress = ntohs(info.compress);
  info.VectType = ntohs(info.VectType);
  info.nData    = ntohl(info.nData);
  if(GLOBAL_DEBUG != NULL) 
         {
          fprintf(GLOBAL_DEBUG,"remote vector name = %s \n",info.VectName);
	      fprintf(GLOBAL_DEBUG,"remote vector comp = %d \n",info.compress);
          fprintf(GLOBAL_DEBUG,"remote vector type = %d \n",info.VectType);
          fprintf(GLOBAL_DEBUG,"remote vector nbyt = %d \n",info.nData);
          fprintf(GLOBAL_DEBUG,"remote vector step = %f \n",info.step);
          fflush(GLOBAL_DEBUG);
         }

#ifdef NOFRVLIB
  vect = MatFrVectNew1D(info.VectName,info.VectType,info.nData,info.step,"time (s)");
#else
  vect = FrVectNew1D(info.VectName,info.VectType,info.nData,info.step,"time (s)",NULL);
#endif
  if(vect == NULL) return(NULL);
  
  vect->compress = info.compress;

  /* download data: packet could be segmented*/
#ifdef WINDOWS  
  number_characters_read =0;
  number_characters_to_read = vect->nData*wSize[vect->type];
  if (number_characters_to_read > SIZE_RECV_BUFF) number_characters_to_read=SIZE_RECV_BUFF;
  char_to_read = number_characters_to_read;
  while(number_characters_read < vect->nData*wSize[vect->type])
    {
     if (((vect->nData*wSize[vect->type])-number_characters_read)<number_characters_to_read)
        char_to_read= (((vect->nData*wSize[vect->type])-number_characters_read)<number_characters_to_read);
     nchar_tmp = recv (socket_fd,&vect->data[number_characters_read] , 
				      char_to_read,0); /* read data */
      
      if(nchar_tmp == 0 || nchar_tmp == WSAECONNRESET ) return NULL; /* lost connection */
      if(nchar_tmp == SOCKET_ERROR) 
       { error("Data communication error"); 
      /*   printf("Data communication error\n");  */
         printf("Read only %d bytes instead of %d\n",
                 number_characters_read,vect->nData*wSize[vect->type]);
         vect->nData = number_characters_read/wSize[vect->type];
         break;         
       } 
      number_characters_read += nchar_tmp;
/*      printf("read %d dataNow, integ %d\n",nchar_tmp,number_characters_read); */
    }
#else
  number_characters_read =0;
  while(number_characters_read < vect->nData*wSize[vect->type])
    {
     nchar_tmp = read (socket_fd,&vect->data[number_characters_read] , 
				      vect->nData*wSize[vect->type]); /* read data */
      if(nchar_tmp == 0) return NULL; /* lost connection */
      number_characters_read += nchar_tmp;
    }
#endif

   if(GLOBAL_DEBUG != NULL) 
    {
     fprintf(GLOBAL_DEBUG,"Data read nBytes=%d\n",number_characters_read );
     fflush(GLOBAL_DEBUG);
    }

/* take in account the byte ordering */

      switch(vect->type) /* this structure solve the problem of byte ordering */
	  {
	   case FR_VECT_2S:          /* short */
          for(j=0;j<vect->nData;j++)
               vect->dataS[j]=ntohs(vect->dataS[j]);
         break;
         case FR_VECT_2U:         /* unsigned short */
          for(j=0;j<vect->nData;j++)
               vect->dataUS[j]=ntohs(vect->dataUS[j]);
         break;

         case FR_VECT_4S:           /* int */
          for(j=0;j<vect->nData;j++)
               vect->dataI[j]=ntohl(vect->dataI[j]);
         break;
         case FR_VECT_4U:           /* unsigned int */
          for(j=0;j<vect->nData;j++)
               vect->dataUI[j]=ntohl(vect->dataUI[j]);
         break;

         default: /* do nothing */
         break;
        }

  return(vect);
}

int FrvSrequest_server(int socket_fd, int command, char *option)
{ 
/* core function for the message exchange with the server */
  char message[MAX_MESSAGE_SIZE];
  char answer[MAX_MESSAGE_SIZE];
  ssize_t number_characters_read;
  

  switch(command)
    {
    case CONN_CMD_FILE:           /* request a FrFile*/
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"file:%s",option);
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"file:%s",option);
#endif
      break;
    case CONN_CMD_VECTN:         /* Declare a FrVect */
      sprintf(message,"vectN:%s",option);
      break;
    case CONN_CMD_SREAD:        /*  pull a FrVect in a Frame */
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"ReadVect");
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"ReadVect");
#endif
      break;
    case CONN_CMD_FRAME:        /*  increment the remote Frame */
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"IncrFrame");
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"IncrFrame");
#endif
      break;
    case CONN_CMD_QUIT:         /*  close the remote connection */
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"quit");
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"quit");
#endif
      break;
    case CONN_CMD_FRFLVEC:
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"FrFileIGet: %s",option);
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"FrFileIGet: %s",option);
#endif
      break;
    case CONN_CMD_CLFL:
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"CloseFile");
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"CloseFile");
#endif
      break;
    case CONN_CMD_TSTART:
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"GPSstart");
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"GPSstart");
#endif
	  break;
    case CONN_CMD_TEND:
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"GPSend");
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"GPSend");
#endif
	  break;
	case CONN_CMD_TOC:
#ifdef WINDOWS
      _snprintf(message,MAX_MESSAGE_SIZE,"GetAdcNames");
#else
	  snprintf(message,MAX_MESSAGE_SIZE,"GetAdcNames");
#endif
	  break;



    default:                   /* bad command */
      printf("Incorrect command sent %s",option);
      fflush(stderr);
      if(GLOBAL_DEBUG != NULL) 
       {
        fprintf(GLOBAL_DEBUG,"Incorrect command sent %s",option);
        fflush(GLOBAL_DEBUG);
       }
      return CODE_CLCN;
    } /* end of switch */

  if(GLOBAL_DEBUG != NULL) 
    {
     fprintf(GLOBAL_DEBUG,"%s\n",message);
     fflush(GLOBAL_DEBUG);
    }
#ifdef WINDOWS
  if(send(socket_fd,message,strlen(message)+1,0) < 0 ) /* send the request to the server */
#else
  if(write(socket_fd,message,strlen(message)+1) < 0 ) /* send the request to the server */
#endif  
    {
      printf("Error Writing message %s\n", message);
      if(GLOBAL_DEBUG != NULL) 
       {
        fprintf(GLOBAL_DEBUG,"Error Writing message %s\n", message);
        fflush(GLOBAL_DEBUG);
       }
      return CODE_CLCN;
    }

 /* read the server answer */
#ifdef WINDOWS 
  number_characters_read = recv (socket_fd,answer , MAX_MESSAGE_SIZE,0);
  if (number_characters_read == SOCKET_ERROR)
      {
          error("Error reading answer of the server");
          return CODE_CLCN;
      }  
#else
  number_characters_read = read (socket_fd,answer , MAX_MESSAGE_SIZE-1);
#endif

  if (number_characters_read == 0)	return CODE_CLCN;
  answer[number_characters_read]='\0'; 
  
  if((command == CONN_CMD_TSTART) || (command == CONN_CMD_TEND))
	strncpy(option,answer,MAX_MESSAGE_SIZE);
  return (FrvSinterpreter(answer));
}


int FrvS_FrIfile(int socket_fd, char *filename)  /* open remote FrFile */
{
  int err_ans;
  char *message;

  message=malloc(MAX_MESSAGE_SIZE);
  if(message == NULL)
    {
      printf("malloc error in FrvS_FrIfile\n");
      if(GLOBAL_DEBUG != NULL) 
	fprintf(GLOBAL_DEBUG,"malloc error in FrvS_FrIfile\n");
      return -1;      
    }
#ifdef WINDOWS
  _snprintf(message,MAX_MESSAGE_SIZE-1,"%s",filename);
#else
  snprintf(message,MAX_MESSAGE_SIZE-1,"%s",filename);
#endif
  message[MAX_MESSAGE_SIZE-1]='\0';
  err_ans=FrvSrequest_server(socket_fd,CONN_CMD_FILE,message); /* open remote ifile */
 
  if(err_ans <= 0)
    {
      printf("file %s opening error = %d",message, err_ans);
      if(GLOBAL_DEBUG != NULL) 
	printf("file %s opening error = %d",message, err_ans);      
    }

  free(message);

  return err_ans;
}

int FrvS_FileIEnd(int socket_fd)  /* close remote FrFile */
{
  int err_ans;

  err_ans=FrvSrequest_server(socket_fd,CONN_CMD_CLFL, NULL); /* close remote ifile */
 
  if(err_ans <= 0)
    {
      printf("file closing error = %d", err_ans);
      if(GLOBAL_DEBUG != NULL) 
	printf("file closing error = %d", err_ans);      
    }

  return err_ans;
}

int FrvS_close_Connection(int socket_fd)
{

  int err_ans;

  err_ans=FrvSrequest_server(socket_fd,CONN_CMD_QUIT, NULL); /* quit */

  if(err_ans == CODE_CLCN)
    {
     if(GLOBAL_DEBUG != NULL)
       fprintf(GLOBAL_DEBUG,"End of processing\n");
    } 
  else if(err_ans <= 0)
    {
      printf("Reading Error = %d",err_ans);
      if(GLOBAL_DEBUG != NULL)
	fprintf(GLOBAL_DEBUG,"Reading Error = %d",err_ans);
    }
 
  return err_ans;
}



void assignDataSize(int *wSize)
{
	wSize[FR_VECT_4R]  = sizeof(float);    /* define sizes as defined in Frame Data */
    wSize[FR_VECT_8R]  = sizeof(double);
    wSize[FR_VECT_C]   = sizeof(char);
    wSize[FR_VECT_1U]  = sizeof(char);
    wSize[FR_VECT_2S]  = sizeof(short);
    wSize[FR_VECT_2U]  = sizeof(short);
    wSize[FR_VECT_4S]  = sizeof(int);
    wSize[FR_VECT_4S]  = sizeof(int);
    wSize[FR_VECT_8S]  = sizeof(FRLONG);
    wSize[FR_VECT_8U]  = sizeof(FRLONG);
    wSize[FR_VECT_STRING] = sizeof(char *);
    wSize[FR_VECT_8C]   = 2*sizeof(float);
    wSize[FR_VECT_16C]  = 2*sizeof(double);
    wSize[FR_VECT_8H]   = sizeof(float);
    wSize[FR_VECT_16H]  = sizeof(double);
	return;
}
/**********************************************
* Windows Sockets Initialization              *
**********************************************/
#ifdef WINDOWS

int InitializeWinsock(WORD wVersionRequested)
{
WSADATA wsaData;
int err;

	err = WSAStartup(wVersionRequested, &wsaData);
/*
	 ritorna errore se, ad esempio, l'applicazione supporta al massimo
	 la versione 1.1 e la DLL supporta da 2.0 in su (le versioni non si sovrappongono)*/
	if (err!=0) return 0; /* Tell the user that we couldn't find a usable winsock.dll 

	 WSAStartup returns in wHighVersion (struct wsaData) the highest version it supports
	  and in wVersion the minimum of its high version and wVersionRequested.
	  wVersion is the The version of the Windows Sockets specification 
	  that the Windows Sockets DLL expects the caller to use.

	 Se WSAStartup ritorna un risultato accettabile, l'applicazione deve ancora 
	  verificare che il risultato sia compatibile con la sua richiesta. Ad esempio,
	  con wVersionRequested=1.1 e DLL version 1.0, wVersion=1.0. Se l'applicazione 
	  vuole assolutamente usare la DLL 1.1, deve ancora verificare di non trovarsi 
	  in questo caso

	 Tell the user that we couldn't find a usable winsock.dll.*/
	if (LOBYTE(wsaData.wVersion )!=1 || HIBYTE(wsaData.wVersion)!=1) return 0;

	/* Everything is fine: proceed */
	return 1;
}


/* define to save space
 modified by A. Eleuteri: added parenthesis to protect against name mangling */
#define PERR(X) printf( (X) ); if(GLOBAL_DEBUG != NULL) fprintf(GLOBAL_DEBUG,(X)); break;

void error(char* string)
{
  int err;
	printf( "%s", string);

	err= WSAGetLastError();
    
	/* in Windows, gli errori dovuti ai sockets sono mappati oltre 10000 */
   	switch (err)
	{
	case WSANOTINITIALISED: 
             PERR("A successful WSAStartup() must occur before using this API.");
	case WSAENETDOWN:
             PERR("The Windows Sockets implementation has detected that the network subsystem has failed.");
	case WSAEAFNOSUPPORT:
             PERR("The specified address family is not supported.");
	case WSAEINPROGRESS:
             PERR("A blocking Windows Sockets operation is in progress.");
	case WSAEMFILE:
             PERR("No more file descriptors are available.");
	case WSAENOBUFS:
             PERR("No buffer space is available. The socket cannot be created.");
	case WSAEPROTONOSUPPORT:
             PERR("The specified protocol is not supported.");
	case WSAEPROTOTYPE:
             PERR("The specified protocol is the wrong type for this socket.");
	case WSAESOCKTNOSUPPORT:
             PERR("The specified socket type is not supported in this address family.");
   	case WSAEADDRINUSE:
             PERR("The specified address is already in use. (See setsockopt() SO_REUSEADDR option)");
    	case WSAEFAULT:
             PERR("The namelen argument is too small (less than the size of a struct sockaddr).");
    	case WSAEINTR:
             PERR("The (blocking) call was canceled via WSACancelBlockingCall()");
	case WSAEINVAL:
             PERR("The socket is already bound to an address.");
   	case WSAENOTSOCK:
             PERR("The descriptor is not a socket.");
    	case WSAEADDRNOTAVAIL:
             PERR("Address not availabile");
	case WSAEISCONN:
             PERR("The socket is already connected.");
	case WSAEOPNOTSUPP:
             PERR("The referenced socket is not of a type that supports the listen() operation.");
	case WSAEWOULDBLOCK:
             PERR("The socket is marked as non-blocking and no connections are present to be accepted.");
	case WSAECONNREFUSED:
             PERR("The attempt to connect was forcefully rejected.");
	case WSAEDESTADDRREQ:
             PERR("A destination address is required.");
	case WSAENETUNREACH:
             PERR("The network can't be reached from this host at this time.");
	case WSAETIMEDOUT:
             PERR("Attempt to connect timed out without establishing a connection");
       	case WSAECONNRESET:
             PERR("Connection reset");
       
	default:
             printf( "Error reported by WSAGetLastError= %d\n Check winsock.h.\n\n", err); break;
	};
    printf("\n");
	return ;
	}
#endif /* WINDOWS */

#ifdef NOFRVLIB
MatFrVect *MatFrVectNew1D(char *name,int type, FRLONG nData, double dx, char *unitx)
{
    MatFrVect *locVect;
    void *dataPtr;
    int wSize[FR_VECT_END];
    
	assignDataSize(wSize);
          
    locVect=malloc(sizeof(MatFrVect));
          
    strncpy(locVect->name,name,MAX_NAME_SIZE);
    locVect->name[MAX_NAME_SIZE-1] = '\0';
        
    locVect->type = type;
    locVect->nData = nData;
    locVect->nBytes = nData*wSize[type];
    locVect->dx = dx;
         
    strncpy(locVect->unitX,unitx,MAX_NAME_SIZE);
    locVect->unitX[MAX_NAME_SIZE-1] = '\0';
         
    dataPtr=malloc(locVect->nBytes);
    locVect->data  = (char *) dataPtr;
    locVect->dataS = (short *) dataPtr;
    locVect->dataI = (int *) dataPtr;
    locVect->dataL = (FRLONG *) dataPtr;
    locVect->dataF = (float *) dataPtr;
    locVect->dataD = (double *) dataPtr;
    locVect->dataU = (unsigned char *) dataPtr;
    locVect->dataUS = (unsigned short *) dataPtr;
    locVect->dataUI = (unsigned int *) dataPtr;
    locVect->dataUL = (FRULONG *) dataPtr;
	locVect->dataQ  = (char **) dataPtr;
         
    return locVect;
}
      
void MatFree(MatFrVect *MatVector)
{
	int i;

	if(MatVector == NULL) return;

	if(MatVector->type ==FR_VECT_STRING)
		{
			for(i=0; i< MatVector->nData; i++)
				free(MatVector->dataQ[i]);
		}
	else
    if(MatVector->data != NULL) 
      free(MatVector->data);
           
    free(MatVector);
    return;
}
#endif
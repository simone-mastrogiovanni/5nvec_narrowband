#include "FrvSserver.h"
#define SERVER_VERSION "v2r00\0"
char OK_MESSAGE[]= "OK";

void timestamp_file()
{
  struct tm *ptr;
  time_t lt;
 
  lt= time(NULL);
  ptr = localtime(&lt);
  fprintf(LOGFILE,"%s\n",asctime(ptr));
  fflush(LOGFILE);
}

pid_t run_Child_killer(char *killerString)
{
 pid_t killer_pid;
 char *p1, *p2;
 int i=0;
 char **cmd;
	
 killer_pid = fork();

 if (killer_pid != 0)  /* parent process */
   {
     fprintf(LOGFILE,"Starting killer process with ID %d\n",killer_pid);
     fflush(LOGFILE);
     return killer_pid;
   }
  else
   { /* child process */
     
     p1=killerString;
     p2 = strstr(killerString," ");
     do
      {
       *p2='\0';
       p2++;	
       cmd[i]=malloc(strlen(p1)+1);
       strcpy(cmd[i],p1);
       p1=p2;
	 i++;	
	 p2 = strstr(p2," ");
      } while(p2);
    cmd[i]=malloc(strlen(p1)+1);
    strcpy(cmd[i],p1);
    i++;
    cmd[i]=malloc(1);
    cmd[i]='\0';
    /* fprintf(LOGFILE,"number %d %s %s %s %s\n",i,cmd[0],cmd[1],cmd[2],cmd[3]); */
    execv(cmd[0],cmd);
    fprintf(LOGFILE,"error executing the command %s %s %s %s\n",cmd[0],cmd[1],cmd[2],cmd[3]);
    fflush(LOGFILE); 
    exit(-1);
   } 

}

static void clean_up_child_process(int signal_number)
{
  int status;
  wait(&status);
}

int frameIncrement(int connection_fd)
{
  extern struct FrameH *frame;   /* frame struct pointer */
  char response[MAX_MESSAGE_SIZE];
  int nbytes=0;

  if(frame != NULL) FrameFree(frame);

  if((frame = FrameRead(iFile)) == NULL) 
    {
      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u End of file",
	       CODE_FILEE);
      nbytes = strlen(response)+1;
      fprintf(LOGFILE,"%d:%d -%s\n",(int) getpid(), (long) time(NULL),response);
      fflush(LOGFILE);
      if(write(connection_fd,response,nbytes) != nbytes)
	{
	  fprintf(LOGFILE,"%d:%d -ERR: %s\n",(int) getpid(), (long) time(NULL), response); 
	  fflush(LOGFILE);
	  return (-1*CODE_FILE); 
	}
      return (-1*CODE_FILE);
    }

  return(CODE_FILE);

}

int VectUpload(int connection_fd, short *nvect, char **vectNames, 
	       int mode, double tStart, double tDuration)
{
  extern struct FrameH *frame;   /* frame struct pointer */
  struct FrVect *myVector=NULL;
  short i;
  long j;
  int nbytes=0;
  char response[MAX_MESSAGE_SIZE];
  struct my_info_Vect info;
  struct my_info_Vect check;
  int n_wr, total_written;
  char *tmpBuff;
  short *tmpBuffS;
  unsigned short *tmpBuffUS;
  int *tmpBuffI;
  unsigned int *tmpBuffUI;


  
  while(*nvect>0)
    {
      i = *nvect-1;
      if (mode == CONN_CMD_SREAD)
	myVector = FrameGetV(frame,vectNames[i]);
      else if (mode == CONN_CMD_FRFLVEC) 
	{
	  myVector = FrFileIGetV(iFile,vectNames[i],tStart, tDuration);
	}
      if (myVector==NULL)
	{
	  if(LOG_LEVEL>0)
	    fprintf(LOGFILE,"%d:%d- ERR:%02u: FrVect %s absent in frame\n",(int) getpid(), (long) time(NULL),
                CODE_VECTA,  vectNames[i]); 
	  snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u FrVect %s absent in frame",
		   CODE_VECTA, vectNames[i]);
	  if(write(connection_fd,response,strlen(response)+1) != (strlen(response)+1))
	    {
	      fprintf(LOGFILE,"%d:%d- ERR:  %s\n",(int) getpid(), (long) time(NULL), myVector->name); 
	      fflush(LOGFILE);
	      if(frame != NULL) FrameFree(frame);
	      return (-1*CODE_VECTN); 
	    }
	  if(LOG_LEVEL>0) fflush(LOGFILE);
	  free(vectNames[i]);
	  *nvect = *nvect -1;
	  continue; 
        } 
      else
        {
	  snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u FrVect %s found in frame",
		   CODE_VECTA, myVector->name);
	  nbytes = strlen(response)+1;
	  if(LOG_LEVEL>1)	    
	    {
	      fprintf(LOGFILE,"%d:%d- %s dati %d\n",(int) getpid(), (long) time(NULL),response,nbytes);
	      fflush(LOGFILE);
	    } 
	  if(write(connection_fd,response,nbytes) != nbytes)
	    {
	      fprintf(LOGFILE,"%d:%d- ERR: %s\n",(int) getpid(), (long) time(NULL),vectNames[i]); 
	      fflush(LOGFILE);
	      if(frame != NULL) FrameFree(frame);
	      return (-1*CODE_VECTN); 
	    }
        }
	    
      read (connection_fd,response, MAX_MESSAGE_SIZE);  /* syncronize */
      
      /* transfer vect infos */
      strncpy(info.VectName,myVector->name,VECT_NAME_LENGTH-1);
      info.VectName[VECT_NAME_LENGTH-1]='\0';
      info.compress = htons((u_short) myVector->compress);
      info.VectType = htons((u_short) myVector->type);
      info.nData = htonl(myVector->nData);
      info.step = myVector->dx[0];
      nbytes = sizeof(struct my_info_Vect);
      if(write(connection_fd,&info,nbytes) != nbytes)  /* transfer the vector infos */
	{
	  fprintf(LOGFILE,"%d:%d- ERR: in %d: %s\n",(int) getpid(), (long) time(NULL),myVector->name); 
	  fflush(LOGFILE);
	  if(frame != NULL) FrameFree(frame);       
	  return (-1*CODE_VECTN); 
        }
      
      if(LOG_LEVEL>1)	    
	{
	  fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL), myVector->name); 
	  fflush(LOGFILE);
	}
      
      if((n_wr=read (connection_fd,&check, nbytes)) != nbytes)  
	{
	  fprintf(LOGFILE,"%d:%d- ERR: invalid check length %d %d\n",(int) getpid(),(long) time(NULL),
                        nbytes,n_wr); 
	  fflush(LOGFILE);
	  if(frame != NULL) FrameFree(frame);        
	  return (-1*CODE_VECTN); 
	}
 
      if(memcmp(&info,&check,nbytes) != 0)
	{
	  fprintf(LOGFILE,"%d:%d- ERR: invalid check\n",(int) getpid(),(long) time(NULL)); 
	  fflush(LOGFILE);
	  if(frame != NULL) FrameFree(frame);         
	  return (-1*CODE_VECTN); 
	}
      
      nbytes = myVector->nBytes;
      tmpBuff=malloc(nbytes); /* allocate temporary buffer */
      
      switch(myVector->type) /* this structure solve the problem of byte ordering */
	{
	case FR_VECT_2S:          /* short */
          tmpBuffS = tmpBuff;
          for(j=0;j<myVector->nData;j++)
            {
	      *tmpBuffS=htons(myVector->dataS[j]);
	      tmpBuffS++;
            }
          tmpBuffS = tmpBuff;
	  break;
	case FR_VECT_2U:         /* unsigned short */
          tmpBuffUS = tmpBuff;
          for(j=0;j<myVector->nData;j++)
            {
	      *tmpBuffUS=htons(myVector->dataUS[j]);
	      tmpBuffUS++;
            }
          tmpBuffUS = tmpBuff;
	  break;
	  
	case FR_VECT_4S:           /* int */
          tmpBuffI = tmpBuff;
          for(j=0;j<myVector->nData;j++)
            {
	      *tmpBuffI=htonl(myVector->dataI[j]);
	      tmpBuffI++;
            }
          tmpBuffI = tmpBuff;
	  
	  break;
	case FR_VECT_4U:           /* unsigned int */
	  tmpBuffUI = tmpBuff;
	  for(j=0;j<myVector->nData;j++)
            {
	      *tmpBuffUI=htonl(myVector->dataUI[j]);
	      tmpBuffUI++;
            }
          tmpBuffUI = tmpBuff;
	  
	  break;
	  
	default:
	  memcpy(tmpBuff, myVector->data, nbytes);
	  break;
        }

	 
      total_written=0;
      while(total_written < nbytes)
        {
          n_wr = write(connection_fd,&tmpBuff[total_written],nbytes); /* transfer the data */
	  if(n_wr == 0) /* lost connection */
	    {
	      fprintf(LOGFILE,"%d:%d- ERR : Data %d\n",(int) getpid(), (long) time(NULL),nbytes); 
	      fflush(LOGFILE);
	      if(frame != NULL) FrameFree(frame);
	      free(tmpBuff);
	      return (-1*CODE_VECTN); 
	    }

	  total_written += n_wr;
        }
      free(tmpBuff);
      free(vectNames[i]);
      *nvect=*nvect-1;
      if(LOG_LEVEL>1) fflush(LOGFILE);
      
      if ((mode == CONN_CMD_FRFLVEC) && (myVector != NULL))
	FrVectFree(myVector);
    }  
  
  
  return (CODE_VECTN);  /* All ok */
}


int TOCUpload(int connection_fd)
{
  int nbytes=0;
  int i;
  char response[MAX_MESSAGE_SIZE];
  struct my_info_Vect info;
  FrVect *VectNames;

	if(iFile == NULL)     /* no file open: error and go back */
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u any file open",CODE_FILE);
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      if(write(connection_fd,response,strlen(response)) <0 )
		  fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
		  return -1*CODE_FILE;
	    }

			
	VectNames=FrFileIGetAdcNames(iFile);  /* read the remote TOC */
	if(VectNames == NULL)  /* if Null , error  */
			 {
			   snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u cannot read TOC of the file",CODE_TOC);
	           fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(),(long) time(NULL), response);
			   if(write(connection_fd,response,strlen(response)) <0 )
		       fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
			   return -1*CODE_TOC;
	         }
 /* here all it is OK */

	snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u  read TOC: number of channels %d",CODE_TOC,VectNames->nData);
	fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	if( write(connection_fd,response,strlen(response)) < 0 )
	    fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);

	read (connection_fd,response, MAX_MESSAGE_SIZE);  /* syncronize: wait for a OK */
      
      /* transfer vect infos */
	strncpy(info.VectName,VectNames->name,VECT_NAME_LENGTH-1);
    info.VectName[VECT_NAME_LENGTH-1]='\0';
    info.compress = htons((u_short) VectNames->compress);
    info.VectType = htons((u_short) VectNames->type);
    info.nData = htonl(VectNames->nData);
    info.step = VectNames->dx[0];
    nbytes = sizeof(struct my_info_Vect);
    if(write(connection_fd,&info,nbytes) != nbytes)  /* transfer the vector infos */
		{
			fprintf(LOGFILE,"%d:%d- ERR: in %d: %s\n",(int) getpid(), (long) time(NULL),VectNames->name); 
			fflush(LOGFILE);
			FrVectFree(VectNames);       
			return (-1*CODE_TOC); 
        }

	i = 0;
	read (connection_fd,response, MAX_MESSAGE_SIZE);  /* syncronize: wait for a OK */
	while (i<VectNames->nData && (!strcmp(response,OK_MESSAGE)) ) /* in this loop transfer all the TOC one by one */
		{
			write(connection_fd,VectNames->dataQ[i],strlen(VectNames->dataQ[i]));
			i++;
			read (connection_fd,response, MAX_MESSAGE_SIZE);  /* syncronize: wait for a OK */
		}
	FrVectFree(VectNames);       
	return (CODE_TOC); 
}


int Rcv_cmd(char *buffer)
{

  if(!strcmp(buffer,"quit"))
    return CONN_CMD_QUIT;

  if(!strcmp(buffer,"CloseFile"))
    return CONN_CMD_CLFL;

  if(!strcmp(buffer,"FrameInfo"))
    return CONN_CMD_FRINFO;

  if(strstr(buffer,"ReadVect") != NULL)
    return CONN_CMD_SREAD;

  if(strstr(buffer,"vectN:") != NULL)
    return CONN_CMD_VECTN;

  if(strstr(buffer,"IncrFrame") != NULL)
    return CONN_CMD_FRAME;

  if(strstr(buffer,"FrFileIGet") != NULL)
    return CONN_CMD_FRFLVEC;

  if(strstr(buffer,"file:") != NULL)
    return CONN_CMD_FILE;

  if(strstr(buffer,"GPSstart") != NULL)
    return CONN_CMD_TSTART;

  if(strstr(buffer,"GPSend") != NULL)
    return CONN_CMD_TEND;
  
  if(strstr(buffer,"GetAdcNames") != NULL)
    return CONN_CMD_TOC;
    
  return CONN_CMD_ERR;
}


static void my_handle_connection(int connection_fd)
{
  char buffer[256];
  ssize_t bytes_read;
  
  int selection=0;
  char response[MAX_MESSAGE_SIZE];
  char *filename;
  char *vectNames[NMAXVECT];
  char *ch_tmp,*ch_tmp2, *ch_tmp3;
  short nvect=0;
  int ans=0;
  double tStart, tDuration;
  struct FrvS_Frame_info *local_info;
  FrVect *VectNames;
  

  snprintf(response,MAX_MESSAGE_SIZE,"FrvSocket server version  %s",SERVER_VERSION);
  write(connection_fd,response,strlen(response));

  while(1)
    {
      bytes_read = read(connection_fd, buffer, sizeof(buffer)-1);
      if(bytes_read > 0)
	while((buffer[bytes_read-1]==10) || (buffer[bytes_read-1]==13))
	  bytes_read--;  /* remove CRLF (13-10) */
      
      if(bytes_read > 0)
	 {
	   buffer[bytes_read] = '\0';
	 } 
      else
	{
	  fprintf(LOGFILE,"%d:%d- Connection Lost\n",(int) getpid(), (long) time(NULL));	  
        fprintf(LOGFILE,"%d:%d- Server process is closing the connection at ", (int) getpid(),(long) time(NULL));
	  timestamp_file();
	  
	  return; /* 0 bytes read = lost connection */ 
	} 
      selection = Rcv_cmd(buffer);

      switch(selection)
	{
	case CONN_CMD_QUIT:   /* quit */
	  return;
	  break;
	case CONN_CMD_ERR:   /* unknown command */
	  snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u unknown command %s",CODE_WCMD,buffer);
	  write(connection_fd,response,strlen(response));
	  fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(),(long) time(NULL), response);
	  continue;
	  break;

	case CONN_CMD_FILE:   /* open file */
	  filename = strstr(buffer,":")+1;
	  
	  /* open the frame file */
	  iFile = FrFileINew(filename);
	  if(iFile == NULL)
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u cannot open file %s",CODE_FILE,filename);
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(),(long) time(NULL), response);
	      if(write(connection_fd,response,strlen(response)) <0 )
		fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
	    }
	  else
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u  opening file %s",CODE_FILE,filename);
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      if( write(connection_fd,response,strlen(response)) < 0 )
		fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
	    }
	  break;

	case CONN_CMD_CLFL:  /* close file */
	  if(iFile == NULL)
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u any file open",CODE_FILE);
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      if(write(connection_fd,response,strlen(response)) <0 )
		fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
	    }
	  else
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u  closing file",CODE_FILE);
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(),(long) time(NULL), response);
	      if( write(connection_fd,response,strlen(response)) < 0 )
		fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
	      FrFileIEnd (iFile);
	      iFile = NULL;
	    }
	  break;

	case CONN_CMD_TOC:   /* Read TOC of the file */
	  if((TOCUpload(connection_fd))<0) return; /*close connection*/
	  
	  break;


	case CONN_CMD_TSTART:  /* GPStime start */
      case CONN_CMD_TEND:   /* GPStime end   */
	  if(iFile == NULL)
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u any ffl file open",CODE_FILE);
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      if(write(connection_fd,response,strlen(response)) <0 )
		fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
	    }
	  else
	    {
  		if(selection == CONN_CMD_TSTART)
 	      	snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u  GPStstart=%1.8e",CONN_CMD_TSTART,
					FrFileITStart(iFile));
 		else
			snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u  GPStend=%1.8e",CONN_CMD_TEND,
					FrFileITEnd(iFile));
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      if( write(connection_fd,response,strlen(response)) < 0 )
		fprintf(LOGFILE,"Error Writing on the socket the message %s\n",response);
	    }
	  break;



	case CONN_CMD_VECTN:
	  if(nvect>=NMAXVECT)  /* too many vectors */
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u the number of vectors (%d) larger than limit (%d)",
		       CODE_VECTN,nvect,NMAXVECT);
	      write(connection_fd,response,strlen(response));
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	    }
	  else
	    {
	      vectNames[nvect]=malloc(MAX_MESSAGE_SIZE);
	      ch_tmp = strstr(buffer,":")+1;
	      strcpy(vectNames[nvect],ch_tmp);
	      snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u vect[%d]= %s request.",
		       CODE_VECTN,nvect,vectNames[nvect]);
	      write(connection_fd,response,strlen(response));
	      if(LOG_LEVEL>0) fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      nvect++;
	    }
	  break;

	case CONN_CMD_SREAD:
	case CONN_CMD_FRFLVEC:
	  if(nvect==0)
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u no vector defined",CODE_VECT0);
	      write(connection_fd,response,strlen(response));
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      fflush(LOGFILE);
	      continue;
	    }
	   
	  snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u  N vector defined %d",CODE_VECT0,nvect);
	  write(connection_fd,response,strlen(response));

	  if (selection == CONN_CMD_SREAD)
	    ans = VectUpload(connection_fd,&nvect,vectNames,CONN_CMD_SREAD,0,0);
	  else
	    {
	       ch_tmp  = strstr(buffer,"=")+1;
	       ch_tmp2 = strstr(buffer,"tDuration");
	       ch_tmp3 = strstr(buffer,"#")+1;
	       ch_tmp2--;
	       *ch_tmp2='\0';
	       tStart = atof(ch_tmp);
	       tDuration =atof(ch_tmp3);
	       if(LOG_LEVEL>1)
		 {
		   fprintf(LOGFILE,"%d:%d- FrvSFileIGetV request - tStart=%1.8e tDuration=%e\n",
                              (int) getpid(), (long) time(NULL),
                               tStart, tDuration);
		   fflush(LOGFILE); 
		 }
	       ans = VectUpload(connection_fd,&nvect,vectNames,CONN_CMD_FRFLVEC,tStart,tDuration);
	    }
	  if(ans<0) return; /*close connection*/
	  break; 
	case CONN_CMD_FRAME:
	  if(iFile==NULL)
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u no file defined",CODE_FILEE);
	      write(connection_fd,response,strlen(response));
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      fflush(LOGFILE);
	      continue;
	    }
	   
          ans = frameIncrement(connection_fd);
          if(ans<0) 
	    {
	      snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u end of file reached",CODE_FILEE);
	      write(connection_fd,response,strlen(response));
	      fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response);
	      fflush(LOGFILE);
	      return; /*close connection*/
	    }

          /* frame increment OK, send the MSG */
	  snprintf(response,MAX_MESSAGE_SIZE,"MSG:%02u  frame incremented",CODE_FILEE);
	  write(connection_fd,response,strlen(response));
/*	  fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(),(long) time(NULL), response);
	  fflush(LOGFILE); */
	
	  break; 

	case CONN_CMD_FRINFO:
	  local_info = malloc(sizeof(struct FrvS_Frame_info));

	  if (frame == NULL) /* no frame loaded */
	    {
	      local_info->dt = 0.0;
	      strcpy(local_info->name,"ERROR");
	    }
	  else
	    {
	      strncpy(local_info->name,frame->name,VECT_NAME_LENGTH-1);
	      local_info->name[VECT_NAME_LENGTH-1]='\0';
	      local_info->run         = htonl(frame->run);      
	      local_info->frame       = htonl(frame->frame);
	      local_info->dataQuality = htonl(frame->dataQuality);
	      local_info->GTimeS      = htonl(frame->GTimeS);
	      local_info->GTimeN      = htonl(frame->GTimeN);
	      local_info->ULeapS      = htons(frame->ULeapS);
	      local_info->dt = frame->dt;
	    }
	  if(write(connection_fd,local_info,sizeof(struct FrvS_Frame_info)) !=
	     sizeof(struct FrvS_Frame_info))
	    fprintf(LOGFILE,"%d:%d- ERR in tranfering frame infos\n",(int) getpid(),(long) time(NULL));
	  free(local_info);

	  break;

	default:
	  snprintf(response,MAX_MESSAGE_SIZE,"ERR:%02u unknown value %d and command %s",CODE_WCMD,selection,buffer);
	  write(connection_fd,response,strlen(response));
	  fprintf(LOGFILE,"%d:%d- %s\n",(int) getpid(), (long) time(NULL),response); 
	}
      fflush(LOGFILE);
    } 
} 

void server_run (struct in_addr local_address, uint16_t port, char *killerString)
{
  struct sockaddr_in socket_address, remote_address;
  int server_socket;
  int rval;
  int connection;
  socklen_t address_length,  address_length_remote, address_length_tmp;
  struct sigaction sigchld_action;
  pid_t child_pid;
  pid_t killer_pid;
  int sendbuffSize = 4096;
/*                   131072;*/ 
/*  int sendbuffSize = 524288; */


  /* install a handler for SIGCHLD that cleans up child processes that have terminated */
  memset(&sigchld_action, 0, sizeof(sigchld_action));
  sigchld_action.sa_handler = &clean_up_child_process;
  sigaction(SIGCHLD, &sigchld_action, NULL);


/* run the Child killer (from version v1r06 ) */

  killer_pid = run_Child_killer(killerString);

  /* create a TCP socket */

  server_socket = socket(PF_INET, SOCK_STREAM,0);
  if (server_socket == -1)
    {
      fprintf(stderr,"socket error\n");
      exit(0);
    }
  socket_address.sin_family = AF_INET;
  socket_address.sin_port = port;
  socket_address.sin_addr = local_address;
  


  rval = bind(server_socket, (struct sockaddr *)&socket_address, sizeof(socket_address));
  if(rval !=0)
    {
      fprintf(stderr,"bind error\n");
      exit(0); 
    }

  rval = listen(server_socket, 10); /* accetta 10 connessioni */ 
  if(rval !=0)
    {
      fprintf(stderr,"listen error\n");
      exit(0); 
    }

  address_length =sizeof(socket_address);
  rval = getsockname(server_socket, (struct sockaddr *)&socket_address, &address_length);
  assert(rval==0);
  fprintf(stdout,"server listening on %s:%d\n",
	  inet_ntoa(socket_address.sin_addr),
	  (int) ntohs(socket_address.sin_port));

  /* loop forever, handling connections */

  while(1)
    {
      address_length_remote =sizeof(remote_address);
      /* BLOCKING CALL */
      connection = accept(server_socket,  (struct sockaddr *)&remote_address, &address_length_remote);
      if(connection == -1)
	{
	  if(errno == EINTR) /* call interrupted by a signal, continue */
	    continue;
	  else
	    {
	      fprintf(stderr,"accept error\n"); 
	      exit(0);
	    }  
	} 
      address_length_tmp = sizeof(socket_address);
      rval = getpeername(connection,(struct sockaddr *)&socket_address,&address_length_tmp);
      assert(rval==0);
      fprintf(LOGFILE, "connection accepted from %s\n", 
	      inet_ntoa(socket_address.sin_addr));
      fprintf(LOGFILE,"starting new process at ");
      timestamp_file();

      child_pid = fork();
      if (child_pid == 0)
	{ 
	  /* child process */
	  /* it cannot use stdin and stdout, close them */
	  /*      close(STDIN_FILENO); */
	  /*	  close(STDOUT_FILENO); */
	  /* close the socket */
	  close(server_socket);
	  /* handle the connection */
        if( setsockopt(connection, SOL_SOCKET, SO_SNDBUF, (char *)&sendbuffSize, sizeof(sendbuffSize)) < 0)
            fprintf(LOGFILE,"setsockopt error \n");
	  my_handle_connection(connection);
          fprintf(LOGFILE,"%d:%d- child process is closing the connection at ", (int) getpid(),(long) time(NULL));
          timestamp_file();
	  /* all done */
	  close(connection);
	  exit(0);
	} 
      else if (child_pid>0) /* parent process, 
			       remains in listening 
			       for new connections */
	{
	  close(connection);
	  fprintf(LOGFILE, "child process started with ID %d ", (int) child_pid);
	  fprintf(LOGFILE, "connected to node %s\n",inet_ntoa(socket_address.sin_addr));
	} 
      else
	fprintf(LOGFILE,"fork error \n");
      fflush(LOGFILE);
    }   
}



int main (int argc, char* const argv[])
{ 
  struct in_addr local_address;
  uint16_t port;
  struct hostent* local_host_name;
  long value;
  char* end;
  char killerString[500];
  char tmpString[400];
  char *p1, *p2;
  unsigned int nChar;


  
  

  
  if(argc < 5) 
     {
      fprintf(stderr,"Some parameter is missing\n");
      fprintf(stderr,"Usage:\n");
      fprintf(stderr,"%s server_node_name port logFileName LOG_Level\n", argv[0]);
      exit(-1);
     }

  /* create LOG file and write time stamp */

  if (strlen(argv[3])<1)
     {
      fprintf(stderr,"LogFile Not specified\n");
      exit(-1);
     }

  if(!(LOGFILE=fopen(argv[3],"w")))
    {
      fprintf(stderr,"Cannot open log file %s\n",argv[3]);
      exit(-1);
    }
 
  LOG_LEVEL=atoi(argv[4]);

  fprintf(LOGFILE,"Net server %s %s started at ", argv[0], SERVER_VERSION );
  timestamp_file();
  fprintf(LOGFILE,"Parameters are node:%s, port:%s, logFile:%s\n", argv[1], argv[2],argv[3]); 
  fprintf(LOGFILE,"Parent process ID is %d\n",(int) getpid());
  local_host_name = gethostbyname(argv[1]);
  if(local_host_name == NULL || local_host_name->h_length == 0)
    {
      fprintf(LOGFILE,"Local Host not found\n");
      exit(0);
    }
  else
    local_address.s_addr = *((int*) (local_host_name->h_addr_list[0]));


  fprintf(LOGFILE,"Host name: %s\n",local_host_name->h_name);
  fprintf(LOGFILE,"Host IP: %d.%d.%d.%d\n",
	  (local_address.s_addr  & 0x000000FF),
	  ((local_address.s_addr & 0x0000FF00)>>8),
	  ((local_address.s_addr & 0x00FF0000)>>16),
	  ((local_address.s_addr & 0xFF000000)>>24));
  fflush(LOGFILE);
  
  value = strtol(argv[2],&end,10);
  if(*end != '\0')
    {
      fprintf(LOGFILE,"Incorrect Port %s\n", argv[2]);
      exit(-1);
    }    
  else
    port = (uint16_t) htons(value);

  p1 = strstr(argv[0],"/");
  if (p1 == NULL)  /* no path */
     strcpy(tmpString,"FrvS_Child_killer.exe");
  else 
    {
      do /*  find the last "/" */
	 {
		p2 = p1;
		p2++;
		p2 = strstr(p2,"/");
		if (p2) p1=p2;
       } while(p2);

	nChar = ((unsigned) (p1 - argv[0])) +1; 
	memcpy(tmpString,argv[0],nChar);
	tmpString[nChar]='\0';
      strcat(tmpString,"FrvS_Child_killer.exe");
    }  
  

  snprintf(killerString,499,"%s %d %s %d",
	       tmpString,(int) getpid(), argv[3], 100);
  /* fprintf(stdout,"killer %s\n",killerString); */
  server_run(local_address, port, killerString);
} 



















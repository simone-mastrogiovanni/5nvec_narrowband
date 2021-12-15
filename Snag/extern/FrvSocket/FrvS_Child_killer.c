#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <signal.h>
#include <ctype.h>
#include <time.h>
#include <string.h>



#define NCHAR 255
#define cTIMEOUT 60*10  /* timeout seconds */ 

struct processo
{
  long ClientPid;
  long int tempo;
  long int DT;	
  short alive;
  struct processo *nextProc;
};

int line_interpreter(char *linea, struct processo *proc);
struct processo *dataBaseChild(long nChild, struct processo *proc, struct processo *procDB);
int killSleepings(struct processo *procDB, long DT, char *fileName, long parent);



int main (int argc, char* const argv[])
{

FILE *logFile;
char linea[NCHAR];
struct processo proc;
long nChild=0;
struct processo *procDB=NULL;
time_t tempoAttesa, attesaIniziale=1;
long parent;

   if(argc < 3) 
     {
      fprintf(stderr,"Some parameter is missing\n");
      fprintf(stderr,"Usage:\n");
      fprintf(stderr,"%s Parent_ID logFileName [initialDelay]\n", argv[0]);
      exit(-1);
     } 

  if (strlen(argv[2])<1)
     {
      fprintf(stderr,"LogFile Not specified\n");
      exit(-1);
     }

  fprintf(stdout,"killer process %d started on the file %s \n",(int) getpid(), argv[2]);
  parent = atol(argv[1]);

  if(argc>3 && strlen(argv[3])>0) attesaIniziale = atol(argv[3]);
  if (attesaIniziale>0) sleep(attesaIniziale);

/*  tempoAttesa=time(NULL);
  while((time(NULL)-tempoAttesa)<attesaIniziale); */ /* wait */

  while(1) /* infinite loop */
  {
   tempoAttesa=time(NULL);

   if(!(logFile=fopen(argv[2],"r")))
    {
      fprintf(stderr,"Cannot open log file %s\n",argv[2]);
      exit(-1);
    }

   while(!feof(logFile))
     {
	
      if(fgets(linea, NCHAR-2,logFile))
		{
		  /*  fprintf(stdout,"%s\n",linea); */
		    if(!line_interpreter(linea, &proc) ) continue;

	/*	    fprintf(stdout,"Processo %d , time %d , DT %d, alive %d\n",
				proc.ClientPid, proc.tempo, proc.DT, proc.alive); */

		    procDB=dataBaseChild(nChild,&proc, procDB); /* build the database */
		} 
     } 
	
  fclose(logFile);
  killSleepings(procDB, cTIMEOUT, argv[2], parent);
/*  while((time(NULL)-tempoAttesa)<cTIMEOUT); */ /* wait */
  sleep(cTIMEOUT);
 }
}

int line_interpreter(char *linea, struct processo *proc)
{
  char *p1, *p2;
  char *pidstr, *timestr;

  	if(!isdigit(linea[0])) return 0; /* it not begin by a digit: is not interesting */
	
	if((p1=strstr(linea, ":"))==NULL)	return 0; /* ":" separator not found  */
	
	if((p2=strstr(linea, "-"))==NULL)	return 0; /* "-" separator not found  */
	
	pidstr=linea;  /* set the string pointers */
	timestr=p1;
	timestr++;

	memset(p1,'\0',1);
	memset(p2,'\0',1);

	proc->ClientPid = atol(pidstr);
	proc->tempo = atol(timestr);
	proc->DT = ((long) time(NULL))- proc->tempo;

	memset(p1,':',1);  /* remove the terminators */
	memset(p2,'-',1);

	p2++;
	if((p2=strstr(p2, "closing the connection"))==NULL) proc->alive=1;
	else proc->alive=0;	

	return 1;
}

struct processo *dataBaseChild(long nChild, struct processo *proc, struct processo *procDB)
{
  struct processo *ptr, *ptr_old;
  short found=0;

  if (procDB==NULL) /* initialize the list */
   {
	if((procDB=malloc(sizeof(struct processo)))==NULL) 
	 {
		fprintf(stderr,"error allocating the DB\n");
		exit(-1);
	 }
	procDB->nextProc=NULL;
   }	

  ptr=procDB;
  found=0;

  while(ptr)
   {
	if(proc->ClientPid == ptr->ClientPid)
  	 {
		ptr->tempo = proc->tempo;
		ptr->DT    = proc->DT;
		ptr->alive = proc->alive;
	      found=1;
	      break; /* exif from the loop */
 	  }
      ptr_old = ptr;
	ptr = ptr->nextProc;
   }

 if (found == 0) /* this process is not in the database, enter it */ 
  {
	if((ptr=malloc(sizeof(struct processo)))==NULL) 
	 {
		fprintf(stderr,"error allocating the DB 2\n");
		exit(-1);
	 }
	ptr_old->nextProc = ptr;
      ptr->ClientPid =  proc->ClientPid;
	ptr->tempo = proc->tempo;
	ptr->DT    = proc->DT;
	ptr->alive = proc->alive;
	ptr->nextProc = NULL;
  }


 return procDB;
}

int killSleepings(struct processo *procDB, long DT, char *fileName, long parent)
{
  struct processo *ptr;
  long i;
  FILE *logFile;

  ptr=procDB;
  i=0;

  if(!(logFile=fopen(fileName,"a")))
    {
      fprintf(stderr,"Cannot open log file %s\n",fileName);
      exit(-1);
    }

  while(ptr)
   {
	if((ptr->DT > DT) && (ptr->alive==1) && (ptr->ClientPid != parent))
	 {
	  fprintf(logFile,"%d:%d- killer process %d is closing the connection \n",
                ptr->ClientPid, (long) time(NULL), (int) getpid());
	  kill (ptr->ClientPid, SIGTERM);
	  i++;
	 }
	ptr = ptr->nextProc;
   }

 fclose(logFile);
 return i;
}

#ifndef FrvSclient
#define FrvSclient
/* 
this version compiles both on Win32 and Unix platform, with or without FRV libraries 
    Changes made by M.Punturo  18/1/2006
	- macro NOFRVLIB to compile without FRVlibaries 
	*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <assert.h>
#include <errno.h>

#ifndef NOFRVLIB
#include <FrameL.h>
#include <Frv.h>
#endif

#include "FrvS.h"

#ifdef WINDOWS
#include <winsock.h>
typedef int ssize_t;
#else
#include <arpa/inet.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netdb.h>
typedef int  SOCKET;
#define INVALID_SOCKET  (-1)
#endif




#define SIZE_RECV_BUFF 4096

/* 16384 */

#ifdef NOFRVLIB
typedef            long FRLONG;
typedef   unsigned long FRULONG;
#include "MatFrVect.h"
#endif

void FrvSinitLogFile(char *filename);
SOCKET FrvSconnect(char *remote_hostname, long port);
int FrvSinterpreter(char *message);
int FrvSIncrFrame(int socket_fd); 

FrVect *FrvSFileIGetAdcNames(int socket_fd); 
FrVect *FrvSGetVect(int socket_fd, char *FrVectName);
FrVect *FrvSFileIGetV(int socket_fd, char *FrVectName, double tStart, double tDuration);
FrVect *FrvSGetVectInternal(int socket_fd, char *FrVectName, 
			    int mode,double tStart, double tDuration);
int FrvSrequest_server(int socket_fd, int command, char *option);
int FrvS_FrIfile(int socket_fd, char *filename);
int FrvS_FileIEnd(int socket_fd);
int FrvS_close_Connection(int socket_fd);
struct FrvS_Frame_info *FrvSFrameInfoDownload(int socket_fd);
double FrSFileITStart(int socket_fd);
double FrSFileITEnd(int socket_fd);
double FrSFileITime(int socket_fd, int StartEnd);
void assignDataSize(int *wSize);

/* windows specific functions */

#ifdef WINDOWS
int InitializeWinsock(WORD wVersionRequested);
void error(char* string);
#endif

#ifdef NOFRVLIB
struct MatFrVect *MatFrVectNew1D(char *name,int type, FRLONG nData, 
                           double dx, char *unitx);
void MatFree(MatFrVect *MatVector);
#endif

#endif


#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netdb.h>
#include <assert.h>
#include <errno.h>
#include <sys/wait.h>
#include <signal.h>
#include <time.h>
#include <FrameL.h>
#include <Frv.h>
#include "FrvS.h"

/* global variables */

FILE *LOGFILE;
short LOG_LEVEL;

struct FrFile *iFile=NULL; /* FrFile pointer */

struct FrameH *frame=NULL; /* frame pointer */

/* function definition */

void timestamp_file();
static void clean_up_child_process(int signal_number);
int frameIncrement(int connection_fd);
int VectUpload(int connection_fd, short *nvect, char **vectNames, 
	       int mode, double tStart, double tDuration);
int Rcv_cmd(char *buffer);
static void my_handle_connection(int connection_fd);
void server_run (struct in_addr local_address, uint16_t port, char *killerString);
pid_t run_Child_killer(char *killerString);
int TOCUpload(int connection_fd);

#define   MAX_MESSAGE_SIZE  255
#define   NMAXVECT 10     /* Max number of vectors */
#define   VECT_NAME_LENGTH 30

#define   CONN_CMD_QUIT     1
#define   CONN_CMD_FILE     2
#define   CONN_CMD_VECTN    3
#define   CONN_CMD_SREAD    4
#define   CONN_CMD_FRAME    5
#define   CONN_CMD_FRFLVEC  6
#define   CONN_CMD_CLFL     7
#define   CONN_CMD_FRINFO   8
#define   CONN_CMD_TSTART   9
#define   CONN_CMD_TEND     10
#define   CONN_CMD_TOC      11 /* TOC */


#define   CONN_CMD_ERR      99

#define   CODE_FILE     1
#define   CODE_VECTN    2
#define   CODE_VECT0    3
#define   CODE_VECTA    4  /* absent vector */
#define   CODE_FILEE    5  /* END file      */
#define   CODE_WCMD     9
#define   CODE_TOC      11 /* TOC */

#define   CODE_CLCN    -99

struct my_info_Vect
{
  char VectName[VECT_NAME_LENGTH];
  unsigned short compress;
  unsigned short VectType;
  unsigned long nData;
  double  step;
};

struct FrvS_Frame_info
{
  char name[VECT_NAME_LENGTH];  /* frame name (experiment name)                 */
  int   run;                    /* run number                                   */
  unsigned int frame;           /* frame number                                 */
  unsigned int dataQuality;     /* data quality word                            */
  unsigned int GTimeS;          /* frame starting Time(GPS:s.since 6/1/80)      */
  unsigned int GTimeN;          /* frame starting Time(nsec modulo 1 sec)       */
  unsigned short ULeapS;        /* leap seconds between GPS and UTC             */
  double dt;                    /* frame duration                               */
};

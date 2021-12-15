/*---------------------------------------------------------------------------*/
/* File: FrVect.h                             Last update:     Dec 09, 2003  */
/*                                                                           */
/* Copyright (C) 2003, B. Mours.                                             */
/* For the licensing terms see the LICENSE file.                             */
/* For the list of contributors see the history section of the documentation */
/*---------------------------------------------------------------------------*/
/*  Modified by M.Punturo                     Last Update:     Jan 18,2006   */

#if !defined(FRVECT_DEFINED)
#define FRVECT_DEFINED


typedef unsigned short  FRVECTTYPES; 

#define MAX_NAME_SIZE 50
             
enum     {FR_VECT_C,     /* vector of char                           */
          FR_VECT_2S,    /* vector of short                          */
          FR_VECT_8R,    /* vector of double                         */
          FR_VECT_4R,    /* vector of float                          */
          FR_VECT_4S,    /* vector of int                            */
          FR_VECT_8S,    /* vector of long                           */
          FR_VECT_8C,    /* vector of complex float                  */
          FR_VECT_16C,   /* vector of complex double                 */
          FR_VECT_STRING,/* vector of string                         */
          FR_VECT_2U,    /* vector of unsigned short                 */
          FR_VECT_4U,    /* vector of unsigned int                   */
          FR_VECT_8U,    /* vector of unsigned long                  */
          FR_VECT_1U,    /* vector of unsigned char                  */
          FR_VECT_8H,    /* halfcomplex vectors (float) (FFTW order) */
          FR_VECT_16H,   /* halfcomplex vectors (double)(FFTW order) */
          FR_VECT_END};  /* vector of unsigned char                  */

#define FR_VECT_C8  FR_VECT_8C
#define FR_VECT_C16 FR_VECT_16C
#define FR_VECT_H8  FR_VECT_8H
#define FR_VECT_H16 FR_VECT_16H

/*---------------------------------------------------------------------------*/

struct MatFrVect {
  
  char          name[MAX_NAME_SIZE];        /* vector name                              */
  unsigned short compress;       /* 0 = no compression; 1 = gzip             */
  FRVECTTYPES    type;           /* vector type  (see below)                 */
  FRULONG        nData;          /* number of elements=nx[0].nx[1]..nx[nDim] */
  FRULONG        nBytes;         /* number of bytes                          */
  char          *data;           /* pointer to the data area.                */
  unsigned int   nDim;           /* number of dimension                      */
  FRULONG nx;                   /* number of element for this dimension     */
  double dx;                    /* step size value (express in above unit)  */

  char   unitX[MAX_NAME_SIZE];                /* unit name for (used for printout)        */

                                 /* ------- end_of_SIO parameters -----------*/
  short  *dataS;                 /* pointer to the data area (same as *data) */
  int    *dataI;                 /* pointer to the data area (same as *data) */
  FRLONG *dataL;                 /* pointer to the data area (same as *data) */
  float  *dataF;                 /* pointer to the data area (same as *data) */
  double *dataD;                 /* pointer to the data area (same as *data) */
  unsigned char  *dataU;         /* pointer to the data area (same as *data) */
  unsigned short *dataUS;        /* pointer to the data area (same as *data) */
  unsigned int   *dataUI;        /* pointer to the data area (same as *data) */
  FRULONG        *dataUL;        /* pointer to the data area (same as *data) */
  char  **dataQ;                 /* pointer to the data area (same as *data) */
};

typedef struct MatFrVect MatFrVect;
typedef struct MatFrVect FrVect;

#endif

















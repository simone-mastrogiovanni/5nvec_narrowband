/*                                                                                                     */
/* This Mex-File is used by SNAG to uncompress data in Vector Data Structures in Frame Format (vers 4) */
/* Supported compression schemes  are:                                                                 */
/*  - gzip (using Zlib) (compression type = 1)                                                         */
/*  - gzip, differential values (compression type = 3)                                                 */
/*  - differentiation and zero suppression for integers types only (compression type = 5)              */
/*  - (compression types 7 and 8)                                                                      */

/* Version 1.0 - October 2001                                                                          */
/* Part of Snag toolbox - Signal and Noise for Gravitational Antennas                                  */
/* Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it                                     */
/*                     Luca Pontisso - luca.pontisso@roma1.infn.it                                     */
/* Department of Physics - Universita` "La Sapienza" - Rome                                            */



#include "mex.h"
#include "matlab.h"
#include "Zlib.h"


/* Following functions are original FrameLib code: FrVectZExpand, FrVectFExpand, FrVectZExpandI */
/* they are used for compatibility with built-in compression schemes */

/*--------------------------------------------------------------------*/

void FrVectZExpand(short *out, unsigned short *data, int nData)

{unsigned short nBits, pIn, uData, *buf, *alpha;
 unsigned short wMax[] = {0,0,1,3,7,0xf,0x1f,0x3f,0x7f,0xff,0x1ff,
                      0x3ff,0x7ff,0xfff,0x1fff,0x3fff,0x7fff};
 unsigned short mask[] = {0,1,3,7,0xf,0x1f,0x3f,0x7f,0xff,0x1ff,
                      0x3ff,0x7ff,0xfff,0x1fff,0x3fff,0x7fff,0xffff};
 unsigned int iBuf, iAlpha;
 int  i, iIn, iOut, bSize;

 /*----- check which indian --------*/

 iAlpha = 0x12345678;
 alpha = (unsigned short *) &iAlpha;

 /*---- retrieve the bloc size -----*/

 bSize = data[0];
 iIn = 1;
 pIn = 0;

 /*--------- retrieve the data  --------------*/

 buf = (unsigned short *) &iBuf; 
 iOut = 0;
 do
    {/*-------- extract nBits -------------
        -----(we check if data is in 1 or 2 words) ------*/
        
    if(pIn <= 12)
       {uData = data[iIn] >> pIn;
        pIn = pIn + 4;}
     else
       {buf[0] = data[iIn];
        iIn++;
        if(alpha[0] == 0x1234)
             {buf[1] = buf[0];
              buf[0] = data[iIn];}
        else {buf[1] = data[iIn];}
        uData = iBuf >> pIn;
        pIn = pIn - 12;}

    nBits = 1 + (mask[4] & uData);
    if(nBits == 1) nBits = 0;

     /*----extract data ----------*/

     for(i=0; i<bSize; i++)
       {if(iOut >= nData) break;

        if(pIn + nBits <= 16)
          {uData = data[iIn] >> pIn;
           pIn = pIn + nBits;}
        else
          {buf[0] = data[iIn];
           iIn++;
           if(alpha[0] == 0x1234)
                {buf[1] = buf[0];
                 buf[0] = data[iIn];}
           else {buf[1] = data[iIn];}  
           uData = iBuf >> pIn;
           pIn = pIn + nBits - 16;}

        out[iOut] = (mask[nBits] & uData) - wMax[nBits];
        iOut++;}}
 while(iOut<nData);

return;}

/*------------------------------------------------------------------------------*/

void FrVectFExpand(float *out, short  *data, int nData)

{int  i;
 float *dataF, scale;

 dataF = (float *) data;
 out[0] = dataF[0];
 scale  = dataF[1];

 if(scale == 0.)
      {for(i=1; i<nData; i++) {out[i] = 0.;}}
 else {for(i=1; i<nData; i++) {out[i] = out[i-1] + scale*data[4+i];}}

return;}

/*----------------------------------------------------------------------*/

void FrVectZExpandI(int *out, unsigned int *data, int nData)

{unsigned short *alpha;
 unsigned int nBits, pIn, uData, *buf;
 unsigned int wMax[] = {0,0,1,3,7,
                 0xf      ,0x1f      ,0x3f      ,0x7f,
                 0xff     ,0x1ff     ,0x3ff     ,0x7ff,
                 0xfff    ,0x1fff    ,0x3fff    ,0x7fff,
                 0xffff   ,0x1ffff   ,0x3ffff   ,0x7ffff,
                 0xfffff  ,0x1fffff  ,0x3fffff  ,0x7fffff,
                 0xffffff ,0x1ffffff ,0x3ffffff ,0x7ffffff,
                 0xfffffff,0x1fffffff,0x3fffffff,0x7fffffff};
 unsigned int mask[] = {0,1,3,      7,       0xf,
              0x1f      ,0x3f      ,0x7f,      0xff,
              0x1ff     ,0x3ff     ,0x7ff,     0xfff,
              0x1fff    ,0x3fff    ,0x7fff,    0xffff,
              0x1ffff   ,0x3ffff   ,0x7ffff,   0xfffff,
              0x1fffff  ,0x3fffff  ,0x7fffff,  0xffffff,
              0x1ffffff ,0x3ffffff ,0x7ffffff, 0xfffffff,
              0x1fffffff,0x3fffffff,0x7fffffff,0xffffffff};
unsigned int iBuf, iAlpha;
 int  i, iIn, iOut, bSize;

 /*----- check which indian --------*/

 iAlpha = 0x12345678;
 alpha = (unsigned short *) &iAlpha;

 /*---- retrieve the bloc size -----*/

 bSize = data[0] & 0xffff;
 iIn = 0;
 pIn = 16;

 /*--------- retrieve the data  --------------*/

 buf = (unsigned int *) &iBuf; 
 iOut = 0;
 do
    {/*-------- extract nBits -(we check if data is in 1 or 2 words) ------*/
        
    if(pIn <= 27)
       {uData = data[iIn] >> pIn;
        pIn = pIn + 5;}
     else
       {uData = (data[iIn] >> pIn) & mask[32-pIn];
        iIn++;
        uData += data[iIn] << (32-pIn);
        pIn = pIn - 27;}

    nBits = 1 + (0x1f & uData);
    if(nBits == 1) nBits = 0;

     /*----extract data ----------*/

     for(i=0; i<bSize; i++)
       {if(iOut >= nData) break;

        if(pIn + nBits <= 32)
          {uData = data[iIn] >> pIn;
           pIn = pIn + nBits;}
        else
          {uData = (data[iIn] >> pIn) & mask[32-pIn];
           iIn++;
           uData += data[iIn] << (32-pIn);
           pIn = pIn + nBits - 32;}

        out[iOut] = (mask[nBits] & uData) - wMax[nBits];
        iOut++;}}
 while(iOut<nData);

return;}

/*-----------------------------------------------------------------------*/
                  /* BEGINNING OF ORIGINAL MATLAB CODE */

void  mexFunction( int nlhs, mxArray *plhs[],
      int nrhs, const mxArray *prhs[])

{ int err, i, k;
  unsigned char *ccompr, *uncompr, *buf, local0, local1, local2, local3;
  unsigned long uncomprLen, comprLen, Typ, typecomp;
  long *dataI32;
  unsigned int *dataUI32;
  char *refC;
  short ref, swap, nData, *dataI16;
  unsigned short *dataUI16, nbType;
  double *data, *dataF64;
  float *dataF32;
  unsigned __int64 *dataUI64;
  __int64 *dataI64;
  
  uncomprLen=(unsigned long)mxGetScalar(prhs[0]);
  ccompr=(unsigned char *)mxGetPr(prhs[1]);
  comprLen=(unsigned long)mxGetScalar(prhs[2]);
  typecomp=(unsigned short)mxGetScalar(prhs[3]);
  nData=(int)mxGetScalar(prhs[4]);
  Typ=(unsigned int)mxGetScalar(prhs[5]);
  nbType=(unsigned short)mxGetScalar(prhs[6]);       /* Allowed values for nbType are 1, 2, 4, 8 bytes
                                                        according to the data type; */
  uncompr=(unsigned char *)mxCalloc((int)uncomprLen,1);
  data=(double *)mxCalloc((int)nData,sizeof(double));
  
  if(uncompr == NULL || data == NULL)
	  {mexErrMsgTxt("malloc failed");
  return;}
  
  /* Check if it is necessary to swap bytes. Code from FrameLib */

  refC=(char *)&ref;   
  ref=0x1234;

  swap=(refC[0] == 0x34 && typecomp < 255) ||
	    (refC[0] == 0x12 && typecomp > 255);

  /*   */

  typecomp=typecomp & 0xff;    /* */

  if(typecomp == 6) typecomp = 5; /* According to FrameLib */
    
  plhs[0]=mxCreateNumericMatrix(1, (int)nData, mxDOUBLE_CLASS, mxREAL); /* Create a double array for
                                                                           the return argument */
  
  if(typecomp == 5) {     /* differentiation and zero suppression for integer types only */
   if(swap)
          {buf = uncompr;
           for(i=0; i<comprLen-1; i=i+2)
              {local0   = buf[i];
               buf[i]   = buf[i+1];
               buf[i+1] = local0;}}
     
   /* dataUI16=(short *)mxCalloc((int)nData,sizeof(short)); */
   /* FrVectZExpand(dataUI16, (unsigned short *)ccompr, nData); */
   FrVectZExpand((short *)uncompr, (unsigned short *)ccompr, nData);
   data=mxGetPr(plhs[0]);
   for(k=0; k<= nData; k++) *(data+k)=*((short *)uncompr+k);
  }
 
  else if(typecomp == 7){      /* built-in FrameLib compression not documented yet */
	  if(swap)
          {buf = uncompr;
	   local0 = buf[3];
           buf[3] = buf[0];
	   buf[0] = local0;
           local0 = buf[2];
           buf[2] = buf[1];
	   buf[1] = local0;
           local0 = buf[7];
           buf[7] = buf[4];
	   buf[4] = local0;
           local0 = buf[6];
           buf[6] = buf[5];
	   buf[5] = local0;
           for(i=8; i<comprLen-1; i=i+2)
              {local0   = buf[i];
               buf[i]   = buf[i+1];
               buf[i+1] = local0;}}
      
       FrVectFExpand((float *) uncompr, (short *)ccompr, nData);
       data=mxGetPr(plhs[0]);
       for(k=0; k<= nData; k++) *(data+k)=*((float *)uncompr+k);
  }
  else if(typecomp == 8) {       /* built-in FrameLib compression not documented yet */
       if(swap)
          {buf = uncompr;
           for(i=0; i<comprLen-3; i=i+4)
              {local0   = buf[i+3];
               local1   = buf[i+2];
               buf[i+3] = buf[i];
               buf[i+2] = buf[i+1];
               buf[i+1] = local1;
               buf[i]   = local0;}}

        FrVectZExpandI((int *)uncompr,(unsigned int *)ccompr,nData);
		data=mxGetPr(plhs[0]);
		for(k=0; k<= nData; k++) *(data+k)=*((int *)uncompr+k);
  }

  else if(typecomp == 1 | typecomp == 3) {     /* standard gzip compression */
	  	  
   err=uncompress(uncompr, &uncomprLen, ccompr, comprLen);
  
   if(err != 0) {
   mexPrintf("Err: %d \n",err);
   exit(1);}
     
if(swap)  /* If it is necessary bytes are swapped after deflating with gzip */

   {if(nbType == 16)  nData = 2*nData; /* For complex data (not implemented yet) */
    buf = uncompr;

    if(nbType == 2)  /* 2 bytes data */
          {for(i=0; i<2*nData; i=i+2)
              {local0   = buf[i];
               buf[i]   = buf[i+1];
               buf[i+1] = local0;}
	}
     
    else if(nbType == 4)  /* 4 bytes data */
       {for(i=0; i<4*nData; i=i+4) 
           {local0 = buf[i];
            local1 = buf[i+1];
            buf[i]   = buf[i+3];
            buf[i+1] = buf[i+2];
            buf[i+2] = local1;
            buf[i+3] = local0;}
	}
	
    else if(nbType == 8)  /* 8 bytes data */
       {for(i=0; i<8*nData; i=i+8)
           {local0 = buf[i];
            local1 = buf[i+1];
            local2 = buf[i+2];
            local3 = buf[i+3];
            buf[i]   = buf[i+7];
            buf[i+1] = buf[i+6];
            buf[i+2] = buf[i+5];
            buf[i+3] = buf[i+4];
            buf[i+4] = local3;
            buf[i+5] = local2;
            buf[i+6] = local1;
            buf[i+7] = local0;}
    }}

  /*   */
    
switch(Typ){      

case 2: /* Uint16 */
	    /* dataUI16=(unsigned short *)mxCalloc((int)nData,sizeof(unsigned short)); */
		dataUI16=(unsigned short *)uncompr; 
        data=mxGetPr(plhs[0]);
		for(k=0; k <= nData-1; k++) *(data+k)=*(dataUI16+k);
	break;


case 10: /* int16 */
	    /* dataI16=(short *)mxCalloc((int)nData,sizeof(short)); */
		dataI16=(short *)uncompr; 
	    data=mxGetPr(plhs[0]);
		for(k=0; k <= nData-1 ;k++) *(data+k)=*(dataI16+k);
	break;


case 4:  /* float32 */
	   /* dataF32=(float *)mxCalloc((int)nData,sizeof(float)); */
		dataF32=(float *)uncompr; 
        data=mxGetPr(plhs[0]);
	   	for(k=0;k <= nData-1;k++) *(data+k)=*(dataF32+k);
		 
	break;


case 5:  /* int32 */
	    /* dataI32=(int *)mxCalloc((int)nData,sizeof(int)); */
		dataI32=(int *)uncompr; 
        data=mxGetPr(plhs[0]);
		for(k=0; k <= nData-1; k++) *(data+k)=*(dataI32+k);
	break;

case 11: /* Uint32 */
	    /* dataUI32=(unsigned int *)mxCalloc((int)nData,sizeof(unsigned int)); */
		dataUI32=(unsigned int *)uncompr; 
		data=mxGetPr(plhs[0]);
		for(k=0; k <= nData-1; k++) *(data+k)=*(dataUI32+k);
	break;


case 3:  /* float64 */
	    /* dataF64=(double *)mxCalloc((int)nData,sizeof(double)); */
		dataF64=(double *)uncompr; 
		data=mxGetPr(plhs[0]);
		for(k=0; k <= nData-1; k++) *(data+k)=*(dataF64+k);
	break;


case 6:  /* int64 */
	    /* dataI64=(__int64 *)mxCalloc((int)nData,sizeof(__int64)); */
		dataI64=(__int64 *)uncompr; 
		data=mxGetPr(plhs[0]);
		for(k=0; k <= nData-1; k++) *(data+k)=*(dataI64+k);
	break;

case 12: /* Uint64 */
	    /* dataUI64=(unsigned __int64 *)mxCalloc((int)nData,sizeof(unsigned __int64)); */
		dataUI64=(unsigned __int64 *)uncompr; 
		data=mxGetPr(plhs[0]);
		for(k=0; k <= nData-1; k++) *(data+k)=*(dataUI64+k);
	break;
default:
	    mexPrintf("Unknown Data Type: %d\n",typecomp);
		exit(1);
}}
	
	return;
}

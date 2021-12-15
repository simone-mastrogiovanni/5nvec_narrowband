#include "mex.h"
#include "matrix.h"
#include "../FrvSclient.c"
#include <stdio.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 mxArray *inVectName, *in_fd, *in_Tstart, *in_Tend;
 int inLength, i;
 char *Vect_name;
 SOCKET fd; 			/* "file" descriptor for the network socket  */
 double *outData;
 MatFrVect *ans;
 

 in_fd =  prhs[0];
 inVectName = prhs[1];
 
/* Check for proper number of arguments. */
  if (nrhs != 2) {
    mexErrMsgTxt("Two inputs required: socket, VectName");
  } else if (nlhs > 3) {
    mexErrMsgTxt("Too many output arguments");
  }
 
/* evaluate the string lenght */
 inLength = mxGetN(inVectName)+1;
 Vect_name = mxCalloc(inLength,sizeof(char));
 mxGetString(inVectName,Vect_name,inLength);

 fd = (SOCKET) mxGetScalar(in_fd);
 
 
 if ((ans=FrvSGetVect(fd, Vect_name)) == NULL ) printf("Error reading remote vector\n");
 
 /* printf("ndata %d, dx %f, type %d\n",ans->nData, ans->dx, ans->type); */
 
 plhs[0]=mxCreateDoubleScalar((double) ans->nData);  /* number of data */
 plhs[1]=mxCreateDoubleScalar((double) ans->dx);  /* dx */
 plhs[2]=mxCreateDoubleMatrix(ans->nData,1, mxREAL);
 
 
 outData = mxGetPr(plhs[2]);
 
 for (i=0; i< ans->nData; i++)
     {
  /*       if (i<10) printf("%e\n",ans->dataF[i]);
         outData[i] = (double) ans->dataF[i]; */
         
         
         switch (ans->type)
          {
              case FR_VECT_4R:
                  outData[i] = (double) ans->dataF[i]; break;
             case FR_VECT_8R:
                  outData[i] = (double) ans->dataD[i]; break;
             case FR_VECT_C:
             case FR_VECT_1U:
                  outData[i] = (double) ans->data[i]; break;
             case FR_VECT_2S:
                  outData[i] = (double) ans->dataS[i]; break;
             case FR_VECT_2U:
                  outData[i] = (double) ans->dataUS[i]; break;
             case FR_VECT_4S:
                  outData[i] = (double) ans->dataI[i]; break;
             case FR_VECT_4U:
                  outData[i] = (double) ans->dataUI[i]; break;
             case FR_VECT_8S:
                  outData[i] = (double) ans->dataL[i]; break;
             case FR_VECT_8U:
                  outData[i] = (double) ans->dataUL[i]; break;
          }    
         
        
     } 
/*  FrvS_close_Connection(fd); */
 MatFree(ans);
 mxFree(Vect_name);
return;
}





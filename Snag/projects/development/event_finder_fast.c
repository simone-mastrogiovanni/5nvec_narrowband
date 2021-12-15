static char mc_version[] = "MATLAB Compiler 1.2 Jan 17 1998 infun";
/*
 *  MATLAB Compiler: 1.2
 *  Date: Jan 17 1998
 *  Arguments: -ir event_finder_fast 
 */
#ifndef ARRAY_ACCESS_INLINING
#error You must use the -inline option when compiling MATLAB compiler generated code with MEX or MBUILD
#endif
#ifndef MATLAB_COMPILER_GENERATED_CODE
#define MATLAB_COMPILER_GENERATED_CODE
#endif

#include <math.h>
#include "mex.h"
#include "mcc.h"

/* static array S0_ (1 x 14) text, line 67: 'E:\Data\Prova\' */
static unsigned short S0__r_[] =
{
         69,   58,   92,   68,   97,  116,   97,   92,
         80,  114,  111,  118,   97,   92,
};
static mxArray S0_ = mccCINIT( mccTEXT,  1, 14, S0__r_, 0);
/* static array S1_ (1 x 14) text, line 68: 'E:\Data\Prova\' */
static unsigned short S1__r_[] =
{
         69,   58,   92,   68,   97,  116,   97,   92,
         80,  114,  111,  118,   97,   92,
};
static mxArray S1_ = mccCINIT( mccTEXT,  1, 14, S1__r_, 0);
/* static array S2_ (1 x 1) text, line 78: 'w' */
static unsigned short S2__r_[] =
{
        119,
};
static mxArray S2_ = mccCINIT( mccTEXT,  1, 1, S2__r_, 0);
/* static array S3_ (1 x 1) text, line 79: 'w' */
static unsigned short S3__r_[] =
{
        119,
};
static mxArray S3_ = mccCINIT( mccTEXT,  1, 1, S3__r_, 0);
/* static array S4_ (1 x 1) text, line 83: 'a' */
static unsigned short S4__r_[] =
{
         97,
};
static mxArray S4_ = mccCINIT( mccTEXT,  1, 1, S4__r_, 0);
/* static array S5_ (1 x 1) text, line 84: 'a' */
static unsigned short S5__r_[] =
{
         97,
};
static mxArray S5_ = mccCINIT( mccTEXT,  1, 1, S5__r_, 0);
/* static array S6_ (1 x 29) text, line 188: '%d %f %f %f %f %f %f %f %...' */
static unsigned short S6__r_[] =
{
         37,  100,   32,   37,  102,   32,   37,  102,
         32,   37,  102,   32,   37,  102,   32,   37,
        102,   32,   37,  102,   32,   37,  102,   32,
         37,  102,   32,   92,  110,
};
static mxArray S6_ = mccCINIT( mccTEXT,  1, 29, S6__r_, 0);
/* static array S7_ (1 x 11) text, line 198: '%f %f %f \n' */
static unsigned short S7__r_[] =
{
         37,  102,   32,   37,  102,   32,   37,  102,
         32,   92,  110,
};
static mxArray S7_ = mccCINIT( mccTEXT,  1, 11, S7__r_, 0);
/* static array S8_ (1 x 11) text, line 202: '%f %f %f \n' */
static unsigned short S8__r_[] =
{
         37,  102,   32,   37,  102,   32,   37,  102,
         32,   92,  110,
};
static mxArray S8_ = mccCINIT( mccTEXT,  1, 11, S8__r_, 0);
/***************** Compiler Assumptions ****************
 *
 *       BM0_        	boolean vector/matrix temporary
 *       I0_         	integer scalar temporary
 *       R0_         	real scalar temporary
 *       RM0_        	real vector/matrix temporary
 *       RM1_        	real vector/matrix temporary
 *       abs         	<function>
 *       armean      	real vector/matrix
 *       arstdev     	real vector/matrix
 *       cr          	real vector/matrix
 *       creven      	real vector/matrix
 *       detim       	real scalar
 *       detimcount  	real vector/matrix
 *       dt          	real scalar
 *       elen        	real vector/matrix
 *       emax        	real scalar
 *       event_finder_fast	<function being defined>
 *       exp         	<function>
 *       fclose      	<function>
 *       fidev       	string vector/matrix
 *       fidev       	integer scalar  => fidev_1
 *       fidev       	real scalar  => fidev_2
 *       fidst       	string vector/matrix
 *       fidst       	integer scalar  => fidst_1
 *       fidst       	real scalar  => fidst_2
 *       fileev      	real vector/matrix
 *       filest      	real vector/matrix
 *       folder      	real vector/matrix
 *       fopen       	<function>
 *       fprintf     	<function>
 *       i           	integer scalar
 *       ieven       	real vector/matrix
 *       ieven1      	real vector/matrix
 *       ii          	real vector/matrix
 *       imeven      	real vector/matrix
 *       imeven1     	real vector/matrix
 *       iseven      	real vector/matrix
 *       iseven1     	real vector/matrix
 *       istatim     	real scalar
 *       lastatim    	real scalar
 *       len         	integer scalar
 *       length      	<function>
 *       mode        	real vector/matrix
 *       nev         	real vector/matrix
 *       norm        	real vector/matrix
 *       r           	real vector/matrix
 *       realsqrt    	<function>
 *       rmean       	real vector/matrix
 *       rr          	real vector/matrix
 *       rstdev      	real vector/matrix
 *       s           	real vector/matrix
 *       scount      	real vector/matrix
 *       ss          	real vector/matrix
 *       stat        	real vector/matrix
 *       statim      	real scalar
 *       thresh      	real scalar
 *       tim         	real scalar
 *       timax       	real scalar
 *       timbias     	real scalar
 *       tinit       	real scalar
 *       w           	real scalar
 *       y           	real vector/matrix
 *       yy          	real vector/matrix
 *******************************************************/

void
mexFunction(
    int nlhs_,
    mxArray *plhs_[],
    int nrhs_,
    const mxArray *prhs_[]
)
{
   mxArray *Mplhs_[1];
   mxArray *Mprhs_[11];
   

   if (nrhs_ > 6 )
   {
      mexErrMsgTxt( "Too many input arguments." );
   }

   if (nlhs_ > 1 )
   {
      mexErrMsgTxt( "Too many output arguments." );
   }

   {
      mxArray stat;
      mxArray y;
      mxArray mode;
      mxArray folder;
      mxArray fileev;
      mxArray filest;
      mxArray fidev;
      mxArray fidst;
      double w = 0.0;
      int i = 0;
      int fidev_1 = 0;
      int fidst_1 = 0;
      double tinit = 0.0;
      double dt = 0.0;
      int len = 0;
      double thresh = 0.0;
      double detim = 0.0;
      double statim = 0.0;
      double timbias = 0.0;
      double istatim = 0.0;
      mxArray s;
      mxArray ss;
      mxArray r;
      mxArray rr;
      mxArray ii;
      mxArray detimcount;
      double lastatim = 0.0;
      mxArray scount;
      mxArray norm;
      double tim = 0.0;
      int tim_set_ = 0;
      int tim_flags_ = 0;
      mxArray elen;
      double emax = 0.0;
      int emax_set_ = 0;
      int emax_flags_ = 0;
      mxArray ieven;
      mxArray iseven;
      mxArray imeven;
      double timax = 0.0;
      int timax_set_ = 0;
      int timax_flags_ = 0;
      mxArray creven;
      mxArray nev;
      double fidev_2 = 0.0;
      int fidev_2_set_ = 0;
      double fidst_2 = 0.0;
      int fidst_2_set_ = 0;
      mxArray ieven1;
      mxArray iseven1;
      mxArray imeven1;
      mxArray yy;
      mxArray cr;
      mxArray armean;
      mxArray arstdev;
      mxArray rmean;
      mxArray rstdev;
      int I0_ = 0;
      double R0_ = 0.0;
      mxArray RM0_;
      mxArray RM1_;
      mxArray BM0_;
      
      mccRealInit(y);
      mccImport(&y, ((nrhs_>0) ? prhs_[0] : 0), 0, 0);
      mccRealInit(mode);
      mccImport(&mode, ((nrhs_>1) ? prhs_[1] : 0), 0, 0);
      mccRealInit(stat);
      mccImportCopy(&stat, ((nrhs_>2) ? prhs_[2] : 0), 0, 0);
      mccRealInit(folder);
      mccImport(&folder, ((nrhs_>3) ? prhs_[3] : 0), 0, 0);
      mccRealInit(fileev);
      mccImport(&fileev, ((nrhs_>4) ? prhs_[4] : 0), 0, 0);
      mccRealInit(filest);
      mccImport(&filest, ((nrhs_>5) ? prhs_[5] : 0), 0, 0);
      mccTextInit(fidev);
      mccTextInit(fidst);
      mccRealInit(s);
      mccRealInit(ss);
      mccRealInit(r);
      mccRealInit(rr);
      mccRealInit(ii);
      mccRealInit(detimcount);
      mccRealInit(scount);
      mccRealInit(norm);
      mccRealInit(elen);
      mccRealInit(ieven);
      mccRealInit(iseven);
      mccRealInit(imeven);
      mccRealInit(creven);
      mccRealInit(nev);
      mccRealInit(ieven1);
      mccRealInit(iseven1);
      mccRealInit(imeven1);
      mccRealInit(yy);
      mccRealInit(cr);
      mccRealInit(armean);
      mccRealInit(arstdev);
      mccRealInit(rmean);
      mccRealInit(rstdev);
      mccRealInit(RM0_);
      mccRealInit(RM1_);
      mccBoolInit(BM0_);
      
      /* % DS/EVENT_FINDER_fast  event finder on an array */
      
      /* % The function can be used iteratively. */
      
      /* % y      input array (typically from a non-interlaced ds) */
      
      /* % mode   mode vector (input): */
      /* % mode(1) = 0 no event */
      /* % = 1 find events */
      /* % = 2 also shape of events */
      /* % mode(2) = 0 no statistics */
      /* % = 1 AR statistics */
      /* % = 2 rectangular statistics */
      /* % mode(3) = initial time (in days) */
      /* % mode(4) = dt (in seconds) */
      /* % mode(5) = tau (in seconds) */
      /* % mode(6) = CR threshold */
      /* % mode(7) = dead time (in seconds) */
      /* % mode(8) = statistics sampling time (seconds; e.g. 60) */
      /* % mode(9) = time bias; */
      
      /* % stat   status vector (to be zeroed before start) */
      /* % stat(1) = AR sum on x  */
      /* % stat(2) = AR sum on x^2 */
      /* % stat(3) = sum on x */
      /* % stat(4) = sum on x^2 */
      /* % stat(5) = iteration index */
      /* % stat(6) = dead time counter; */
      /* % stat(7) = last statistics time !! DA USARE POI */
      /* % stat(8) = statistics counter */
      /* % stat(9) = w */
      /* % stat(10)= AR sum on 1 */
      /* % stat(11)= status (0 normal; 1 event) */
      /* % stat(12)= event beginning time */
      /* % stat(13)= max amplitude */
      /* % stat(14)= event length */
      /* % stat(15)= integral */
      /* % stat(16)= integral square */
      /* % stat(17)= integral modulus */
      /* % stat(18)= event max time */
      /* % stat(19)= event CR */
      /* % stat(20)= number of events */
      /* % stat(21)= event file id */
      /* % stat(22)= statistics file id */
      /* % stat(23)=  */
      /* % stat(24)=  */
      /* % stat(25)= integral (last samples) */
      /* % stat(26)= integral square (last samples) */
      /* % stat(27)= integral modulus (last samples) */
      /* % stat(28)=  */
      /* % stat(29)=  */
      /* % stat(30)=  */
      
      /* % folder  where to put files */
      
      /* % fileev  events file */
      
      /* % filest  statistics file */
      
      /* % Version 1.0 - March 1999 */
      /* % Part of Snag toolbox - Signal and Noise for Gravitational Antennas */
      /* % Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it */
      /* % Department of Physics - Universita` "La Sapienza" - Rome */
      
      /* % snag_local_symbols; */
      /* fidev=['E:\Data\Prova\' fileev]; */
      if(mccNOTSET(&fileev))
      {
         mexErrMsgTxt( "variable fileev undefined, line 67" );
      }
      mccCatenateColumns(&fidev, &S0_, &fileev);
      /* fidst=['E:\Data\Prova\' filest]; */
      if(mccNOTSET(&filest))
      {
         mexErrMsgTxt( "variable filest undefined, line 68" );
      }
      mccCatenateColumns(&fidst, &S1_, &filest);
      
      /* if stat(5) == 0 */
      if(mccNOTSET(&stat))
      {
         mexErrMsgTxt( "variable stat undefined, line 70" );
      }
      if (( ((mccPR(&stat)[(5-1)]) == 0) && !mccREL_NAN((mccPR(&stat)[(5-1)])) ))
      {
         /* w=exp(-mode(4)/mode(5)); */
         if(mccNOTSET(&mode))
         {
            mexErrMsgTxt( "variable mode undefined, line 71" );
         }
         if(mccNOTSET(&mode))
         {
            mexErrMsgTxt( "variable mode undefined, line 71" );
         }
         w = exp(((-(mccPR(&mode)[(4-1)])) / (double) (mccPR(&mode)[(5-1)])));
         /* for i = 1:22 */
         for (I0_ = 1; I0_ <= 22; I0_ = I0_ + 1)
         {
            i = I0_;
            /* stat(i)=0; */
            mccPR(&stat)[(i-1)] = 0;
            /* end */
         }
         
         /* stat(9)=w; */
         mccPR(&stat)[(9-1)] = w;
         
         /* fidev=fopen(fidev,'w'); */
         Mprhs_[0] = &fidev;
         Mprhs_[1] = &S2_;
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 2, Mprhs_, "fopen", 78);
         fidev_1 = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (event_finder_fast, line 78): fidev_1");
         /* fidst=fopen(fidst,'w'); */
         Mprhs_[0] = &fidst;
         Mprhs_[1] = &S3_;
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 2, Mprhs_, "fopen", 79);
         fidst_1 = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (event_finder_fast, line 79): fidst_1");
         /* stat(21)=fidev; */
         mccPR(&stat)[(21-1)] = fidev_1;
         /* stat(22)=fidst; */
         mccPR(&stat)[(22-1)] = fidst_1;
      }
      else
      {
         /* else */
         /* fidev=fopen(fidev,'a'); */
         Mprhs_[0] = &fidev;
         Mprhs_[1] = &S4_;
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 2, Mprhs_, "fopen", 83);
         fidev_1 = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (event_finder_fast, line 83): fidev_1");
         /* fidst=fopen(fidst,'a'); */
         Mprhs_[0] = &fidst;
         Mprhs_[1] = &S5_;
         Mplhs_[0] = 0;
         mccCallMATLAB(1, Mplhs_, 2, Mprhs_, "fopen", 84);
         fidst_1 = mccImportReal(0, 0, Mplhs_[ 0 ], 1, " (event_finder_fast, line 84): fidst_1");
         /* end */
      }
      
      /* tinit=mode(3); */
      if(mccNOTSET(&mode))
      {
         mexErrMsgTxt( "variable mode undefined, line 87" );
      }
      tinit = (mccPR(&mode)[(3-1)]);
      /* dt=mode(4); */
      dt = (mccPR(&mode)[(4-1)]);
      /* len=length(y); */
      if(mccNOTSET(&y))
      {
         mexErrMsgTxt( "variable y undefined, line 89" );
      }
      len = mccGetLength(&y);
      /* thresh=mode(6); */
      thresh = (mccPR(&mode)[(6-1)]);
      /* detim=mode(7); */
      detim = (mccPR(&mode)[(7-1)]);
      /* statim=mode(8); */
      statim = (mccPR(&mode)[(8-1)]);
      /* timbias=mode(9); */
      timbias = (mccPR(&mode)[(9-1)]);
      /* istatim=statim/dt;  %  ATTENZIONE, migliorare ! */
      istatim = (statim / (double) dt);
      
      /* w=stat(9); */
      w = (mccPR(&stat)[(9-1)]);
      /* s=stat(1); */
      {
         double tr_ = (mccPR(&stat)[(1-1)]);
         mccAllocateMatrix(&s, 1, 1);
         *mccPR(&s) = tr_;
      }
      /* ss=stat(2); */
      {
         double tr_ = (mccPR(&stat)[(2-1)]);
         mccAllocateMatrix(&ss, 1, 1);
         *mccPR(&ss) = tr_;
      }
      /* r=stat(3); */
      {
         double tr_ = (mccPR(&stat)[(3-1)]);
         mccAllocateMatrix(&r, 1, 1);
         *mccPR(&r) = tr_;
      }
      /* rr=stat(4); */
      {
         double tr_ = (mccPR(&stat)[(4-1)]);
         mccAllocateMatrix(&rr, 1, 1);
         *mccPR(&rr) = tr_;
      }
      /* ii=stat(5); */
      {
         double tr_ = (mccPR(&stat)[(5-1)]);
         mccAllocateMatrix(&ii, 1, 1);
         *mccPR(&ii) = tr_;
      }
      /* detimcount=stat(6); */
      {
         double tr_ = (mccPR(&stat)[(6-1)]);
         mccAllocateMatrix(&detimcount, 1, 1);
         *mccPR(&detimcount) = tr_;
      }
      /* lastatim=stat(7); */
      lastatim = (mccPR(&stat)[(7-1)]);
      /* scount=stat(8); */
      {
         double tr_ = (mccPR(&stat)[(8-1)]);
         mccAllocateMatrix(&scount, 1, 1);
         *mccPR(&scount) = tr_;
      }
      /* norm=stat(10); */
      {
         double tr_ = (mccPR(&stat)[(10-1)]);
         mccAllocateMatrix(&norm, 1, 1);
         *mccPR(&norm) = tr_;
      }
      
      /* tim=stat(12); */
      tim = (mccPR(&stat)[(12-1)]);
      if (mccLOG(&stat))
      {
         tim_flags_ |= MCC_LOGICAL;
      }
      else
      {
         tim_flags_ &= ~MCC_LOGICAL;
      }
      tim_set_ = mccSTRING(&stat) ? mccTEXT : mccREAL;
      /* elen=stat(13); */
      {
         double tr_ = (mccPR(&stat)[(13-1)]);
         mccAllocateMatrix(&elen, 1, 1);
         *mccPR(&elen) = tr_;
      }
      /* emax=stat(14); */
      emax = (mccPR(&stat)[(14-1)]);
      if (mccLOG(&stat))
      {
         emax_flags_ |= MCC_LOGICAL;
      }
      else
      {
         emax_flags_ &= ~MCC_LOGICAL;
      }
      emax_set_ = mccSTRING(&stat) ? mccTEXT : mccREAL;
      /* ieven=stat(15); */
      {
         double tr_ = (mccPR(&stat)[(15-1)]);
         mccAllocateMatrix(&ieven, 1, 1);
         *mccPR(&ieven) = tr_;
      }
      /* iseven=stat(16); */
      {
         double tr_ = (mccPR(&stat)[(16-1)]);
         mccAllocateMatrix(&iseven, 1, 1);
         *mccPR(&iseven) = tr_;
      }
      /* imeven=stat(17); */
      {
         double tr_ = (mccPR(&stat)[(17-1)]);
         mccAllocateMatrix(&imeven, 1, 1);
         *mccPR(&imeven) = tr_;
      }
      /* timax=stat(18); */
      timax = (mccPR(&stat)[(18-1)]);
      if (mccLOG(&stat))
      {
         timax_flags_ |= MCC_LOGICAL;
      }
      else
      {
         timax_flags_ &= ~MCC_LOGICAL;
      }
      timax_set_ = mccSTRING(&stat) ? mccTEXT : mccREAL;
      /* creven=stat(19); */
      {
         double tr_ = (mccPR(&stat)[(19-1)]);
         mccAllocateMatrix(&creven, 1, 1);
         *mccPR(&creven) = tr_;
      }
      mccLOG(&creven) = mccLOG(&stat);
      mccSTRING(&creven) = mccSTRING(&stat);
      /* nev=stat(20); */
      {
         double tr_ = (mccPR(&stat)[(20-1)]);
         mccAllocateMatrix(&nev, 1, 1);
         *mccPR(&nev) = tr_;
      }
      mccLOG(&nev) = mccLOG(&stat);
      mccSTRING(&nev) = mccSTRING(&stat);
      
      /* fidev=stat(21); */
      fidev_2 = (mccPR(&stat)[(21-1)]);
      fidev_2_set_ = mccSTRING(&stat) ? mccTEXT : mccREAL;
      /* fidst=stat(22); */
      fidst_2 = (mccPR(&stat)[(22-1)]);
      fidst_2_set_ = mccSTRING(&stat) ? mccTEXT : mccREAL;
      
      /* ieven1=stat(25); */
      {
         double tr_ = (mccPR(&stat)[(25-1)]);
         mccAllocateMatrix(&ieven1, 1, 1);
         *mccPR(&ieven1) = tr_;
      }
      /* iseven1=stat(26); */
      {
         double tr_ = (mccPR(&stat)[(26-1)]);
         mccAllocateMatrix(&iseven1, 1, 1);
         *mccPR(&iseven1) = tr_;
      }
      /* imeven1=stat(27); */
      {
         double tr_ = (mccPR(&stat)[(27-1)]);
         mccAllocateMatrix(&imeven1, 1, 1);
         *mccPR(&imeven1) = tr_;
      }
      
      /* yy=y.^2; */
      {
         int i_, j_;
         int m_=1, n_=1, cx_ = 0;
         double *p_yy;
         int I_yy=1;
         double *p_y;
         int I_y=1;
         m_ = mcmCalcResultSize(m_, &n_, mccM(&y), mccN(&y));
         mccAllocateMatrix(&yy, m_, n_);
         I_yy = (mccM(&yy) != 1 || mccN(&yy) != 1);
         p_yy = mccPR(&yy);
         I_y = (mccM(&y) != 1 || mccN(&y) != 1);
         p_y = mccPR(&y);
         if (m_ != 0)
         {
            for (j_=0; j_<n_; ++j_)
            {
               for (i_=0; i_<m_; ++i_, p_yy+=I_yy, p_y+=I_y)
               {
                  *p_yy = mcmRealPowerInt(*p_y, 2);
               }
            }
         }
      }
      
      /* % y1=zeros(1,len); */
      /* % y2=zeros(1,len); */
      /* cr=0; */
      {
         double tr_ = 0;
         mccAllocateMatrix(&cr, 1, 1);
         *mccPR(&cr) = tr_;
      }
      
      /* for i = 1:len */
      for (I0_ = 1; I0_ <= len; I0_ = I0_ + 1)
      {
         i = I0_;
         /* ii=ii+1; */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_ii;
            int I_ii=1;
            double *p_1ii;
            int I_1ii=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&ii), mccN(&ii));
            mccAllocateMatrix(&ii, m_, n_);
            I_ii = (mccM(&ii) != 1 || mccN(&ii) != 1);
            p_ii = mccPR(&ii);
            I_1ii = (mccM(&ii) != 1 || mccN(&ii) != 1);
            p_1ii = mccPR(&ii);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_ii+=I_ii, p_1ii+=I_1ii)
                  {
                     *p_ii = (*p_1ii + 1);
                  }
               }
            }
         }
         /* s=y(i)+w*s; */
         R0_ = (mccPR(&y)[(i-1)]);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_s;
            int I_s=1;
            double *p_1s;
            int I_1s=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&s), mccN(&s));
            mccAllocateMatrix(&s, m_, n_);
            I_s = (mccM(&s) != 1 || mccN(&s) != 1);
            p_s = mccPR(&s);
            I_1s = (mccM(&s) != 1 || mccN(&s) != 1);
            p_1s = mccPR(&s);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_s+=I_s, p_1s+=I_1s)
                  {
                     *p_s = (R0_ + (w * (double) *p_1s));
                  }
               }
            }
         }
         /* ss=yy(i)+w*ss; */
         R0_ = (mccPR(&yy)[(i-1)]);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_ss;
            int I_ss=1;
            double *p_1ss;
            int I_1ss=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&ss), mccN(&ss));
            mccAllocateMatrix(&ss, m_, n_);
            I_ss = (mccM(&ss) != 1 || mccN(&ss) != 1);
            p_ss = mccPR(&ss);
            I_1ss = (mccM(&ss) != 1 || mccN(&ss) != 1);
            p_1ss = mccPR(&ss);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_ss+=I_ss, p_1ss+=I_1ss)
                  {
                     *p_ss = (R0_ + (w * (double) *p_1ss));
                  }
               }
            }
         }
         /* norm=1+w*norm; */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_norm;
            int I_norm=1;
            double *p_1norm;
            int I_1norm=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&norm), mccN(&norm));
            mccAllocateMatrix(&norm, m_, n_);
            I_norm = (mccM(&norm) != 1 || mccN(&norm) != 1);
            p_norm = mccPR(&norm);
            I_1norm = (mccM(&norm) != 1 || mccN(&norm) != 1);
            p_1norm = mccPR(&norm);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_norm+=I_norm, p_1norm+=I_1norm)
                  {
                     *p_norm = (1 + (w * (double) *p_1norm));
                  }
               }
            }
         }
         /* armean=s/norm; */
         mccRealRightDivide(&armean, &s, &norm);
         /* arstdev=sqrt((ss-(s.*s)./norm)/norm); */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_RM0_;
            int I_RM0_=1;
            double *p_ss;
            int I_ss=1;
            double *p_s;
            int I_s=1;
            double *p_1s;
            int I_1s=1;
            double *p_norm;
            int I_norm=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&ss), mccN(&ss));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&s), mccN(&s));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&s), mccN(&s));
            m_ = mcmCalcResultSize(m_, &n_, mccM(&norm), mccN(&norm));
            mccAllocateMatrix(&RM0_, m_, n_);
            I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
            p_RM0_ = mccPR(&RM0_);
            I_ss = (mccM(&ss) != 1 || mccN(&ss) != 1);
            p_ss = mccPR(&ss);
            I_s = (mccM(&s) != 1 || mccN(&s) != 1);
            p_s = mccPR(&s);
            I_1s = (mccM(&s) != 1 || mccN(&s) != 1);
            p_1s = mccPR(&s);
            I_norm = (mccM(&norm) != 1 || mccN(&norm) != 1);
            p_norm = mccPR(&norm);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_ss+=I_ss, p_s+=I_s, p_1s+=I_1s, p_norm+=I_norm)
                  {
                     *p_RM0_ = (*p_ss - ((*p_s * (double) *p_1s) / (double) *p_norm));
                  }
               }
            }
         }
         mccRealRightDivide(&RM1_, &RM0_, &norm);
         mccSqrt(&arstdev, &RM1_);
         /* % y1(i)=armean; */
         /* % y2(i)=arstdev; */
         /* r=y(i)+r; */
         R0_ = (mccPR(&y)[(i-1)]);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_r;
            int I_r=1;
            double *p_1r;
            int I_1r=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&r), mccN(&r));
            mccAllocateMatrix(&r, m_, n_);
            I_r = (mccM(&r) != 1 || mccN(&r) != 1);
            p_r = mccPR(&r);
            I_1r = (mccM(&r) != 1 || mccN(&r) != 1);
            p_1r = mccPR(&r);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_r+=I_r, p_1r+=I_1r)
                  {
                     *p_r = (R0_ + *p_1r);
                  }
               }
            }
         }
         /* rr=yy(i)+rr; */
         R0_ = (mccPR(&yy)[(i-1)]);
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            double *p_rr;
            int I_rr=1;
            double *p_1rr;
            int I_1rr=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&rr), mccN(&rr));
            mccAllocateMatrix(&rr, m_, n_);
            I_rr = (mccM(&rr) != 1 || mccN(&rr) != 1);
            p_rr = mccPR(&rr);
            I_1rr = (mccM(&rr) != 1 || mccN(&rr) != 1);
            p_1rr = mccPR(&rr);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_rr+=I_rr, p_1rr+=I_1rr)
                  {
                     *p_rr = (R0_ + *p_1rr);
                  }
               }
            }
         }
         
         /* if arstdev > 0 */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM0_;
            int I_BM0_=1;
            double *p_arstdev;
            int I_arstdev=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&arstdev), mccN(&arstdev));
            mccAllocateMatrix(&BM0_, m_, n_);
            I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
            p_BM0_ = mccSPR(&BM0_);
            I_arstdev = (mccM(&arstdev) != 1 || mccN(&arstdev) != 1);
            p_arstdev = mccPR(&arstdev);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_arstdev+=I_arstdev)
                  {
                     *p_BM0_ = ( (*p_arstdev > 0) && !mccREL_NAN(*p_arstdev) );
                  }
               }
            }
         }
         if (mccIfCondition(&BM0_))
         {
            /* cr=abs(y(i)-armean)/arstdev; */
            R0_ = (mccPR(&y)[(i-1)]);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_RM1_;
               int I_RM1_=1;
               double *p_armean;
               int I_armean=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&armean), mccN(&armean));
               mccAllocateMatrix(&RM1_, m_, n_);
               I_RM1_ = (mccM(&RM1_) != 1 || mccN(&RM1_) != 1);
               p_RM1_ = mccPR(&RM1_);
               I_armean = (mccM(&armean) != 1 || mccN(&armean) != 1);
               p_armean = mccPR(&armean);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_RM1_+=I_RM1_, p_armean+=I_armean)
                     {
                        *p_RM1_ = (R0_ - *p_armean);
                     }
                  }
               }
            }
            mccAbs(&RM0_, &RM1_);
            mccRealRightDivide(&cr, &RM0_, &arstdev);
            /* end */
         }
         
         /* if cr >= thresh */
         {
            int i_, j_;
            int m_=1, n_=1, cx_ = 0;
            unsigned short *p_BM0_;
            int I_BM0_=1;
            double *p_cr;
            int I_cr=1;
            m_ = mcmCalcResultSize(m_, &n_, mccM(&cr), mccN(&cr));
            mccAllocateMatrix(&BM0_, m_, n_);
            I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
            p_BM0_ = mccSPR(&BM0_);
            I_cr = (mccM(&cr) != 1 || mccN(&cr) != 1);
            p_cr = mccPR(&cr);
            if (m_ != 0)
            {
               for (j_=0; j_<n_; ++j_)
               {
                  for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_cr+=I_cr)
                  {
                     *p_BM0_ = ( (*p_cr >= thresh) && !mccREL_NAN(*p_cr) && !mccREL_NAN(thresh) );
                  }
               }
            }
         }
         if (mccIfCondition(&BM0_))
         {
            /* if stat(10) == 0 */
            if (( ((mccPR(&stat)[(10-1)]) == 0) && !mccREL_NAN((mccPR(&stat)[(10-1)])) ))
            {
               /* tim=tinit-timbias+(i-1)*dt/86400; */
               tim = ((tinit - timbias) + (((i - 1) * (double) dt) / (double) 86400));
               tim_flags_ &= ~MCC_LOGICAL;
               tim_set_ = mccCX;
               /* nev=nev+1; */
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_nev;
                  int I_nev=1;
                  double *p_1nev;
                  int I_1nev=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&nev), mccN(&nev));
                  mccAllocateMatrix(&nev, m_, n_);
                  I_nev = (mccM(&nev) != 1 || mccN(&nev) != 1);
                  p_nev = mccPR(&nev);
                  I_1nev = (mccM(&nev) != 1 || mccN(&nev) != 1);
                  p_1nev = mccPR(&nev);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_)
                     {
                        for (i_=0; i_<m_; ++i_, p_nev+=I_nev, p_1nev+=I_1nev)
                        {
                           *p_nev = (*p_1nev + 1);
                        }
                     }
                  }
               }
               mccLOG(&nev) = 0;
               mccSTRING(&nev) = 0;
               /* elen=0; */
               {
                  double tr_ = 0;
                  mccAllocateMatrix(&elen, 1, 1);
                  *mccPR(&elen) = tr_;
               }
               /* emax=0; */
               emax = 0;
               emax_flags_ &= ~MCC_LOGICAL;
               emax_set_ = mccCX;
               /* ieven=0; */
               {
                  double tr_ = 0;
                  mccAllocateMatrix(&ieven, 1, 1);
                  *mccPR(&ieven) = tr_;
               }
               /* iseven=0; */
               {
                  double tr_ = 0;
                  mccAllocateMatrix(&iseven, 1, 1);
                  *mccPR(&iseven) = tr_;
               }
               /* imeven=0; */
               {
                  double tr_ = 0;
                  mccAllocateMatrix(&imeven, 1, 1);
                  *mccPR(&imeven) = tr_;
               }
               /* creven=cr; */
               mccCopy(&creven, &cr);
               /* end */
            }
            /* stat(10)=1; */
            mccPR(&stat)[(10-1)] = 1;
            /* detimcount=detim; */
            {
               double tr_ = detim;
               mccAllocateMatrix(&detimcount, 1, 1);
               *mccPR(&detimcount) = tr_;
            }
            /* ieven1=-y(i); */
            {
               double tr_ = (-(mccPR(&y)[(i-1)]));
               mccAllocateMatrix(&ieven1, 1, 1);
               *mccPR(&ieven1) = tr_;
            }
            /* iseven1=-yy(i); */
            {
               double tr_ = (-(mccPR(&yy)[(i-1)]));
               mccAllocateMatrix(&iseven1, 1, 1);
               *mccPR(&iseven1) = tr_;
            }
            /* imeven1=-abs(y(i)); */
            {
               double tr_ = (-fabs((mccPR(&y)[(i-1)])));
               mccAllocateMatrix(&imeven1, 1, 1);
               *mccPR(&imeven1) = tr_;
            }
            /* creven=cr; */
            mccCopy(&creven, &cr);
            mccLOG(&creven) = 0;
            mccSTRING(&creven) = 0;
            /* end */
         }
         
         /* if stat(10) == 1 */
         if (( ((mccPR(&stat)[(10-1)]) == 1) && !mccREL_NAN((mccPR(&stat)[(10-1)])) ))
         {
            /* detimcount=detimcount-1; */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_detimcount;
               int I_detimcount=1;
               double *p_1detimcount;
               int I_1detimcount=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&detimcount), mccN(&detimcount));
               mccAllocateMatrix(&detimcount, m_, n_);
               I_detimcount = (mccM(&detimcount) != 1 || mccN(&detimcount) != 1);
               p_detimcount = mccPR(&detimcount);
               I_1detimcount = (mccM(&detimcount) != 1 || mccN(&detimcount) != 1);
               p_1detimcount = mccPR(&detimcount);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_detimcount+=I_detimcount, p_1detimcount+=I_1detimcount)
                     {
                        *p_detimcount = (*p_1detimcount - 1);
                     }
                  }
               }
            }
            /* elen=elen+dt; */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_elen;
               int I_elen=1;
               double *p_1elen;
               int I_1elen=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&elen), mccN(&elen));
               mccAllocateMatrix(&elen, m_, n_);
               I_elen = (mccM(&elen) != 1 || mccN(&elen) != 1);
               p_elen = mccPR(&elen);
               I_1elen = (mccM(&elen) != 1 || mccN(&elen) != 1);
               p_1elen = mccPR(&elen);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_elen+=I_elen, p_1elen+=I_1elen)
                     {
                        *p_elen = (*p_1elen + dt);
                     }
                  }
               }
            }
            /* if abs(y(i)) > abs(emax) */
            if (( (fabs((mccPR(&y)[(i-1)])) > fabs(emax)) && !mccREL_NAN(fabs((mccPR(&y)[(i-1)]))) && !mccREL_NAN(fabs(emax)) ))
            {
               /* emax=y(i); */
               emax = (mccPR(&y)[(i-1)]);
               if (mccLOG(&y))
               {
                  emax_flags_ |= MCC_LOGICAL;
               }
               else
               {
                  emax_flags_ &= ~MCC_LOGICAL;
               }
               emax_set_ = mccSTRING(&y) ? mccTEXT : mccREAL;
               /* creven=cr; */
               mccCopy(&creven, &cr);
               mccLOG(&creven) = 0;
               mccSTRING(&creven) = 0;
               /* timax=tinit-timbias+(i-1)*dt/86400; */
               timax = ((tinit - timbias) + (((i - 1) * (double) dt) / (double) 86400));
               timax_flags_ &= ~MCC_LOGICAL;
               timax_set_ = mccCX;
               /* end */
            }
            /* ieven=ieven+y(i); */
            R0_ = (mccPR(&y)[(i-1)]);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_ieven;
               int I_ieven=1;
               double *p_1ieven;
               int I_1ieven=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&ieven), mccN(&ieven));
               mccAllocateMatrix(&ieven, m_, n_);
               I_ieven = (mccM(&ieven) != 1 || mccN(&ieven) != 1);
               p_ieven = mccPR(&ieven);
               I_1ieven = (mccM(&ieven) != 1 || mccN(&ieven) != 1);
               p_1ieven = mccPR(&ieven);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_ieven+=I_ieven, p_1ieven+=I_1ieven)
                     {
                        *p_ieven = (*p_1ieven + R0_);
                     }
                  }
               }
            }
            /* iseven=iseven+yy(i); */
            R0_ = (mccPR(&yy)[(i-1)]);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_iseven;
               int I_iseven=1;
               double *p_1iseven;
               int I_1iseven=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&iseven), mccN(&iseven));
               mccAllocateMatrix(&iseven, m_, n_);
               I_iseven = (mccM(&iseven) != 1 || mccN(&iseven) != 1);
               p_iseven = mccPR(&iseven);
               I_1iseven = (mccM(&iseven) != 1 || mccN(&iseven) != 1);
               p_1iseven = mccPR(&iseven);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_iseven+=I_iseven, p_1iseven+=I_1iseven)
                     {
                        *p_iseven = (*p_1iseven + R0_);
                     }
                  }
               }
            }
            /* imeven=imeven+abs(y(i)); */
            R0_ = fabs((mccPR(&y)[(i-1)]));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_imeven;
               int I_imeven=1;
               double *p_1imeven;
               int I_1imeven=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&imeven), mccN(&imeven));
               mccAllocateMatrix(&imeven, m_, n_);
               I_imeven = (mccM(&imeven) != 1 || mccN(&imeven) != 1);
               p_imeven = mccPR(&imeven);
               I_1imeven = (mccM(&imeven) != 1 || mccN(&imeven) != 1);
               p_1imeven = mccPR(&imeven);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_imeven+=I_imeven, p_1imeven+=I_1imeven)
                     {
                        *p_imeven = (*p_1imeven + R0_);
                     }
                  }
               }
            }
            /* ieven1=ieven1+y(i); */
            R0_ = (mccPR(&y)[(i-1)]);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_ieven1;
               int I_ieven1=1;
               double *p_1ieven1;
               int I_1ieven1=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&ieven1), mccN(&ieven1));
               mccAllocateMatrix(&ieven1, m_, n_);
               I_ieven1 = (mccM(&ieven1) != 1 || mccN(&ieven1) != 1);
               p_ieven1 = mccPR(&ieven1);
               I_1ieven1 = (mccM(&ieven1) != 1 || mccN(&ieven1) != 1);
               p_1ieven1 = mccPR(&ieven1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_ieven1+=I_ieven1, p_1ieven1+=I_1ieven1)
                     {
                        *p_ieven1 = (*p_1ieven1 + R0_);
                     }
                  }
               }
            }
            /* iseven1=iseven1+yy(i); */
            R0_ = (mccPR(&yy)[(i-1)]);
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_iseven1;
               int I_iseven1=1;
               double *p_1iseven1;
               int I_1iseven1=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&iseven1), mccN(&iseven1));
               mccAllocateMatrix(&iseven1, m_, n_);
               I_iseven1 = (mccM(&iseven1) != 1 || mccN(&iseven1) != 1);
               p_iseven1 = mccPR(&iseven1);
               I_1iseven1 = (mccM(&iseven1) != 1 || mccN(&iseven1) != 1);
               p_1iseven1 = mccPR(&iseven1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_iseven1+=I_iseven1, p_1iseven1+=I_1iseven1)
                     {
                        *p_iseven1 = (*p_1iseven1 + R0_);
                     }
                  }
               }
            }
            /* imeven1=imeven1+abs(y(i)); */
            R0_ = fabs((mccPR(&y)[(i-1)]));
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_imeven1;
               int I_imeven1=1;
               double *p_1imeven1;
               int I_1imeven1=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&imeven1), mccN(&imeven1));
               mccAllocateMatrix(&imeven1, m_, n_);
               I_imeven1 = (mccM(&imeven1) != 1 || mccN(&imeven1) != 1);
               p_imeven1 = mccPR(&imeven1);
               I_1imeven1 = (mccM(&imeven1) != 1 || mccN(&imeven1) != 1);
               p_1imeven1 = mccPR(&imeven1);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_imeven1+=I_imeven1, p_1imeven1+=I_1imeven1)
                     {
                        *p_imeven1 = (*p_1imeven1 + R0_);
                     }
                  }
               }
            }
            
            /* if detimcount <= 0 */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               unsigned short *p_BM0_;
               int I_BM0_=1;
               double *p_detimcount;
               int I_detimcount=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&detimcount), mccN(&detimcount));
               mccAllocateMatrix(&BM0_, m_, n_);
               I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
               p_BM0_ = mccSPR(&BM0_);
               I_detimcount = (mccM(&detimcount) != 1 || mccN(&detimcount) != 1);
               p_detimcount = mccPR(&detimcount);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_detimcount+=I_detimcount)
                     {
                        *p_BM0_ = ( (*p_detimcount <= 0) && !mccREL_NAN(*p_detimcount) );
                     }
                  }
               }
            }
            if (mccIfCondition(&BM0_))
            {
               /* stat(10)=0; */
               mccPR(&stat)[(10-1)] = 0;
               /* elen=elen-detim+dt; */
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_elen;
                  int I_elen=1;
                  double *p_1elen;
                  int I_1elen=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&elen), mccN(&elen));
                  mccAllocateMatrix(&elen, m_, n_);
                  I_elen = (mccM(&elen) != 1 || mccN(&elen) != 1);
                  p_elen = mccPR(&elen);
                  I_1elen = (mccM(&elen) != 1 || mccN(&elen) != 1);
                  p_1elen = mccPR(&elen);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_)
                     {
                        for (i_=0; i_<m_; ++i_, p_elen+=I_elen, p_1elen+=I_1elen)
                        {
                           *p_elen = ((*p_1elen - detim) + dt);
                        }
                     }
                  }
               }
               /* ieven=ieven-ieven1; */
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_ieven;
                  int I_ieven=1;
                  double *p_1ieven;
                  int I_1ieven=1;
                  double *p_ieven1;
                  int I_ieven1=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&ieven), mccN(&ieven));
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&ieven1), mccN(&ieven1));
                  mccAllocateMatrix(&ieven, m_, n_);
                  I_ieven = (mccM(&ieven) != 1 || mccN(&ieven) != 1);
                  p_ieven = mccPR(&ieven);
                  I_1ieven = (mccM(&ieven) != 1 || mccN(&ieven) != 1);
                  p_1ieven = mccPR(&ieven);
                  I_ieven1 = (mccM(&ieven1) != 1 || mccN(&ieven1) != 1);
                  p_ieven1 = mccPR(&ieven1);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_)
                     {
                        for (i_=0; i_<m_; ++i_, p_ieven+=I_ieven, p_1ieven+=I_1ieven, p_ieven1+=I_ieven1)
                        {
                           *p_ieven = (*p_1ieven - *p_ieven1);
                        }
                     }
                  }
               }
               /* iseven=iseven-iseven1; */
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_iseven;
                  int I_iseven=1;
                  double *p_1iseven;
                  int I_1iseven=1;
                  double *p_iseven1;
                  int I_iseven1=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&iseven), mccN(&iseven));
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&iseven1), mccN(&iseven1));
                  mccAllocateMatrix(&iseven, m_, n_);
                  I_iseven = (mccM(&iseven) != 1 || mccN(&iseven) != 1);
                  p_iseven = mccPR(&iseven);
                  I_1iseven = (mccM(&iseven) != 1 || mccN(&iseven) != 1);
                  p_1iseven = mccPR(&iseven);
                  I_iseven1 = (mccM(&iseven1) != 1 || mccN(&iseven1) != 1);
                  p_iseven1 = mccPR(&iseven1);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_)
                     {
                        for (i_=0; i_<m_; ++i_, p_iseven+=I_iseven, p_1iseven+=I_1iseven, p_iseven1+=I_iseven1)
                        {
                           *p_iseven = (*p_1iseven - *p_iseven1);
                        }
                     }
                  }
               }
               /* imeven=imeven-imeven1; */
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  double *p_imeven;
                  int I_imeven=1;
                  double *p_1imeven;
                  int I_1imeven=1;
                  double *p_imeven1;
                  int I_imeven1=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&imeven), mccN(&imeven));
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&imeven1), mccN(&imeven1));
                  mccAllocateMatrix(&imeven, m_, n_);
                  I_imeven = (mccM(&imeven) != 1 || mccN(&imeven) != 1);
                  p_imeven = mccPR(&imeven);
                  I_1imeven = (mccM(&imeven) != 1 || mccN(&imeven) != 1);
                  p_1imeven = mccPR(&imeven);
                  I_imeven1 = (mccM(&imeven1) != 1 || mccN(&imeven1) != 1);
                  p_imeven1 = mccPR(&imeven1);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_)
                     {
                        for (i_=0; i_<m_; ++i_, p_imeven+=I_imeven, p_1imeven+=I_1imeven, p_imeven1+=I_imeven1)
                        {
                           *p_imeven = (*p_1imeven - *p_imeven1);
                        }
                     }
                  }
               }
               
               /* fprintf(fidev,'%d %f %f %f %f %f %f %f %f \n',... */
               Mprhs_[0] = mccTempMatrix(fidev_2, 0., fidev_2_set_, 0 );
               Mprhs_[1] = &S6_;
               Mprhs_[2] = &nev;
               Mprhs_[3] = mccTempMatrix(tim, 0., tim_set_, tim_flags_ );
               Mprhs_[4] = mccTempMatrix(timax, 0., timax_set_, timax_flags_ );
               Mprhs_[5] = &elen;
               Mprhs_[6] = mccTempMatrix(emax, 0., emax_set_, emax_flags_ );
               Mprhs_[7] = &creven;
               Mprhs_[8] = &ieven;
               Mprhs_[9] = &iseven;
               Mprhs_[10] = &imeven;
               Mplhs_[0] = 0;
               mccCallMATLAB(0, Mplhs_, 11, Mprhs_, "fprintf", 188);
               /* end  */
            }
            /* end */
         }
         
         /* if mode(2) > 0 */
         if (( ((mccPR(&mode)[(2-1)]) > 0) && !mccREL_NAN((mccPR(&mode)[(2-1)])) ))
         {
            /* scount=scount+1; */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               double *p_scount;
               int I_scount=1;
               double *p_1scount;
               int I_1scount=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&scount), mccN(&scount));
               mccAllocateMatrix(&scount, m_, n_);
               I_scount = (mccM(&scount) != 1 || mccN(&scount) != 1);
               p_scount = mccPR(&scount);
               I_1scount = (mccM(&scount) != 1 || mccN(&scount) != 1);
               p_1scount = mccPR(&scount);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_scount+=I_scount, p_1scount+=I_1scount)
                     {
                        *p_scount = (*p_1scount + 1);
                     }
                  }
               }
            }
            /* if scount >= istatim */
            {
               int i_, j_;
               int m_=1, n_=1, cx_ = 0;
               unsigned short *p_BM0_;
               int I_BM0_=1;
               double *p_scount;
               int I_scount=1;
               m_ = mcmCalcResultSize(m_, &n_, mccM(&scount), mccN(&scount));
               mccAllocateMatrix(&BM0_, m_, n_);
               I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
               p_BM0_ = mccSPR(&BM0_);
               I_scount = (mccM(&scount) != 1 || mccN(&scount) != 1);
               p_scount = mccPR(&scount);
               if (m_ != 0)
               {
                  for (j_=0; j_<n_; ++j_)
                  {
                     for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_scount+=I_scount)
                     {
                        *p_BM0_ = ( (*p_scount >= istatim) && !mccREL_NAN(*p_scount) && !mccREL_NAN(istatim) );
                     }
                  }
               }
            }
            if (mccIfCondition(&BM0_))
            {
               /* scount=0; */
               {
                  double tr_ = 0;
                  mccAllocateMatrix(&scount, 1, 1);
                  *mccPR(&scount) = tr_;
               }
               /* lastatim=tinit-timbias+(i-1)*dt/86400; */
               lastatim = ((tinit - timbias) + (((i - 1) * (double) dt) / (double) 86400));
               /* if mode == 1 */
               {
                  int i_, j_;
                  int m_=1, n_=1, cx_ = 0;
                  unsigned short *p_BM0_;
                  int I_BM0_=1;
                  double *p_mode;
                  int I_mode=1;
                  m_ = mcmCalcResultSize(m_, &n_, mccM(&mode), mccN(&mode));
                  mccAllocateMatrix(&BM0_, m_, n_);
                  I_BM0_ = (mccM(&BM0_) != 1 || mccN(&BM0_) != 1);
                  p_BM0_ = mccSPR(&BM0_);
                  I_mode = (mccM(&mode) != 1 || mccN(&mode) != 1);
                  p_mode = mccPR(&mode);
                  if (m_ != 0)
                  {
                     for (j_=0; j_<n_; ++j_)
                     {
                        for (i_=0; i_<m_; ++i_, p_BM0_+=I_BM0_, p_mode+=I_mode)
                        {
                           *p_BM0_ = ( (*p_mode == 1) && !mccREL_NAN(*p_mode) );
                        }
                     }
                  }
               }
               if (mccIfCondition(&BM0_))
               {
                  /* fprintf(fidst,'%f %f %f \n',lastatim,armean,arstdev); */
                  Mprhs_[0] = mccTempMatrix(fidst_2, 0., fidst_2_set_, 0 );
                  Mprhs_[1] = &S7_;
                  Mprhs_[2] = mccTempMatrix(lastatim, 0., mccREAL, 0 );
                  Mprhs_[3] = &armean;
                  Mprhs_[4] = &arstdev;
                  Mplhs_[0] = 0;
                  mccCallMATLAB(0, Mplhs_, 5, Mprhs_, "fprintf", 198);
               }
               else
               {
                  /* else */
                  /* rmean=r/istatim; */
                  {
                     int i_, j_;
                     int m_=1, n_=1, cx_ = 0;
                     double *p_rmean;
                     int I_rmean=1;
                     double *p_r;
                     int I_r=1;
                     m_ = mcmCalcResultSize(m_, &n_, mccM(&r), mccN(&r));
                     mccAllocateMatrix(&rmean, m_, n_);
                     I_rmean = (mccM(&rmean) != 1 || mccN(&rmean) != 1);
                     p_rmean = mccPR(&rmean);
                     I_r = (mccM(&r) != 1 || mccN(&r) != 1);
                     p_r = mccPR(&r);
                     if (m_ != 0)
                     {
                        for (j_=0; j_<n_; ++j_)
                        {
                           for (i_=0; i_<m_; ++i_, p_rmean+=I_rmean, p_r+=I_r)
                           {
                              *p_rmean = (*p_r / (double) istatim);
                           }
                        }
                     }
                  }
                  /* rstdev=sqrt((rr-(r.*r)./istatim)/istatim); */
                  {
                     int i_, j_;
                     int m_=1, n_=1, cx_ = 0;
                     double *p_RM0_;
                     int I_RM0_=1;
                     double *p_rr;
                     int I_rr=1;
                     double *p_r;
                     int I_r=1;
                     double *p_1r;
                     int I_1r=1;
                     m_ = mcmCalcResultSize(m_, &n_, mccM(&rr), mccN(&rr));
                     m_ = mcmCalcResultSize(m_, &n_, mccM(&r), mccN(&r));
                     m_ = mcmCalcResultSize(m_, &n_, mccM(&r), mccN(&r));
                     mccAllocateMatrix(&RM0_, m_, n_);
                     I_RM0_ = (mccM(&RM0_) != 1 || mccN(&RM0_) != 1);
                     p_RM0_ = mccPR(&RM0_);
                     I_rr = (mccM(&rr) != 1 || mccN(&rr) != 1);
                     p_rr = mccPR(&rr);
                     I_r = (mccM(&r) != 1 || mccN(&r) != 1);
                     p_r = mccPR(&r);
                     I_1r = (mccM(&r) != 1 || mccN(&r) != 1);
                     p_1r = mccPR(&r);
                     if (m_ != 0)
                     {
                        for (j_=0; j_<n_; ++j_)
                        {
                           for (i_=0; i_<m_; ++i_, p_RM0_+=I_RM0_, p_rr+=I_rr, p_r+=I_r, p_1r+=I_1r)
                           {
                              *p_RM0_ = ((*p_rr - ((*p_r * (double) *p_1r) / (double) istatim)) / (double) istatim);
                           }
                        }
                     }
                  }
                  mccSqrt(&rstdev, &RM0_);
                  /* fprintf(fidst,'%f %f %f \n',lastatim,rmean,rstdev); */
                  Mprhs_[0] = mccTempMatrix(fidst_2, 0., fidst_2_set_, 0 );
                  Mprhs_[1] = &S8_;
                  Mprhs_[2] = mccTempMatrix(lastatim, 0., mccREAL, 0 );
                  Mprhs_[3] = &rmean;
                  Mprhs_[4] = &rstdev;
                  Mplhs_[0] = 0;
                  mccCallMATLAB(0, Mplhs_, 5, Mprhs_, "fprintf", 202);
                  /* r=0;rr=0; */
                  {
                     double tr_ = 0;
                     mccAllocateMatrix(&r, 1, 1);
                     *mccPR(&r) = tr_;
                  }
                  {
                     double tr_ = 0;
                     mccAllocateMatrix(&rr, 1, 1);
                     *mccPR(&rr) = tr_;
                  }
                  /* end */
               }
               /* end */
            }
            /* end */
         }
         /* end */
      }
      
      /* nev */
      mccPrint (&nev, "nev");
      
      /* stat(1)=s; */
      mccPR(&stat)[(1-1)] = *mccPR(&s);
      /* stat(2)=ss; */
      mccPR(&stat)[(2-1)] = *mccPR(&ss);
      /* stat(3)=r; */
      mccPR(&stat)[(3-1)] = *mccPR(&r);
      /* stat(4)=rr; */
      mccPR(&stat)[(4-1)] = *mccPR(&rr);
      /* stat(5)=ii; */
      mccPR(&stat)[(5-1)] = *mccPR(&ii);
      /* stat(6)=detimcount; */
      mccPR(&stat)[(6-1)] = *mccPR(&detimcount);
      /* stat(7)=lastatim; */
      mccPR(&stat)[(7-1)] = lastatim;
      /* stat(8)=scount; */
      mccPR(&stat)[(8-1)] = *mccPR(&scount);
      /* stat(10)=norm; */
      mccPR(&stat)[(10-1)] = *mccPR(&norm);
      
      /* stat(12)=tim; */
      mccPR(&stat)[(12-1)] = tim;
      /* stat(13)=elen; */
      mccPR(&stat)[(13-1)] = *mccPR(&elen);
      /* stat(14)=emax; */
      mccPR(&stat)[(14-1)] = emax;
      /* stat(15)=ieven; */
      mccPR(&stat)[(15-1)] = *mccPR(&ieven);
      /* stat(16)=iseven; */
      mccPR(&stat)[(16-1)] = *mccPR(&iseven);
      /* stat(17)=imeven; */
      mccPR(&stat)[(17-1)] = *mccPR(&imeven);
      /* stat(18)=timax; */
      mccPR(&stat)[(18-1)] = timax;
      /* stat(20)=nev; */
      mccPR(&stat)[(20-1)] = *mccPR(&nev);
      
      /* stat(25)=ieven1; */
      mccPR(&stat)[(25-1)] = *mccPR(&ieven1);
      /* stat(26)=iseven1; */
      mccPR(&stat)[(26-1)] = *mccPR(&iseven1);
      /* stat(27)=imeven1; */
      mccPR(&stat)[(27-1)] = *mccPR(&imeven1);
      
      /* fclose(fidev); */
      Mprhs_[0] = mccTempMatrix(fidev_2, 0., mccREAL, 0 );
      Mplhs_[0] = 0;
      mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "fclose", 234);
      /* fclose(fidst); */
      Mprhs_[0] = mccTempMatrix(fidst_2, 0., mccREAL, 0 );
      Mplhs_[0] = 0;
      mccCallMATLAB(0, Mplhs_, 1, Mprhs_, "fclose", 235);
      
      mccReturnFirstValue(&plhs_[0], &stat);
   }
   return;
}

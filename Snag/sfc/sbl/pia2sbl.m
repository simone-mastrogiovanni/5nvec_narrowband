function pia2sbl(folder,filelist,filesbl)
%
%   folder      folder containing the input pia files
%   filelist    pia files list file (obtained with dir /b/s > list.txt in the parent dir)
%   filesbl     file sbl to create
%
%  The sbl files contain 4 channels:
%  
%    1  fft
%    2  detector v_eq/c (3 double)
%    3  short power spect
%    4  time averages
%
% The format is a reduced sfdb format
%
% 
% 	Format of the SFDB files:
% 
% files are binary and have:
%
%  1	 header;
%  2	 averages of the short power spectra (with time) in units EINSTEIN/Hz
%  3	 AR short power spectra (subsampling factor written in the header). 
%         Files contain the amplitude, which has to be squared to get the very short power spectrum.
%         Units EINSTEIN/Sqrt(Hz);
%  4	 FFTs (real and imag part) in units EINSTEIN/Sqrt(Hz).
% 
% 
% The header contains all the relevant information which regards
% the detector and information on how the Data-Base has been
% done.
% HEADER
% Parameters written in the header are put in the structure  HEADER_PARAM
% 
% typedef struct HEADER_PARAM{
%  char sfdbname[MAXMAXLINE+1];  /*Name of the  SFDB file*/
%  double endian;
%  int detector;            /*if 0 r87 (the detector is a bar); if 1 sds format (itf); if 2 frame format (itf)*/
%  int gps_sec;
%  int gps_nsec;
%  double tbase;          /*Len in seconds of 1 data chunk used for the  FFT*/
%  int firstfreqindex;
%  int nsamples;         /*Number of samples in half FFT (which is what is stored)*/
%  int red;            /*Reduction factor for the very short FFTs (e.g. 128..)*/
%  float einstein; 
%  double mjdtime;
%  int nfft;
%  int wink;         /*0=no win--Other numbers are different windows*/
%  int typ;          /*0, 1 = non overlapping data  2=overlapping data*/
%  float32 n_flag; //how many record have a flag !=0 in that FFT
%  double frinit,tsamplu,deltanu;
%  double frcal, freqm,freqp,taum,taup;   //Only these are specific for resonant detectors: calibration, resonances
% } HEADER_PARAM;
% 
% 
% Averages of the short power spectra (with time)
% 
%  ps=(float *)malloc((size_t) (header_param->red)*sizeof(float));
%     /*Read the averages of the short power spectra (power with time)*/
%     for(ii=0;ii<header_param->red;ii++){
%       errorcode=fread((void*)&rpw, sizeof(float),1,OUTH1);
%        if (errorcode!=1) {
% 	printf("Error in reading power ps data into SFT file! %d \n",ii);
% 	return errorcode;
%       }
%       ps[ii]=rpw;
%       //printf(" Short power j ps[j] %d %f\n",ii,ps[ii]); 
%     }
%     free(ps);
% 
% 
% 
% 
% AR  short power spectrum 
% 
%  /*Read the very short FFT (each bin averaged over red data*/
%      kk=0; //only to evaluate frequencies for the test file
%     for(ii=0;ii<header_param>nsamples/header_param>red;ii++)
% {
%       errorcode=fread((void*)&rpw, sizeof(float),1,OUTH1);
%        if (errorcode!=1) {
% 	printf("Error in reading very short FFT  data into SFT file! %d \n",ii);
% 	return errorcode;
%       }
%       gd_short->y[ii]=rpw;       //sqrt(spectrum)
%       //TEST FILE with the very short power spectrum:
%       freq=(float)(header_param->firstfreqindex)/header_param->tbase+kk*header_param->red/header_param->tbase;
%       sden=rpw*rpw;
%       if(k==iw)fprintf(OUTSS,"%f %e \n",freq,sden); //write the iw fft in a ascii file
%       kk++;
%     }
% 
% 
% 
% 
% 
% FFTs of the SFDB
% 
%  for(ii=0;ii< 2*header_param->nsamples; ii+=2){ 
%       errorcode=fread((void*)&rpw, sizeof(float),1,OUTH1);  
%       if (errorcode!=1) {
% 	printf("Error in reading rpw data into SFT file! %d \n",ii);
% 	return errorcode;
%       }
%       errorcode=fread((void*)&ipw, sizeof(float),1,OUTH1);
%       if (errorcode!=1) {
% 	printf("Error in reading ipw data into SFT file! %d \n",ii);
% 	return errorcode;
%       }
% //the following is an example to write on an ascii file:
%       gd->y[ii]=rpw;       //Real part
%       gd->y[ii+1]=ipw;    //Imag part
%       freq=(float)(header_param->firstfreqindex+kk)*1.0/header_param->tbase;
%       sden=rpw*rpw+ipw*ipw;
%       fprintf(OUTS,"%f %e \n",freq,sden); //write the power   in a ascii file.	  
%     } //for ii


fidlist=fopen(filelist,'r');
nfiles=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',file{nfiles});
    disp(str);
end
fclose(fidlist);

for kfil = 1:nfiles
    [piahead,data]=pia_read([folder file{kfil}]);
    len2=piahead.nsamples;
    tbl=piahead.gps_sec+piahead.gps_nsec*1.e-9;
    sbhead=[piahead.firstfrind/piahead.tbase 0];
    if kfil == 1
        sbl_.nch=1;
        sbl_.len=nfiles;
        sbl_.capt='Dati ROG';
        ch(1).dx=1/piahead.tbase;
        ch(1).dy=0;
        ch(1).lenx=len2;
        ch(1).leny=1;
        ch(1).type=5;
        ch(1).name='fft (half)';
        sbl_.ch=ch;
        sbl_.t0=tbl;
        sbl_.dt=piahead.tbase/(2*len2);
        
        sbl_=sbl_openw(filesbl,sbl_);
        fid=sbl_.fid;
        nbl=0;
    end
    
    nbl=nbl+1
    sbl_headblw(fid,nbl,tbl);
    sbl_write(fid,sbhead,5,data);
end

fclose(fid);
        
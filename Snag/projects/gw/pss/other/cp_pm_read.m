function [pm,head]=cp_pm_read(filein)
%CP_PM_READ  reads a Cristiano peak map
%
% Cristiano read program 
%
% #include<stdio.h>
% #include<stdlib.h>
% 
% int main(){
%   FILE *flist;
%   FILE *fr;
%   char fileinput[128];
%   char filename[128];
%   int i,ii;
%   int nSpec,npeak,peak;
%   float time,vx,vy,vz,ratio,ampl;
% 
%   strcpy(fileinput,"list.txt");
%   if((flist=fopen(fileinput,"r"))==NULL){
%     printf("flist: Cannot open input file!\n");
%     exit(1);
%   }
%   
%   while (!feof(flist)){
%     fscanf(flist,"%s",filename);
%     if (feof(flist)) break;
%     if((fr=fopen(filename, "rb"))==NULL){
%       printf("fr: Cannot open file!\n");
%       exit(1);
%     }
%     fread(&nSpec,sizeof(int),1,fr);
%     for (i=0; i<nSpec; i++){
%       fread(&time,sizeof(float),1,fr);
%       fread(&npeak,sizeof(int),1,fr);
%       fread(&vx,sizeof(float),1,fr);
%       fread(&vy,sizeof(float),1,fr);
%       fread(&vz,sizeof(float),1,fr);
%       for (ii=0; ii<npeak; ii++){
% 	fread(&peak,sizeof(int),1,fr);
% 	fread(&ratio,sizeof(float),1,fr);
% 	fread(&ampl,sizeof(float),1,fr);
%       }
%     }
%     fclose(fr);
%   }
%   fclose(flist);
%   return 0;
% }



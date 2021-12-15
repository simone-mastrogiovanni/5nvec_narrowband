function [fcand sour]=pss_readsourcefile(infile,t0,fake_fact)
% PSS_READSOURCEFILE  reads source file
%
%         [fcand sour]=pss_readsourcefile(infile)
%
%  infile     output file (interactive if not present)
%  t0         if > 0 computes the frequencies at t0 (mjd)
%  fake_fact  fake dilatation factor (e.g. 80)
%
%  fcand      candidate matrix (coordinates are converted to ecliptical)
%  sour       complete matrix

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('infile','var')
    infile=selfile(' ');
end

if ~exist('t0','var')
    t0=0;
end
if t0 <= 0
    t0=v2mjd([2000 1 1 0 0 0]);
end
epoch=t0;
t0=t0-v2mjd([2000 1 1 0 0 0]);

if ~exist('fake_fact','var')
    fake_fact=1;
end

if fake_fact <= 0
    fake_fact=1;
end

fid=fopen(infile);

NN=0;
sour=zeros(9,100);
% na=1000;

while 1
   tline = fgetl(fid);
   if ~ischar(tline),   break,   end
   if tline(1) == '!'
       continue
   end
   NN=NN+1;
   if floor(NN/100)*100 == NN-1
       sour(:,NN:NN+99)=zeros(9,100);
   end
   aa=sscanf(tline,' %d %g %g %g %g %g %g %g %g');
   sour(:,NN)=aa;
end

sour=sour(:,1:NN);
fclose(fid); 

ai=sour(8,:);
di=sour(9,:);

[ao do]=astro_coord('equ','ecl',ai,di);
ao=mod(ao,360);

fcand1=zeros(7,NN);
fcand1(1,:)=sour(2,:)-t0*sour(3,:)/fake_fact;
fcand1(2,:)=ao;
fcand1(3,:)=do;
fcand1(4,:)=sour(3,:)/fake_fact;
fcand1(7,:)=sour(5,:);

sour=sour(2:9,:);

fcand.cand=fcand1;
fcand.epoch=epoch;
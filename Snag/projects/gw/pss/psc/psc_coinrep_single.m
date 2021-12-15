function psc_coinrep_single(rname,candstr1,candstr2,searstr,c_cand1,c_cand2,start,stop)
%PSC_COINREP_sSINGLE  creates a coincidence report
%
%    psc_coinrep(name,candstr1,candstr2,searstr,c_cand1,c_cand2)
%
%  rname       report name
%  candstr1    candidate structure 1
%  candstr2    candidate structure 2
%  searstr     search structure
%               .diffr,.diflam,.difbet,.difsd1
%               .minfr1,.maxfr1,.minfr2,.maxfr2,
%               .minlam1,.maxlam1,.minlam2,.maxlam2,
%               .minbet1,.maxbet1,.minbet2,.maxbet2,
%               .minsd11,.maxsd11,.minsd12,.maxsd12,
%               .totcomp,.aftfr,.aftsd,.aftbet,.aftlam,.ncoin
%               .N1,.N2,.N1N2,.ncoin
%              NOTES: difX means a window of (2*difX+1)(r1+r2)/2 (rx resolution)
%  c_cand1     coincidence candidate 1
%  c_cand2     coincidence candidate 2
%  start,stop  start,stop coincidence job

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dfr1=1/(candstr1.st*candstr1.fftlen);
nfr1=(searstr.maxfr1-searstr.minfr1)/dfr1+1;
nlam1=(searstr.maxlam1-searstr.minlam1)/candstr1.dlam+1;
nbet1=(searstr.maxbet1-searstr.minbet1)/candstr1.dbet+1;
nsd11=(searstr.maxsd11-searstr.minsd11)/candstr1.dsd1+1;

dfr2=1/(candstr2.st*candstr2.fftlen);
nfr2=(searstr.maxfr2-searstr.minfr2)/dfr2+1;
nlam2=(searstr.maxlam2-searstr.minlam2)/candstr2.dlam+1;
nbet2=(searstr.maxbet2-searstr.minbet2)/candstr2.dbet+1;
nsd12=(searstr.maxsd12-searstr.minsd12)/candstr2.dsd1+1;

minfr=max(searstr.minfr1,searstr.minfr2);
maxfr=min(searstr.maxfr1,searstr.maxfr2);
minlam=max(searstr.minlam1,searstr.minlam2);
maxlam=min(searstr.maxlam1,searstr.maxlam2);
minbet=max(searstr.minbet1,searstr.minbet2);
maxbet=min(searstr.maxbet1,searstr.maxbet2);
minsd1=max(searstr.minsd11,searstr.minsd12);
maxsd1=min(searstr.maxsd11,searstr.maxsd12);

fid=fopen(rname,'w');

fprintf(fid,'             PSS Coincidence report \r\n\r\n');
fprintf(fid,'              level 2 coincidences  \r\n\r\n');
fprintf(fid,'         frequency range:  %f <-> %f \r\n',minfr,maxfr);
fprintf(fid,'            lambda range:  %f <-> %f \r\n',minlam,maxlam);
fprintf(fid,'              beta range:  %f <-> %f \r\n',minbet,maxbet);
fprintf(fid,'               sd1 range:  %f <-> %f \r\n',minsd1,maxsd1);
fprintf(fid,'         norm.width %f  %f  %f  %f \r\n',...
    searstr.diffr,searstr.diflam,searstr.difbet,searstr.difsd1);
str=blank_trim(char(candstr1.capt'));
fprintf(fid,'\r\n  DB 1 -> %s \r\n',str);
fprintf(fid,'          initim            %f   %s \r\n',candstr1.initim,mjd2s(candstr1.initim));
fprintf(fid,'          samp.time,fftlen  %f   %d \r\n',candstr1.st,candstr1.fftlen);
fprintf(fid,'          d-fr,lam,bet,sd1,cr,mh,h   %f   %f   %f   %e   %f   %f   %e \r\n',...
    dfr1,candstr1.dlam,candstr1.dbet,candstr1.dsd1,candstr1.dcr,candstr1.dmh,candstr1.dh);
fprintf(fid,'               %d candidates \r\n',searstr.N1);
fprintf(fid,'         frequency range:  %f <-> %f : %d bins \r\n',searstr.minfr1,searstr.maxfr1,nfr1);
fprintf(fid,'            lambda range:  %f <-> %f : %d bins \r\n',searstr.minlam1,searstr.maxlam1,nlam1);
fprintf(fid,'              beta range:  %f <-> %f : %d bins \r\n',searstr.minbet1,searstr.maxbet1,nbet1);
fprintf(fid,'               sd1 range:  %f <-> %f : %d bins \r\n',searstr.minsd11,searstr.maxsd11,nsd11);

str=blank_trim(char(candstr2.capt'));
fprintf(fid,'\r\n  DB 2 -> %s \r\n',str);
fprintf(fid,'          initim            %f   %s \r\n',candstr2.initim,mjd2s(candstr2.initim));
fprintf(fid,'          samp.time,fftlen  %f   %d \r\n',candstr2.st,candstr2.fftlen);
fprintf(fid,'          d-fr,lam,bet,sd1,cr,mh,h   %f   %f   %f   %e   %f   %f   %e \r\n',...
    dfr2,candstr2.dlam,candstr2.dbet,candstr2.dsd1,candstr2.dcr,candstr2.dmh,candstr2.dh);
fprintf(fid,'               %d candidates \r\n',searstr.N2);
fprintf(fid,'         frequency range:  %f <-> %f : %d bins \r\n',searstr.minfr2,searstr.maxfr2,nfr2);
fprintf(fid,'            lambda range:  %f <-> %f : %d bins \r\n',searstr.minlam2,searstr.maxlam2,nlam2);
fprintf(fid,'              beta range:  %f <-> %f : %d bins \r\n',searstr.minbet2,searstr.maxbet2,nbet2);
fprintf(fid,'               sd1 range:  %f <-> %f : %d bins \r\n',searstr.minsd12,searstr.maxsd12,nsd12);

fprintf(fid,'\r\n   Coincidences between %d and %d candidates.\r\n',searstr.N1,searstr.N2);
fprintf(fid,'       Gain using 242 subgroups:  %d \r\n',(searstr.N1*searstr.N2)/searstr.N1N2);

for i = 1:searstr.ncoin
    fprintf(fid,' %d -> %f <-> %f   %f <-> %f   %f <-> %f   %e <-> %e   %f <-> %f   %f <-> %f   %e <-> %e \r\n',...
      i,c_cand1(1,i),c_cand2(1,i),c_cand1(2,i),c_cand2(2,i),c_cand1(3,i),c_cand2(3,i),c_cand1(4,i),c_cand2(4,i),...
      c_cand1(5,i),c_cand2(5,i),c_cand1(6,i),c_cand2(6,i),c_cand1(7,i),c_cand2(7,i));
end

wf1=floor(2*searstr.diffr+1)/nfr1;
wl1=floor(2*searstr.diflam+1)/nlam1;
wb1=floor(2*searstr.difbet+1)/nbet1;
ws1=floor(2*searstr.difsd1+1)/nsd11;

cointeor=searstr.N2*(1-exp(-wf1*searstr.N1))*wl1*wb1*ws1;
compteor=searstr.N1N2*wf1+searstr.N2; 

fprintf(fid,'\r\n                 theoretical           real \r\n')
fprintf(fid,'\r\n  comparisons     %d          %d  \r\n',floor(compteor),searstr.nnn)
fprintf(fid,'  coincidences    %f          %d  \r\n\r\n',cointeor,searstr.ncoin)

fprintf(fid,'freq->  n: %d   w: %f  after: %d  aft.teor %f \r\n',nfr1,wf1,searstr.ncf,searstr.N2*searstr.N1*wf1)
fprintf(fid,'sd1 ->  n: %d   w: %f  after: %d  aft.teor %f \r\n',nsd11,ws1,searstr.ncs,searstr.ncf*ws1)
fprintf(fid,'bet ->  n: %d   w: %f  after: %d  aft.teor %f \r\n',nbet1,wb1,searstr.ncb,searstr.ncs*wb1)
fprintf(fid,'lam ->  n: %d   w: %f  after: %d  aft.teor %f \r\n',nlam1,wl1,searstr.ncoin,searstr.ncb*wl1)

fprintf(fid,'\r\n   %d comparisons, %d after frequency, %d after spin-down, %d after beta, %d after lambda.\r\n',...
    searstr.nnn,searstr.ncf,searstr.ncs,searstr.ncb,searstr.ncoin);

fprintf(fid,'\r\n Coincidence work started at %s -> stopped at %s',start,stop);

fclose(fid);
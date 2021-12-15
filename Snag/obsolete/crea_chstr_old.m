function chstr=crea_chstr(nch1,nch2)
%CREA_CHSTR  creates a channel structure for events
%
%    nch1    number of channels of first antenna
%    nch2    number of channels of second antenna
%
%    Channel structure members:
%          ch.na        number of antennas
%          ch.nch()     number of channels for each antenna
%          ch.an(nch)   antenna
%          ch.ty(nch)   type
%          ch.cf(nch)   central frequencies
%          ch.bw(nch)   bandwidth
%
%   (sim) ch.lcn(nch)  lambdas for channel noise (norm to tobs)
%   (sim) ch.lds(nch)  local disturbance sensitivity
%   (sim) ch.lml()     lambdas for loc. dist. (for any antenna - norm to tobs)
%   (sim) ch.gws(nch)  gravitational wave sensitivity
%   (sim) ch.lmg       lambda for gw (norm to tobs)
%
%  (stat) ch.nev(nch)  number of events found
%
%  (anal) ch.dt        dead time for cluster analisys


nch=nch1+nch2;

chstr.na=2;
chstr.nch=[nch1 nch2];
chstr.an=zeros(1,nch);
chstr.ty=cell(1,nch);
chstr.cf=zeros(1,nch);
chstr.bw=zeros(1,nch);
chstr.lcn=zeros(1,nch);
chstr.lds=zeros(1,nch);
chstr.gws=zeros(1,nch);
chstr.lml=[10 10];
chstr.lmg=12;

for i = 1:nch1
    chstr.an(i)=1;
    chstr.ty(i)={'h rec'};
    chstr.cf(i)=1000*i/(nch1+1);
    chstr.bw(i)=1000/nch1;
    chstr.lcn(i)=20+2*i;
    chstr.lds(i)=0.5;
    chstr.gws(i)=0.5;
end

for i = 1+nch1:nch
    chstr.an(i)=2;
    chstr.ty(i)={'h rec'};
    chstr.cf(i)=1000*i/(nch1+1);
    chstr.bw(i)=1000/nch1;
    chstr.lcn(i)=10+2*i;
    chstr.lds(i)=0.5;
    chstr.gws(i)=0.5;
end

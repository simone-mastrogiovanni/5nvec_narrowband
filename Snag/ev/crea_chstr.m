function chstr=crea_chstr(nch)
%CREA_CHSTR  creates a channel structure for events
%
%    nch()    number of channels of each antenna
%
%    Channel structure members:
%          ch.na             number of antennas
%          ch.nch()          number of channels for each antenna
%          ch.an(nchtot)     antenna
%          ch.ty(nchtot)     type
%          ch.st(nchtot)     sampling time (s)
%          ch.cf(nchtot)     central frequencies
%          ch.bw(nchtot)     bandwidth
%          ch.win(:,nchtot)  windows (the win vector contains alternate, for any channel,
%                             ini,fin of each window); may be absent 
%
%   (sim) ch.lcn(nchtot)  lambdas for channel noise (norm to tobs)
%   (sim) ch.lds(nchtot)  local disturbance sensitivity
%   (sim) ch.lml()        lambdas for loc. dist. (for any antenna - norm to tobs)
%   (sim) ch.gws(nchtot)  gravitational wave sensitivity
%   (sim) ch.lmg          lambda for gw (norm to tobs)
%
%  (stat) ch.nev(nchtot)     number of events found
%
%  (anal) ch.dt           dead time for cluster analisys (s)

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nchtot=sum(nch);

chstr.na=length(nch);
chstr.nch=nch;
chstr.an=zeros(1,nchtot);
chstr.ty=cell(1,nchtot);
chstr.st=zeros(1,nchtot);
chstr.cf=zeros(1,nchtot);
chstr.bw=zeros(1,nchtot);
chstr.lcn=zeros(1,nchtot);
chstr.lds=zeros(1,nchtot);
chstr.gws=zeros(1,nchtot);
chstr.lml=10*ones(1,chstr.na);
chstr.lmg=12;

i=0;
for j = 1:chstr.na
	for k = 1:nch(j)
        i=i+1;
        chstr.an(i)=j;
        chstr.ty(i)={'h rec'};
        chstr.st(i)=0.00025;
        chstr.cf(i)=1000*i/(nch(j)+1);
        chstr.bw(i)=1000/nch(j);
        chstr.lcn(i)=20+2*i;
        chstr.lds(i)=0.5;
        chstr.gws(i)=0.5;
	end
end

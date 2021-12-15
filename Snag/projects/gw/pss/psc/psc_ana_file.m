function [frhist,skyhist]=psc_ana_file(fr,lam,bet,sd,cr,frhist,skyhist,file)
%PSC_ANA file candidate analysis
%
%     [frhist,skyhist]=psc_ana_file(filefr,lam,bet,sd,cr,frhist,skyhist,file)
%
%   fr       [frmin,dfr,frmax]; = 0 no frequency histogram
%   lam      [lammin,dlam,lammax]; = 0 no sky histogram
%   bet      [betmin,dbet,betmax]; = 0 no sky histogram
%   sd       array with the requested sd (e.g. [0 1 4])
%   cr       [crmin,crmax]; = 0 no selection
%   frhist   input hist; = 0 new
%   skyhist  input hist; = 0 new

% Version 2.0 - March 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file','var')
    file=selfile('');
end

nsd=length(sd);
if fr == 0
    frhist=0;
else
    nfr=ceil((fr(3)-fr(1))/fr(2)+1);
    frhist=zeros(nsd,nfr);
    frh=zeros(1,nfr);
    frx=fr(1):fr(2):fr(3);
end

if lam == 0
    skyhist=0;
else
    nlam=ceil((lam(3)-lam(1))/lam(2)+1);
    nbet=ceil((bet(3)-bet(1))/bet(2)+1);
    skyhist=zeros(nsd,nbet,nlam);
    skyh=zeros(1,nlam);
    lamx=lam(1):lam(2):lam(3);
end

fid=fopen(file,'r');

head=psc_rheader(fid);
dfr0=1/(head.st*head.fftlen);
i188=188;
if head.prot > 2
    i188=256;
end

info=dir(file);
ncand=(info.bytes-i188)/(8*2)
n1000000=1000000;
nread=n1000000*8;
ntot=0;

while nread == n1000000*8
    [cand,nread]=fread(fid,n1000000*8,'uint16');
    nn=nread/8;
    ntot=ntot+nn

    cand=psc_vec2mat(cand,head,nn);
    cand(4,:)=round(cand(4,:)/head.dsd1);
    
    for k = 1:nsd
        [ii,jj]=find(cand(4,:)==sd(k));
        if length(frhist) > 1
            cand1=cand(1,jj);
            frh=hist(cand1,frx); 
            frhist(k,:)=frhist(k,:)+frh;
        end
        if length(skyhist) > 1
            cand1=cand(2,jj);
            cand2=cand(3,jj);
            cand2i=round((cand2-bet(1))/bet(2)+1);
            for j = 1:nbet
                [iii,jjj]=find(cand2i == j);
                cand10=cand1(jjj);
                skyh=hist(cand10,lamx); %size(skyh),size(skyhist)
%                 skyh=skyhist(k,j,1:nlam)+skyh(1:nlam)';
%                 skyhist(k,j,1:nlam)=skyh(1:nlam);
                for l = 1:nlam
                    skyhist(k,j,l)=skyhist(k,j,l)+skyh(l);
                end
            end
        end
    end
end

if length(frhist) > 1
    figure
    plot(frx,frhist'); grid on
end

if length(skyhist) > 1
    for i = 1:nsd
        A(1:nbet,1:nlam)=skyhist(i,1:nbet,1:nlam);
        figure,image(A,'CDataMapping','scaled'),grid on, colorbar, clear A
    end
end
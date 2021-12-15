function [period perclean win perpar meanper]=gd2_period(g2in,per,ph,nbin,subband,nofig)
% gd2_period  parallel epoch folding with a gd2
%                 use with show_gd2_per_par
%
%    [period perclean win perpar meanper]=gd2_period(g2,per,ph,nbin,nofig)
% 
%   g2        input gd
%   per       period (number,if string, time in mjd)
%                "day" "week" "sid" 
%   ph        phase; for per = 'sid', ph = antenna gives the loc sid time
%   nbin      number of bins in the period; or [nbin numharm nord]
%   subband   [minfr maxfr] ; =0 all
%   nofig     1 -> no output figure, 2 -> no per out
%
%   period    epoch folding
%   perclean  smoothed e.f.
%   win       observation window (matrix)
%   perpar    [5,m] period parameters [fr mean amp phase antiphase]
%   meanper   [3,nbin] mean period and perclean

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('nbin','var')
    nbin=120;
end

nord0=360;
if length(nbin) > 2
    nord0=nbin(3);
end
if length(nbin) > 1
    numharm=nbin(2);
    nbin=nbin(1);
else
    numharm=4;
end

if ~exist('subband','var')
    subband=0;
end

if ~exist('nofig','var')
    nofig=0;
end

M=y_gd2(g2in);
[n m]=size(M);
t=x_gd2(g2in);
x2=x2_gd2(g2in);
dfr=dx2_gd2(g2in);
frin=ini2_gd2(g2in);
icper=0;
nord=nord0;

if length(subband) == 2
    jjj=find(x2 >= subband(1) & x2 <= subband(2));
    if isempty(jjj)
        fprintf('\n *** Incorrect frequency range (%f %f) instead of (%f %f) \n\n',subband,min(x2),max(x2));
        return
    end
    m1=min(jjj);
    m2=max(jjj);
    if nofig == 0
        fprintf(' m range: %d %d \n',m1,m2)
    end
else
    m1=1;m2=m;
end
ini2=x2(m1);

if ischar(per)
    switch per
        case 'day'
            per=1;
            icper=1;
            strtit='One day period';
        case 'week'
            per=7;
            icper=3;
            strtit='One week period';
        case 'sid'
            per=1/1.002737909350795;
            strtit='Sidereal day period';
            if ~isnumeric(ph)
                long=ph.long;
            else
                long=-ph;
            end
            icper=2;
        case 'asid'
            per=1/(2-1.002737909350795);
            strtit='Anti-Sidereal day period';
            if ~isnumeric(ph)
                long=ph.long;
            else
                long=-ph;
            end
            icper=4;
    end
else
    strtit=sprintf('Period %f',per);
end

switch icper
    case 1
        t=t-floor(t(1));
        t=mod(t-ph/360,1);
        nord=24;
    case 2
        t=(gmst(t)*15+long)/360;
        t=mod(t,1);
        nord=24;
    case 3
        t=mod(t-5,7)/7;
        nord=7;
        numharm=round(nbin/2);
    case 4
        t=(agmst(t)*15+long)/360;
        t=mod(t,1);
        nord=24;
    otherwise
        t=mod(t/per-ph/360,1);
end

ii=floor(t*nbin)+1;
iii=find(ii == nbin+1);
ii(iii)=1;
period=zeros(nbin,m2-m1+1);
perclean=period;
win=period;
perpar=zeros(5,m2-m1+1);

for i = m1:m2
    for j = 1:n
        period(ii(j),i-m1+1)=period(ii(j),i-m1+1)+M(j,i);
        win(ii(j),i-m1+1)=win(ii(j),i-m1+1)+abs(sign(M(j,i))); % 0s are holes
    end
end

nmax=max(max(win));
ic=0;

for i = m1:m2
    ii1=find(win(:,i-m1+1) == 0);

    if ~isempty(ii1)
        if ic == 0
            fprintf(' *** holes in the bins ! reduce nbin i = %d \n',i);
%             if nofig <= 0
%                 figure,imagesc(win')
%                 figure,stairs(ii)
%             end
        end
        ic=1;
        win(ii1,i-m1+1)=nmax*1000;
    end
end

period=period./win;

for i = m1:m2
    im=i-m1+1;
    me=mean(period(:,im));
    f=fft(period(:,im));
    f(numharm+2:nbin)=0;
    f(nbin:-1:nbin-numharm+1)=conj(f(2:numharm+1));
    perclean(:,im)=ifft(f);
    period(:,im)=period(:,im)/me;
    perclean(:,im)=perclean(:,im)/me;
    perpar(1,im)=x2(i);
    perpar(2,im)=me;
    [ma kma]=max(perclean(:,im));
    [mi kmi]=min(perclean(:,im));
    perpar(3,im)=(ma-mi)/2;
    perpar(4,im)=(kma-1)*nord/nbin;
    perpar(5,im)=(kmi-1)*nord/nbin;
end

meanper(1,:)=(0:nbin-1)*nord/nbin;
meanper(2,:)=mean(period,2);
meanper(3,:)=mean(perclean,2);

period=gd2(period');
period=edit_gd2(period,'dx2',nord/nbin,'ini',frin,'dx',dfr);
perclean=gd2(perclean');
perclean=edit_gd2(perclean,'dx2',nord/nbin,'ini',frin,'dx',dfr);

if nofig <= 0
    image_gd2(perclean),title(strtit),xlabel('Hz')
    switch icper
        case 0
            ylabel('degrees')
        case 3
            ylabel('week''s day')
        otherwise
            ylabel('hours')
    end
elseif nofig == 1 
    fprintf('Period %f \n',per)
end
function candout=psc_sel(candin,fr,lam,bet,sd,cr)
%PSC_SEL candidate selection
%
%     candout=psc_sel(candin,fr,lam,bet,sd,cr)
%
%   candin   input candidate array (7,n)
%   fr       [frmin,frmax]; = 0 no selection
%   lam      [lammin,lammax]; = 0 no selection
%   bet      [betmin,betmax]; = 0 no selection
%   sd       [sdmin,sdmax]; = 0 no selection
%   cr       [crmin,crmax]; = 0 no selection

% Version 2.0 - February 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icstr=0;
if isstruct(candin)
    icstr=1;
    candout=candin;
    candin=candin.cand;
end
    
icfr=1;
iclam=1;
icbet=1;
icsd=1;
iccr=1;

if length(fr) == 1
    icfr=0;
end
if length(lam) == 1
    iclam=0;
end
if length(bet) == 1
    icbet=0;
end
if length(sd) == 1
    icsd=0;
end
if length(cr) == 1
    iccr=0;
end

candout1=candin;

if icfr == 1
    c=candout1(1,:);
    ii=find(c>=fr(1)&c<=fr(2));
    nn=length(ii);
    for  j = 1:7
        candout1(j,1:nn)=candout1(j,ii);
    end
    candout1=candout1(:,1:nn);
end

if iclam == 1
    c=candout1(2,:);
    ii=find(c>=lam(1)&c<=lam(2));
    nn=length(ii);
    for  j = 1:7
        candout1(j,1:nn)=candout1(j,ii);
    end
    candout1=candout1(:,1:nn);
end

if icbet == 1
    c=candout1(3,:);
    ii=find(c>=bet(1)&c<=bet(2));
    nn=length(ii);
    for  j = 1:7
        candout1(j,1:nn)=candout1(j,ii);
    end
    candout1=candout1(:,1:nn);
end

if icsd == 1
    c=candout1(4,:);
    ii=find(c>=sd(1)&c<=sd(2));
    nn=length(ii);
    for  j = 1:7
        candout1(j,1:nn)=candout1(j,ii);
    end
    candout1=candout1(:,1:nn);
end

if iccr == 1
    c=candout1(5,:);
    ii=find(c>=cr(1)&c<=cr(2));
    nn=length(ii);
    for  j = 1:7
        candout1(j,1:nn)=candout1(j,ii);
    end
    candout1=candout1(:,1:nn);
end

if icstr == 1
    candout.cand=candout1;
else
    candout=candout1;
end
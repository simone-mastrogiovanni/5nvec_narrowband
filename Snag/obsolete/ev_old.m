function [e,evch]=ev(inp,varargin)
%EV  event class constructor
%
%    Data members:
%            ev(i).t        time
%            ev(i).tm       time of the maximum
%            ev(i).chan     antenna
%            ev(i).chty     channel type
%            ev(i).chcf     channel central frequency
%            ev(i).chbw     channel bandwidth
%            ev(i).a        amplitude
%            ev(i).cr       critical ratio
%            ev(i).l        length
%            ev(i).ci       cluster index (0 default)
%            ev(i).shy      shape
%            ev(i).sht      shape initial time
%            ev(i).shdt     shape sampling time
%
%     if nargin = 1 :
%       inp (number) :   dimension of the ev array
%       inp (array of ev structure) :   events (sorts them)
%     if nargin > 1 -> simulation :
%       inp (number) :   dimension of the ev array
%       varargin(1)      ch (channel structure)
%          ch.an(nch)   antenna
%          ch.ty(nch)   type
%          ch.cf(nch)   central frequencies
%          ch.bw(nch)   bandwidth
%          ch.lm(nch)   lambdas
%          ch.cov(nch,nch)
%       varargin(2)      tobs (total observation time)

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998-2003  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

evch=0;
if nargin == 1
	if isa(inp,'double')
        e(inp).t=0;
        e(inp).tm=0;
        e(inp).ch=0;
        e(inp).a=0;
        e(inp).cr=0;
        e(inp).l=0;
        e(inp).ci=0;
        e(inp).shy=[];
        e(inp).sht=0;
        
        for i = 1:inp-1
            e(i).t=0;
            e(i).tm=0;
            e(i).ch=0;
            e(i).a=0;
            e(i).cr=0;
            e(i).l=0;
            e(i).ci=0;
            e(i).shy=[];
            e(i).sht=0;
        end  
	elseif isa(inp,'struct')
        n=length(inp);
        [t,i]=sort(inp.t);
        e(1:n)=inp(i(1:n));
	end
elseif nargin > 1
    n=inp;
    chstr=varargin{1};
    tobs=varargin{2};
    nchtot=length(chstr.an);
    nch=zeros(1,chstr.na);
    for i = 1:chstr.na
        nch(i)=length(find(chstr.an));
    end
    
    nlc=sum(chstr.lcn);
    nld=chstr.lml;
    nldtot=sum(nld);
    ngw=chstr.lmg;
    ntot=nlc+nldtot+ngw;
    fact=n/ntot
    nlc=round(nlc*fact);
    nld=round(nld*fact);
    nldtot=sum(nld);
    ngw=round(ngw*fact);
    
    tlc=rand(1,nlc)*tobs;
    tld=rand(1,nldtot)*tobs;
    tgw=rand(1,ngw)*tobs;
    
    maxev=nlc+sum(nld.*nch)+ngw*nchtot;
    
    e(maxev).t=0;
    e(maxev).tm=0;
    e(maxev).ch=0;
    e(maxev).a=0;
    e(maxev).cr=0;
    e(maxev).l=0;
    e(maxev).ci=0;
    e(maxev).shy=[];
    e(maxev).sht=0;
    dt=tobs/(n*1000);
    
    for i = 1:nlc
        dt1=dt*rand(1);
        a=randn(1).^2;
        e(i).t=tlc(i);
        e(i).tm=tlc(i)+dt1/2;
        e(i).ch=0;
        e(i).a=a;
        e(i).cr=a;
        e(i).l=dt1;
        e(i).ci=0;
        e(i).shy=[];
        e(i).sht=0;
    end
    
    kch=0;
    ii=nlc;
    kk=0;
    for j = 1:chstr.na
        for i = 1:nld(j)
            kk=kk+1;
            kch0=0;
            for k = 1:nch(j)
                kch=kch0+1;
                if rand(1) > chstr.lds(kch)
                    ii=ii+1;
                    dt1=dt*rand(1);
                    a=randn(1).^2;
                    e(ii).t=tld(kk);
                    e(ii).tm=tld(kk)+dt1/2;
                    e(ii).ch=0;
                    e(ii).a=a;
                    e(ii).cr=a;
                    e(ii).l=dt1;
                    e(ii).ci=0;
                    e(ii).shy=[];
                    e(ii).sht=0;
                end
            end
        end
    end
    
    for i = 1:ngw
        for k = 1:nchtot
            if rand(1) > chstr.lds(k)
                ii=ii+1;
                dt1=dt*rand(1);
                a=randn(1).^2;
                e(ii).t=tgw(i);
                e(ii).tm=tgw(i)+dt1/2;
                e(ii).ch=0;
                e(ii).a=a;
                e(ii).cr=a;
                e(ii).l=dt1;
                e(ii).ci=0;
                e(ii).shy=[];
                e(ii).sht=0;
            end
        end
    end
end

ii
e=e(1:ii);
e=class(e,'ev');
e=sort_ev(e);


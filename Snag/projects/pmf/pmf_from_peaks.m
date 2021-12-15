function [pmf t f]=pmf_from_peaks(A,bandw,kres)
% creates a pmf from peaks
%
%   pmf=pmf_from_peaks(A,bandw,kres)
%
%   A       input peaks (in gd2 or triple array)
%   bandw   bandwidth (starting from min fr)
%   kres    sub-band factor (integer; def 10)

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('kres','var')
    kres=10;
end

if isa(A,'gd2')
    A=gd2_to_peaks(A);
end

t=A(:,1);
t=sort(t);
it=find(diff(t));
it=[1 it'+1];
nit=length(it)
t=t(it);
nt=length(t);
minfr=min(A(:,2));
maxfr=max(A(:,2));
bandw1=bandw/kres;
fr=minfr;
n1=ceil((maxfr-minfr)/bandw);
n2=n1*kres;
np=zeros(nit,n1);
sp=np;
f=zeros(1,n1);
pmf=zeros(nit,n1);
j=0;

while fr < maxfr
    j=j+1; % j fr band
    disp(['while i ' num2str(j)])
    f(j)=fr+bandw/2;
    fr1=fr+bandw;
    for i = 1:nit
        ia=find(A(:,1) == t(i)); %disp(['while j ' num2str(j)])
        a=A(ia,2);
        ii=find(a >= fr & a < fr1);%size(a)
        if ~isempty(ii) 
            np=length(ii);
            sp=sum(a(ii));
            pmf(i,j)=sp/np;
        end
    end
    fr=fr+bandw1;
end


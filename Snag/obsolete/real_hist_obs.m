function g=real_hist(dat,gr,circ)
%REAL_HIST  real histogram
%
%   dat    data array
%   gr     circ = 0 -> grid central values
%          circ = 1 -> [period, number of bins, delay to add]
%   circ   = 1 circular domain    
%
%   g      real histogram gd

% Version 2.0 - June 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('circ')
    circ=0;
end

dat=dat(:);

if circ == 0
	n=length(gr);
	gr1(2:n+1)=gr;
	gr1(1)=2*gr(1)-gr(2);
	[nn,bin]=histc(dat,gr1);
	ii=find(bin);
	bin=bin(ii);
	dat=dat(ii);
	dat=dat(:)'-gr1(bin);
	
	g=gr1*0;
	
	for i=1:n
        ii=find(bin==i);
        g(i)=g(i)+sum(1-dat(ii));
        g(i+1)=sum(dat(ii));
	end
	
	figure
	gr0=(gr1(1:n)+gr1(2:n+1))/2;
	stairs(gr0,g(2:n+1));
	grid on
else
    per=gr(1);
    n=gr(2);
    del=gr(3);
    
    dat=mod(dat+del,per)*n/per;
    ndat=floor(dat)+1;
    a=dat-ndat+1;
	g=zeros(n+1,1);
	
	for i=1:n
        ii=find(ndat==i);
        g(i)=g(i)+sum(1-a(ii));
        g(i+1)=sum(a(ii));
	end
    
    g(1)=g(1)+g(n+1);
	
	figure
	gr=1:n;
	plot(gr,g(1:n));
	grid on
end

g=gd(g);
g=edit_gd(g,'x',gr,'capt','real histogram');
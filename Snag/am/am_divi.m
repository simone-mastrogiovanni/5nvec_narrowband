function amf=am_divi(am1,am2)
%AM_MULTI   filter cascading

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

b1(1)=am1.b0;
if am1.nb > 0
    b1(2:am1.nb+1)=am1.b;
end
a1(1)=1;
if am1.na > 0
    a1(2:am1.na+1)=am1.a;
end

b2(1)=am2.b0;
if am2.nb > 0
    b2(2:am2.nb+1)=am2.b;
end
a2(1)=1;
if am2.na > 0
    a2(2:am2.na+1)=am2.a;
end

a=conv(a1,b2);
b=conv(b1,a2);
a0=a(1);
a=a/a0;
b=b/a0;
na=length(a)-1;
nb=length(b)-1;

if na > 0
    amf.a=a(2:na+1);
end
if nb > 0
    amf.b=b(2:nb+1);
end
amf.b0=b(1);
amf.na=na;
amf.nb=nb;
amf.capt='concatenation';
amf.bilat=0;

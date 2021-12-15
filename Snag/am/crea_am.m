function amf=crea_am(typ,fr,tau)
%CREA_AM  interactive filter construction
%
%    amf=crea_am(typ,fr,tau)
%
%    typ      'null' 'high', 'low', 'resonance', 'resonance1', 'resonance2'
%             'resonance3', 'band-pass'
%    fr       frequency (normalized to sampling frequency)
%    tau      (in units of sampling time)

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

switch typ
    case 'null'
        amf.na=0;
        amf.nb=0;
        amf.bilat=0;
        amf.capt='null';
        amf.b0=1;
    case 'high'
        amf.na=1;
        amf.nb=1;
        amf.bilat=0;
        amf.capt='high pass';
        w=exp(-fr*2*pi);
        w1=(1+w)/2;
        amf.b0=w1;
        amf.b(1)=-w1;
        amf.a(1)=-w;
    case 'low'
        amf.na=1;
        amf.nb=0;
        amf.bilat=0;
        amf.capt='high pass';
        w=exp(-fr*2*pi);
        amf.b0=1-w;
        amf.a(1)=-w;
    case 'resonance1'
        amf.na=2;
        amf.nb=0;
        amf.bilat=0;
        amf.capt='resonance';
        r=exp(-1/tau);
        teta=fr*2*pi;
        amf.b0=1;
        amf.a(1)=-2*r*cos(teta);
        amf.a(2)=r*r;
    case 'resonance'
        amf.na=2;
        amf.nb=1;
        amf.bilat=0;
        amf.capt='resonance';
        r=exp(-1/tau);
        teta=fr*2*pi;
        amf.b0=0;
        amf.b(1)=r*sin(teta);
        amf.a(1)=-2*r*cos(teta);
        amf.a(2)=r*r;
    case 'resonance2' % left and right down
        amf.na=2;
        amf.nb=1;
        amf.bilat=0;
        amf.capt='resonance';
        r=exp(-1/tau);
        teta=fr*2*pi;
        amf.b0=1;
        amf.b(1)=-1;
        amf.a(1)=-2*r*cos(teta);
        amf.a(2)=r*r;
    case 'resonance3'
        amf.na=2;
        amf.nb=2;
        amf.bilat=0;
        amf.capt='resonance';
        r=exp(-1/tau);
        teta=fr*2*pi;
        amf.b0=1;
        amf.b(1)=0;
        amf.b(2)=-1;
        amf.a(1)=-2*r*cos(teta);
        amf.a(2)=r*r;
    case 'band-pass' % empirical formula, bilateral
        aa=2*(0.5+tau*cos(fr*pi))/(1+tau)^2;
        amf.na=2;
        amf.nb=1;
        amf.bilat=0;
        amf.capt='resonance';
        r=exp(-1/tau);
        teta=fr*2*pi;
        amf.b0=aa;
        amf.b(1)=-aa;
        amf.a(1)=-2*r*cos(teta);
        amf.a(2)=r*r;
        amf.bilat=1;
end
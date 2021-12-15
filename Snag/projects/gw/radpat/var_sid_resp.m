function v=var_sid_resp(type,antenna,source,n)
%VAR_SID_RESP  variable parameters for sidereal response for gravitational antennas
%
%   ATTENTION: old epsilon definition !
%
%   type             'lat','eps','d'
%   antenna,source   pss structures
%   n                number of values

% Version 2.0 - August 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

np=1024;
na=7;
v=zeros(n,na);
switch type
    case 'lat'
        dn=180/(n-1);
        for i =0:n-1
            antenna.lat=-90+i*dn;
            a=sid_resp(antenna,source,np);
            f=fft(a);
            v(i+1,:)=abs(f(1:na));
        end
    case 'eps'
        dn=1/(n-1);
        for i =0:n-1
            source.eps=0+i*dn;
            a=sid_resp(antenna,source,np);
            f=fft(a);
            v(i+1,:)=abs(f(1:na));
        end
    case 'd'
        dn=180/(n-1);
        for i =0:n-1
            source.d=-90+i*dn;
            a=sid_resp(antenna,source,np);
            f=fft(a);
            v(i+1,:)=abs(f(1:na));
        end
end

figure
plot(v');
figure
image(v)
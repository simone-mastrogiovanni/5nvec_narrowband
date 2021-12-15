function [eta psi]=etapsi_from2comp(ka,kb,cont,icverb)
% ETAPSI_FROM2COMP  computes eta and psi from 2 complex components
%
%    [eta psi]=etapsi_from2comp(v5A,v5B,cont)
%
%    ka,kb     components (complex)
%    cont      1 -> lin base, 2 -> circ base
%    icverb    > 0, verbose

% Version 2.0 - August 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('icverb','var')
    icverb=0;
end

norm=sqrt(abs(ka)^2+abs(kb)^2);
ka0=ka/norm;
kb0=kb/norm;

if cont == 1
    kk=ka0*conj(kb0);

    A=real(kk);
    B=imag(kk);
    C=abs(ka0)^2-abs(kb0)^2;

    discr=1-4*B^2;
    if discr < 0
        fprintf(' *** Error ! negative discriminant !  B = %f \n',B)
    end

    eta=(-1+sqrt(discr))/(2*B);
    alf=atan2(2*A,C)*180/pi;
    if alf < 0
        alf=alf+360;
    end
    psi=alf/4;
else
    kk=ka0/kb0;
    A=abs(kk);
    B=-angle(kk)*180/pi;
    eta=(A-1)/(A+1);
    if B < 0
        B=B+360;
    end
    psi=B/4;
end

if icverb > 0
    if cont == 1
        fprintf('LIN:  |vA0|^2,|vB0|^2,|v|^2,eta,psi = %f %f %f  %f %f \n',abs(ka0)^2,abs(kb0)^2,norm^2,eta,psi);
    else
        fprintf('CIRC: |vA0|^2,|vB0|^2,|v|^2,eta,psi = %f %f %f  %f %f \n',abs(ka0)^2,abs(kb0)^2,norm^2,eta,psi);
    end
end
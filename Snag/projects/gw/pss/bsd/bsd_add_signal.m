function [out,sig]=bsd_add_signal(in,sigstr)
% adds a signal to a bsd
%
%   in      input bsd
%   sigstr  signal structure (as modstr)
%      sigstr  modification structure or a cell array with more than one mod. struct
%             .typ 'sinsig' 'source' 'tsig' 'sweep' 'secs'
%         typ 'sinsig'  sinusoidal signal
%             .t00  .fr  .ph  .amp
%         typ 'source'  periodic source
%             .sour  the source structure, .phs  .A
%         typ 'tsig'    time signal (same in some bands)
%             .t00  .shape  .bands 
%         typ 'sweep'  frequency sweep (fr should grow very slowly)
%             .t00  .fr0   .dfr  .amp
%         typ 'secs'  super-chirp (fr should grow very slowly)
%             .t00 
%         .nohole = 1   doesn't nullifies the holes 

% Snag Version 2.0 - February 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

nms=1;
if iscell(sigstr)
    csigstr=sigstr;
    nms=length(csigstr);
    if nms == 1
        sigstr=csigstr{1};
    end
end

y=y_gd(in);
sig=y*0;
n=n_gd(in);
dt=dx_gd(in);
cont=ccont_gd(in);
t0=cont.t0;
inifr=cont.inifr;
finfr=inifr+cont.bandw;
 
switch sigstr.typ
    case 'sinsig'
        t00=sigstr.t00;
        fr=sigstr.fr;
        phr=sigstr.ph*pi/180;
        amp=sigstr.amp;

        if fr >= inifr && fr <= finfr
            t1s=diff_mjd(t00,t0);t1s
%                 ph1=mod(t1s*fr*360+ph,360)*pi/180;
            sig=sig+amp*exp(1j*mod((t1s+(0:n-1)'*dt)*(fr-inifr)*2*pi+phr,2*pi));
        end
    case 'source'
        sour=sigstr.sour;
        phs=sigstr.phs;
        if isfield(sigstr,'A')
            A=sigstr.A;
        else
            A=sour.h;
            sigstr.A=A;
        end
        sbsd=bsd_softinj(gin,sour,0,A);
        sig=y_gd(sbsd)+sig;
    case 'tsig'
        t00=sigstr.t00;
        shape=sigstr.shape;
        bands=sigstr.bands;
    case 'sweep'
        t00=sigstr.t00;
        fr0=sigstr.fr0;
        dfr=sigstr.dfr;
        amp=sigstr.amp;
    case 'secs'
        t00=sigstr.t00;
        t1s=diff_mjd(t00,t0);
        sig=t1s+(0:n-1)'*dt;
    otherwise
        fprintf(' *** Error modif type %s \n',sigstr.typ)
end
    
out=edit_gd(in,'y',y+sig);
% out=bsd_zeroholes(out);
out=bsd_zeroholes(out,in);
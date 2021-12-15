function out=bsd_acc_modif(in,modstr)
% modifies accessed bsd
%
%    out=bsd_acc_modif(in,modstr)
%
%   in         input bsd (typically same as out)
%   modstr     modification structure or a cell array with more than one mod. struct
%         .typ 'sinsig' 'source' 'tsig' 'sweep' 'secs'
%     typ 'sinsig'  sinusoidal signal
%         .t00  .fr  .ph  .amp
%     typ 'source'  periodic source
%         .sour  the source structure, .phs  .A
%     typ 'tsig'    time signal (same in some bands)
%         .t00  .shape  .bands 
%     typ 'sweep'  frequency sweep (fr should grow very slowly)
%         .t00  .fr0   .dfr  .amp
%     typ 'secs'  super-chirp (fr should grow very slowly)
%         .t00 
%     .nohole = 1   doesn't nullifies the holes 

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

nms=1;
if iscell(modstr)
    cmodstr=modstr;
    nms=length(cmodstr);
    if nms == 1
        modstr=cmodstr{1};
    end
end

if isempty(modstr)
    disp('No modif structure')
    out=in;
    return
end

nohole=0;
if isfield(modstr,'nohole')
    if modstr.nohole > 0
        nohole=1;
    end
end

y=y_gd(in);
y=y*0;
n=n_gd(in);
dt=dx_gd(in);
cont=ccont_gd(in);
t0=cont.t0;
inifr=cont.inifr;
finfr=inifr+cont.bandw;

ims=1;
while ims <= nms
%     if ims > 1
    if nms > 1  % corr Sab dec17
        modstr=cmodstr{ims};
    end
    
    switch modstr.typ
        case 'sinsig'
            t00=modstr.t00;
            fr=modstr.fr;
            phr=modstr.ph*pi/180;
            amp=modstr.amp;
            
            if fr >= inifr && fr <= finfr
                t1s=diff_mjd(t00,t0);t1s
%                 ph1=mod(t1s*fr*360+ph,360)*pi/180;
                y=y+amp*exp(1j*mod((t1s+(0:n-1)'*dt)*(fr-inifr)*2*pi+phr,2*pi));
            end
        case 'source'
            sour=modstr.sour;
            phs=modstr.phs;
            if isfield(modstr,'A')
                A=modstr.A;
            else
                A=sour.h;
                modstr.A=A;
            end
            sbsd=bsd_softinj(in,sour,phs,A);
            y=y_gd(sbsd)+y;
        case 'tsig'
            t00=modstr.t00;
            shape=modstr.shape;
            bands=modstr.bands;
        case 'sweep'
            t00=modstr.t00;
            fr0=modstr.fr0;
            dfr=modstr.dfr;
            amp=modstr.amp;
        case 'secs'
            t00=modstr.t00;
            t1s=diff_mjd(t00,t0);t1s
            y=t1s+(0:n-1)'*dt;
        otherwise
            fprintf(' *** Error modif type %s \n',modstr.typ)
    end
    
    ims=ims+1;
end

clear sbsd

out=edit_gd(in,'y',y+y_gd(in));

if nohole == 0
    out=bsd_zeroholes(out,in);
end
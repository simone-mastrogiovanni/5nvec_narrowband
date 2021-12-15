function out=bsd_tfstr_extr(addr,tab,datyp)
% extracts data from tfstr
%
%  out=bsd_tfstr_extr(addr,tabl,datyp)
%
%   addr    BSD path(without final dirsep, ex.: 'I:')  
%   tab     BSD sub-table (to create a BSD sub-table use
%            [tab_out,epoch0,maxt]=bsd_extr_subtab(tab,tim,fr)
%   datyp   data type ('hdens' 'wn' 'peaks' 'npeaks' 'persist' 'persist0'
%            'tfhist' 'tfhist0')

% Version 2.0 - January 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

files=file_tab_bsd(addr,tab);

nf=length(files);

for i = 1:nf
    [pathstr,name,ext]=fileparts(files{i});disp(name)
    load(files{i});
    eval(['cont=cont_gd(' name ');']);
    t0=cont.t0;
    fmin=cont.inifr;
    fmax=cont.inifr+cont.bandw;
    if i == 1
        t00=t0;
        f00=fmin;
        bandw=cont.bandw;
        eval(['dt=dx_gd(' name ');']);
    end
    
    tfstr=cont.tfstr;
    
    switch datyp
        case 'hdens'
        case 'wn'
        case 'peaks'
        case 'npeaks'
        case 'persist'
            nfr=tfstr.clean.nfr;
            dfr=bandw/nfr;
            if i == 1
                out=tfstr.clean.persist;
                Nfr=nfr;
                xout=(0:nfr-1)*dfr+fmin;
            else
                out(Nfr+1:Nfr+nfr)=tfstr.clean.persist;
                xout(Nfr+1:Nfr+nfr)=(0:nfr-1)*dfr+fmin;
                Nfr=Nfr+nfr;
            end
        case 'persist0'
            nfr=tfstr.clean.nfr;
            dfr=bandw/nfr;
            if i == 1
                out=tfstr.clean.persist0;
                Nfr=nfr;
                xout=(0:nfr-1)*dfr+fmin;
            else
                out(Nfr+1:Nfr+nfr)=tfstr.clean.persist0;
                xout(Nfr+1:Nfr+nfr)=(0:nfr-1)*dfr+fmin;
                Nfr=Nfr+nfr;
            end
        case 'tfhist'
        case 'tfhist0'
    end
    clear(name);
end

switch datyp
    case 'hdens'
    case 'wn'
    case 'peaks'
    case 'npeaks'
    case 'persist'
        out=gd(out);
        out=edit_gd(out,'x',xout);
    case 'persist0'
        out=gd(out);
        out=edit_gd(out,'x',xout);
    case 'tfhist'
    case 'tfhist0'
end
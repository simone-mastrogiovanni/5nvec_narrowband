function [out,sbpar]=bsd_subband_lego(in,sbpar)
% extract band (output signal is complex)
%  [similar to extr_band]
%
%    out=bsd_subband_lego(in,sbpar)
%
%   in      input gd (type 1)
%   sbpar   sub-band parameters structure
%
% ATTENTION ! the samples start since the 0 hour of the first day of the run
%             so, the first sample of the file can be advanced: in this
%             case the first sample is a 0.

% Version 2.0 - December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y=y_gd(in);
dt0=dx_gd(in);
ny=n_gd(in);
if ny ~= length(y)
    fprintf(' *** ERROR ! ny = %d  but %d elements \n',ny,length(y))
    error(' *** ERROR ! ny = %d  but %d elements \n',ny,length(y))
end
cont=cont_gd(in);
if isfield(cont,'tfstr')
    if isfield(cont.tfstr,'zeros')
        zeros1=cont.tfstr.zeros;
        [nz1,~]=size(zeros1);
    end
    cont.tfstr=[];
    cont.tfstr.zeros=zeros1;
end
t0=cont.t0;
ts1=mjd2gps(t0);
ts2=ts1+dt0*ny;
if sbpar.tsbase == 0
    sbpar.tsbase=ts1;
end
sbpar.ts1=ts1-sbpar.tsbase;
sbpar.ts2=ts2-sbpar.tsbase;
sbpar.Ts=ts2-ts1; 

band=sbpar.band;
Nfft0=sbpar.Nfft;
dt=sbpar.dt;
dfr=sbpar.dfr;
i1=sbpar.if1;
i2=sbpar.if2; 
sbpar.ny=ny;
sbpar.nout=round(sbpar.Ts/dt);
nred=sbpar.nout;
bandw=band(2)-band(1);

y=fft(y,Nfft0);
y=y(i1:i2);
reduce=(i2-i1)/Nfft0; 
y=ifft_cut(y,nred)*reduce;
out=edit_gd(in,'dx',dt,'y',y);

cont.inifr=band(1);
cont.bandw=bandw;
cont.sb_pars=sbpar;

out=edit_gd(out,'cont',cont);

out=bsd_zeroholes(out,in);
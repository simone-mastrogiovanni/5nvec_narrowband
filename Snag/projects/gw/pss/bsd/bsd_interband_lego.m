function bsd_out=bsd_interband_lego(addr,tab,band,tim,sbpar,modif)
% inter-band reconstruction

% Snag Version 2.0 - December 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('modif','var')
    modif=[];
end
file=file_tab_bsd(addr,tab);
nfiles=length(file)';

Nfft=sbpar.Nfft;
Nfft0=sbpar.Nfft0;
Nfft1=Nfft0/2;
if1=sbpar.if1;
if2=sbpar.if2;
y=zeros(1,Nfft0);sbpar,Nfft1

for i = 1:2:nfiles
    [in1, name1]=load_tab_bsd(addr,tab,i,modif);
    [in2, name2]=load_tab_bsd(addr,tab,i+1,modif);
    cont=cont_gd(in1);
    dt2=dx_gd(in1)/2;
    y1=y_gd(in1);
    y2=y_gd(in2);
    y(1:Nfft1)=fft(y1,Nfft1);
    y(Nfft1+1:Nfft0)=fft(y2,Nfft1);
    y=ifft(y);
    in=gd(y);
    cont.bandw=cont.bandw*2;
    in=edit_gd(in,'dx',dt2,'cont',cont);
    
    sb=bsd_subband_lego(in,sbpar);
    
    if isfield(cont,'tfstr')
        if isfield(cont.tfstr,'zeros')
            sb=bsd_zeroholes(sb);
        end
    end

    if exist('modifpost','var')
        sb=bsd_acc_modif(sb,modifpost);
    end
    if i == 1
        bsd_out=sb; 
    else
        bsd_out=conc_bsd(bsd_out,sb)
    end
end
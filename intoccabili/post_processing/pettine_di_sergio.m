function outcome=pettine_di_sergio(gg,freq,gg2)

% gg: Input gd
% freq: frequency of the outlier

X_signal=compute_5vect_simo(gg,freq);
y_data=y_gd(gg);
y_data=y_data.';
dt=dx_gd(gg);
cont=cont_gd(gg);
FS=1/86164.09053083288; %$ Sidereal frequency


shifttime=cont.shiftedtime;


Tobs=length(y_data)*dt;
binfsid=1/Tobs;
nbin_fs=round(FS/binfsid);

fra=0:binfsid:1-binfsid;
%$ COMPUTE FFTs OF  DATA $$$$
signalfft1=fft(y_data)/length(y_data);
signalfft1_shift=signalfft1.*exp(-1j*2*pi*fra*shifttime); % Adjust the frequency components to the new reference time
signalfftshifted=-(1.0/4.0)*pi*diff(signalfft1); % Interpolate the interbin frequency components
signalfft1=signalfft1_shift;
signalfftshifted=[signalfftshifted,0];
signalfftshifted=signalfftshifted.*exp(-1j*2*pi*(fra+0.5*binfsid)*shifttime); % Adjust the interbin  frequency components to the new reference time



m2=1:length(signalfft1)-4*nbin_fs; % Identify position of k=-2 components of the 5-vectors
m1=m2+nbin_fs;
m0=m1+nbin_fs;
p1=m0+nbin_fs;
p2=p1+nbin_fs;

pentasignalfft=[ signalfft1(m2); signalfft1(m1); signalfft1(m0); signalfft1(p1); signalfft1(p2) ];
pentasignalfftshifted=[ signalfftshifted(m2); signalfftshifted(m1); signalfftshifted(m0); signalfftshifted(p1); signalfftshifted(p2) ];

out_signal_fft=((pentasignalfft).')*conj(X_signal).';
fra_true=2*FS:binfsid:1-2*FS;
figure;plot(fra_true,abs(out_signal_fft))
out_signal_fft_shifted=((pentasignalfftshifted).')*conj(X_signal).';
figure;plot(fra_true,abs(out_signal_fft_shifted))

if exist('gg2','var')
    
    X_signal=compute_5vect_simo(gg2,freq);
    y_data=y_gd(gg2);
    y_data=y_data.';
    dt=dx_gd(gg2);
    cont=cont_gd(gg2);
    FS=1/86164.09053083288; %$ Sidereal frequency
    
    
    shifttime=cont.shiftedtime;
    
    
    Tobs=length(y_data)*dt;
    binfsid=1/Tobs;
    nbin_fs=round(FS/binfsid);
    
    fra=0:binfsid:1-binfsid;
    %$ COMPUTE FFTs OF  DATA $$$$
    signalfft1=fft(y_data);
    signalfft1_shift=signalfft1.*exp(-1j*2*pi*fra*shifttime); % Adjust the frequency components to the new reference time
    signalfftshifted=-(1.0/4.0)*pi*diff(signalfft1); % Interpolate the interbin frequency components
    signalfft1=signalfft1_shift;
    signalfftshifted=[signalfftshifted,0];
    signalfftshifted=signalfftshifted.*exp(-1j*2*pi*(fra+0.5*binfsid)*shifttime); % Adjust the interbin  frequency components to the new reference time
    
    
    
    m2=1:length(signalfft1)-4*nbin_fs; % Identify position of k=-2 components of the 5-vectors
    m1=m2+nbin_fs;
    m0=m1+nbin_fs;
    p1=m0+nbin_fs;
    p2=p1+nbin_fs;
    
    pentasignalfft=[ signalfft1(m2); signalfft1(m1); signalfft1(m0); signalfft1(p1); signalfft1(p2) ];
    pentasignalfftshifted=[ signalfftshifted(m2); signalfftshifted(m1); signalfftshifted(m0); signalfftshifted(p1); signalfftshifted(p2) ];
    
    out_signal_fft2=((pentasignalfft).')*conj(X_signal).';
    fra_true=2*FS:binfsid:1-2*FS;
    figure;plot(fra_true,abs(out_signal_fft2),'g')
    out_signal_fft_shifted2=((pentasignalfftshifted).')*conj(X_signal).';
    figure;plot(fra_true,abs(out_signal_fft_shifted2),'g')
    
    
    
    out_total=abs(out_signal_fft2).*abs(out_signal_fft2);
    
    out_total_s=abs(out_signal_fft_shifted2).*abs(out_signal_fft2);
    
    
    figure;plot(fra_true,abs(out_total),'k')
    figure;plot(fra_true,abs(out_total_s),'k')
    
    
end



end
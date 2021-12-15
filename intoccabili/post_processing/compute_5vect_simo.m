
function X=compute_5vect_simo(gg,freq)

% gg gd computed from narrow-band algrotighm
% freq central frequency (fraction part)

FS=1/86164.09053083288; %$ Sidereal frequency
y=y_gd(gg);
y=y.';
freq=freq+(-2:1:2)*FS;
cont=cont_gd(gg);
shift=cont.shiftedtime;
dt=dx_gd(gg);
for i=1:1:5
X(i)=sum(y.*exp(-1i*2*pi*freq(i)*dt*(0:length(y)-1))*dt); 
X(i)=X(i)*exp(-1j*2*pi*freq(i)*shift)/length(y);
end

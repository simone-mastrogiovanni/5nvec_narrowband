function out_tsp=s_stft(varargin)

g=varargin{1};

n=n_gd(g);
dt=dx_gd(g);
y=y_gd(g);

frmax0=0.5/dt;
sfr=sprintf('%f',frmax0);
   
lfft=1024;

lfft=sprintf('%d',lfft);
leng=sprintf('%d',length(y));


answ=inputdlg({ 'Length of an fft ? (not variable for simulation)' ...
   'Number of data samples (default is length of gd) ?' ...
   'Window Type (1-5)'...
   'Window Length'...
   'Step'...
   'Lower frequency ?' 'Higher frequency ?'},...
   'STFT',1,...
   {lfft leng '1' lfft '10' '0' sfr});

lfft=eval(answ{1});
lensin=eval(answ{2});
wind=eval(answ{3});
wind_leng=eval(answ{4});
step=eval(answ{5});
frmin=eval(answ{6});
frmax=eval(answ{7});

if((wind < 1) | (wind > 5))
   wind=1;
   disp('Wind = 1-5, Wind set to 1');
end

if ((step < 1) | (round(step) ~= step))
   step=1;
   disp('Step must be an integer and > 0. Step set to 1');
end

if (lfft < wind_leng)
   wind_leng = lfft;
   disp('Length of FFT must almost be equal to Wind_leng. Length of FFT set to Wind_leng');
end

if (wind == 1)
   WIN = ones(1,wind_leng);
   disp('Rectangular Window will be used');
elseif (wind ==2)
   WIN = hamming(wind_leng)';
   disp('Hamming Window will be used');
elseif (wind == 3)
   WIN = hanning(wind_leng)';
   disp('Hanning Window will be used');
elseif (wind == 4)
   WIN = blackman(wind_leng)';
   disp('Blackman Window will be used');
elseif (wind == 5)
   WIN = triang(wind_leng)';
   disp('Triangular Window will be used');
end

n=floor(lensin/step);
lensin=n*step;
dslen=100*step;

t_img = (ceil(lensin/dslen)-1)*100;

if (lfft/2 == round(lfft/2))     % pari
   f_img = (lfft/2) + 1;
else
   f_img = ceil(lfft/2);         % dispari
end

amap=zeros(f_img,t_img);
rglen=2*max(dslen,lensin);
typ=1;
i=0;
index=1:100;

fprintf('ceil(lensin/dslen)-1 = %d \n',ceil(lensin/dslen)-1);
fprintf('dslen = %d \n',dslen);
fprintf('lensin = %d \n',lensin);
fprintf('dim of amap = %d %d \n',f_img,t_img);
fprintf('dim of stft_ds = %d %d \n',f_img,100);

dstype=1;
d=ds(dslen);
d=edit_ds(d,'dt',dt,'type',dstype);

d=gd2ds(d,g);

for i=1:ceil(lensin/dslen)-1
   
   d=gd2ds(d,g);
   if i==1
       index=index;
   else
       index=index+100;
   end
   amap(:,index)=stft_ds(d,WIN,wind_leng,step,f_img,lfft);
end

fprintf('F = (abs(fft(YSIN,lfft)).^2)/length(YSIN) \n');
dx=dt*dslen/typ;
dx2=1/(dt*lfft);
out_tsp=gd2(amap');
frmin1=0;
out_tsp=edit_gd2(out_tsp,'dx',dx,'dx2',dx2,'ini2',frmin1);
select_mapgd2(out_tsp);
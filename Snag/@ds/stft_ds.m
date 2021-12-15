function out=stft_ds(d,WIN,wind_leng,step,f_img,lfft)

kds=d.lcw;
len=d.len;

%if kds == d.nc1
   y1=d.y1(1:d.len);
%else
   y2=d.y2(1:d.len);
%end
   
  SINT=[y2 y1(1:wind_leng)];
  i=0;
  out=zeros(f_img,length(1:step:len));
  
for k = 1:step:len
   i=i+1;
   XSIN = SINT(k:(k + wind_leng -1));
   YSIN = XSIN .* WIN;
   %YSIN = YSIN-sum(YSIN)/length(YSIN);
   %F = (abs(fft(YSIN,lfft)).^2);
   F = (abs(fft(YSIN,lfft)).^2)/length(YSIN);
   out(:,i) = F(1:f_img)';
end


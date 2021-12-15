function stat=event_finder(y,mode,stat,folder,fileev,filest)
%DS/EVENT_FINDER  event finder on an array
%
%   The function can be used iteratively.
%
%    y      input array (typically from a non-interlaced ds)
%
%    mode   mode vector (input):
%              mode(1) = 0 no event
%                      = 1 find events
%                      = 2 also shape of events
%              mode(2) = 0 no statistics
%                      = 1 AR statistics
%                      = 2 rectangular statistics
%              mode(3) = initial time (in days)
%              mode(4) = dt (in seconds)
%              mode(5) = tau (in seconds)
%              mode(6) = CR threshold
%					mode(7) = dead time (in seconds)
%					mode(8) = statistics sampling time (seconds; e.g. 60)
%					mode(9) = time bias;
%
%    stat   status vector (to be zeroed before start)
%              stat(1) = AR sum on x 
%              stat(2) = AR sum on x^2
%              stat(3) = sum on x
%              stat(4) = sum on x^2
%              stat(5) = iteration index
%              stat(6) = dead time counter;
%              stat(7) = last statistics time !! DA USARE POI
%              stat(8) = statistics counter
%              stat(9) = w
%              stat(10)= AR sum on 1
%              stat(11)= status (0 normal; 1 event)
%              stat(12)= event beginning time
%              stat(13)= max amplitude
%              stat(14)= event length
%              stat(15)= integral
%              stat(16)= integral square
%					stat(17)= integral modulus
%              stat(18)= event max time
%              stat(19)= event CR
%              stat(20)= number of events
%              stat(21)= event file id
%              stat(22)= statistics file id
%              stat(23)= 
%              stat(24)= 
%              stat(25)= integral (last samples)
%              stat(26)= integral square (last samples)
%              stat(27)= integral modulus (last samples)
%              stat(28)= 
%              stat(29)= 
%              stat(30)= 
%
%    folder  where to put files
%
%    fileev  events file
%
%    filest  statistics file

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;
fidev=[scratchdata fileev];
fidst=[scratchdata filest];

if stat(5) == 0
   w=exp(-mode(4)/mode(5));
   for i = 1:22
      stat(i)=0;
   end
   
   stat(9)=w;
      
   fidev=fopen(fidev,'w');
   fidst=fopen(fidst,'w');
   stat(21)=fidev;
   stat(22)=fidst;
else
   fidev=fopen(fidev,'a');
   fidst=fopen(fidst,'a');
end

tinit=mode(3);
dt=mode(4);
len=length(y);
thresh=mode(6);
detim=mode(7);
statim=mode(8);
timbias=mode(9);
istatim=statim/dt;  %  ATTENZIONE, migliorare !

w=stat(9);
s=stat(1);
ss=stat(2);
r=stat(3);
rr=stat(4);
ii=stat(5);
detimcount=stat(6);
lastatim=stat(7);
scount=stat(8);
norm=stat(10);

tim=stat(12);
elen=stat(13);
emax=stat(14);
ieven=stat(15);
iseven=stat(16);
imeven=stat(17);
timax=stat(18);
creven=stat(19);
nev=stat(20);

fidev=stat(21);
fidst=stat(22);

ieven1=stat(25);
iseven1=stat(26);
imeven1=stat(27);

yy=y.^2;

%y1=zeros(1,len);
%y2=zeros(1,len);
cr=0;

for i = 1:len
   ii=ii+1;
   s=y(i)+w*s;
   ss=yy(i)+w*ss;
   norm=1+w*norm;
   armean=s/norm;
   arstdev=sqrt((ss-(s.*s)./norm)/norm);
%   y1(i)=armean;
%   y2(i)=arstdev;
   r=y(i)+r;
   rr=yy(i)+rr;
   
   if arstdev > 0
      cr=abs(y(i)-armean)/arstdev;
   end
   
   if cr >= thresh
      if stat(10) == 0
         tim=tinit-timbias+(i-1)*dt/86400;
         nev=nev+1;
         elen=0;
      	emax=0;
      	ieven=0;
      	iseven=0;
      	imeven=0;
      	creven=cr;
      end
      stat(10)=1;
      detimcount=detim;
      ieven1=-y(i);
      iseven1=-yy(i);
      imeven1=-abs(y(i));
      creven=cr;
   end
   
   if stat(10) == 1
      detimcount=detimcount-1;
      elen=elen+dt;
      if abs(y(i)) > abs(emax)
         emax=y(i);
         creven=cr;
         timax=tinit-timbias+(i-1)*dt/86400;
      end
      ieven=ieven+y(i);
      iseven=iseven+yy(i);
      imeven=imeven+abs(y(i));
      ieven1=ieven1+y(i);
      iseven1=iseven1+yy(i);
      imeven1=imeven1+abs(y(i));

      if detimcount <= 0
      	stat(10)=0;
         elen=elen-detim+dt;
         ieven=ieven-ieven1;
         iseven=iseven-iseven1;
         imeven=imeven-imeven1;
      
      	fprintf(fidev,'%d %f %f %f %f %f %f %f %f \n',...
         nev,tim,timax,elen,emax,creven,ieven,iseven,imeven);
   	end 
   end
   
   if mode(2) > 0
      scount=scount+1;
      if scount >= istatim
         scount=0;
         lastatim=tinit-timbias+(i-1)*dt/86400;
         if mode == 1
            fprintf(fidst,'%f %f %f \n',lastatim,armean,arstdev);
         else
            rmean=r/istatim;
   			rstdev=sqrt((rr-(r.*r)./istatim)/istatim);
            fprintf(fidst,'%f %f %f \n',lastatim,rmean,rstdev);
            r=0;rr=0;
         end
      end
   end
end

%nev

stat(1)=s;
stat(2)=ss;
stat(3)=r;
stat(4)=rr;
stat(5)=ii;
stat(6)=detimcount;
stat(7)=lastatim;
stat(8)=scount;
stat(10)=norm;

stat(12)=tim;
stat(13)=elen;
stat(14)=emax;
stat(15)=ieven;
stat(16)=iseven;
stat(17)=imeven;
stat(18)=timax;
stat(20)=nev;

stat(25)=ieven1;
stat(26)=iseven1;
stat(27)=imeven1;

fclose(fidev);
fclose(fidst);
   
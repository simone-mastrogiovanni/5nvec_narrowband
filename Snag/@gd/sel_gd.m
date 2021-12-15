function a=sel_gd(b,amp,ind,absc)
%GD/SEL_GD   selection in amplitude, index and abscissa
%
%      a=sel_gd(b,amp,ind,absc)
%
%      a=sel_gd(b...)
%
%      amp, ind, absc: arrays containing the min and max of
%                      amplitude, index, abscissa.
%                      If max < min exclude the band.
%                      min=max does nothing;
%      amp    min, max amplitude, mode (0 zeroes, 1 last value, 2 cut)
%      ind    min, max index
%      absc   min, max abscissa
%
% if any of amp, ind and absc is 0, no selection on that parameter

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;
ampmin=min(a.y);
ampmax=max(a.y);
n=a.n;
x=x_gd(a);
xmin=x(1);
xmax=x(n);

if ~exist('amp')
   eps=(ampmax-ampmin)/1000;
   mins=sprintf('%f',ampmin-eps);
   maxs=sprintf('%f',ampmax+eps);

	answ1=inputdlg({'Min amplitude' 'Max amplitude'...
   	'Mode (0 zeroes, 1 last value, 2 cut)'},...
   	'Amplitude selection (max<min -> band exclusion)',1,...
   	{mins maxs '0'});

	amp(1)=eval(answ1{1});
	amp(2)=eval(answ1{2});
	amp(3)=eval(answ1{3});
elseif length(amp) == 1
        amp(2)=amp(1);
end

if ~exist('ind')
   maxs=sprintf('%d',n);

	answ1=inputdlg({'Min index' 'Max index'}',...
   	'Index selection (max<min -> band exclusion)',1,...
   	{'1' maxs});

	ind(1)=eval(answ1{1});
	ind(2)=eval(answ1{2});
elseif length(ind) == 1
        ind(2)=ind(1);
end

if ~exist('absc')
   eps=(xmax-xmin)/1000;
   mins=sprintf('%f',xmin-eps);
   maxs=sprintf('%f',xmax+eps);

	answ1=inputdlg({'Min abscissa' 'Max abscissa'},...
   	'Abscissa selection (max<min -> band exclusion)',1,...
   	{mins maxs});

	absc(1)=eval(answ1{1});
	absc(2)=eval(answ1{2});
elseif length(absc) == 1
        absc(2)=absc(1);
end

if ind(1) < ind(2)
   a.y=a.y(ind(1):ind(2));
   if a.type == 2
      a.x=a.x(ind(1):ind(2));
   else
      a.ini=a.ini+(ind(1)-1)*a.dx;
   end
   a.n=length(a.y);
elseif ind(1) > ind(2)
   if a.type == 1;
      a.type=2;
      disp(' * gd type 2 created !');
      a.x=a.ini+a.dx.*(0:a.n-1);
   end
   bn0=a.n;
   a.n=bn0-(ind(1)-ind(2)-1);
   a.y(ind(2):a.n)=a.y(ind(1)+1:bn0);
   a.x(ind(2):a.n)=a.x(ind(1)+1:bn0);
end

if absc(1) < absc(2)
   ii=0;
   x=x_gd(a);
   for i = 1:a.n
      if  x(i) >= absc(1) & x(i) <= absc(2)
         ii=ii+1;
         xx(ii)=x(i);
         a.y(ii)=a.y(i);
      end
   end
   if a.type == 1
      a.ini=xx(1);
   else
      a.x=xx;
   end
   a.n=ii;
elseif absc(1) > absc(2)
   if a.type == 1;
      a.type=2;
      disp(' * gd type 2 created !');
      a.x=a.ini+a.dx.*(0:a.n-1);
   end
   ii=0;
   x=x_gd(a);
   for i = 1:a.n
      if  x(i) <= absc(1) | x(i) >= absc(2)
         ii=ii+1;
         a.x(ii)=x(i);
         a.y(ii)=a.y(i);
      end
   end
   a.n=ii;
end


if amp(1) < amp(2)
   if amp(3) == 2
      if a.type == 1
	      a.type=2;
   	   disp(' * gd type 2 created !');
         a.x=a.ini+a.dx.*(0:a.n-1);
      end
      
      ii=0;
      for i = 1:a.n
         if a.y(i) >= amp(1) & a.y(i) <= amp(2)
            ii=ii+1;
            a.y(ii)=a.y(i);
            a.x(ii)=a.x(i);
         end
      end
      a.n=ii;
   else
      aa=0;
      for i = 1:a.n
         if a.y(i) < amp(1) | a.y(i) > amp(2)
            switch amp(3)
            case 0
               a.y(i)=0;
            case 1
               a.y(i)=aa;
            end
         end
         aa=a.y(i);
      end
   end
elseif amp(1) > amp(2)
   if amp(3) == 2
      if a.type == 1
	      a.type=2;
   	   disp(' * gd type 2 created !');
         a.x=a.ini+a.dx.*(0:a.n-1);
      end
      
%       ii=0;
%       for i = 1:a.n
%          if a.y(i) <= amp(1) | a.y(i) >= amp(2)
%             ii=ii+1;
%             a.y(ii)=a.y(i);
%             a.x(ii)=a.x(i);
%          end
%       end
% 
%       a.n=ii;
       ii=find(a.y(i) >= amp(1) & a.y(i) <= amp(2))
       a.y=a.y(ii);
       a.x=a.x(ii);
       a.n=length(a.x);
   else
      aa=0;
      for i = 1:a.n
         if a.y(i) < amp(1) & a.y(i) > amp(2)
            switch amp(3)
            case 0
               a.y(i)=0;
            case 1
               a.y(i)=aa;
            end
         end
         aa=a.y(i);
      end
   end
end

a.y=a.y(1:a.n);
if a.type == 2
   a.x=a.x(1:a.n);
end

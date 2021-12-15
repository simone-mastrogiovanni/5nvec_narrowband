function ginproc(varargin)
%GINPROC  elaboration of plotted data
%
%  key :
%
%     'value'
%     'slope'
%     'logslope'   computes the exponent
%     'ylogslope'  computes the tau
%     'integral'   integral between two points; not from ginmenu
%     '3pexpsl'    three points exponential slope; the three points should be
%                  equispaced on the abscissa
%     '3pcircle'   radius and center of a circle for three points
%     'polyfit'    polinomial fit for n points
%     'pfylog'     y-logarithmic polynomial fit 
%     'pfloglog'   xy-logarithmic polynomial fit 

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

op=varargin{1};

switch op
case 'value'
   [x,y]=ginput(1);
   strout=sprintf('x,y = %f, %f',x,y);
   msgbox(strout,'x,y values');
case 'distance'
   [x,y]=ginput(2);
   dx=x(1)-x(2);
   dy=y(1)-y(2);
   dxy=sqrt(dx*dx+dy*dy);
   strout=sprintf(' dx =%f \n dy =%f \n distance =%f',dx,dy,dxy);
   msgbox(strout,'distance');
case 'slope'
   [x,y]=ginput(2);
   dx=x(1)-x(2);
   dy=y(1)-y(2);
   slope=dy/dx;
   strout=sprintf('slope =%f',slope);
   msgbox(strout,'slope');
case 'logslope'
   [x,y]=ginput(2);
   dx=log(x(1))-log(x(2));
   dy=log(y(1))-log(y(2));
   slope=dy/dx;
   strout=sprintf('exponent =%f',slope);
   msgbox(strout,'logslope');
case 'ylogslope'
   [x,y]=ginput(2);
   dx=x(2)-x(1);
   dy=log(y(2))-log(y(1));
   slope=dx/dy;
   strout=sprintf('tau =%f',slope);
   msgbox(strout,'ylogslope');
case 'integral'
   xpl=varargin{2};
   ypl=varargin{3};
   [x,y]=ginput(2);
   intgrl=0;
   for i = 2:length(xpl)
      if xpl(i) > x(1) & xpl(i) < x(2)
         intgrl=intgrl+ypl(i)*(xpl(i)-xpl(i-1));
      end
   end
   strout=sprintf('range x:  %f, %f \n\n    -> int =%f ',x(1),x(2),intgrl);
   msgbox(strout,'Integral');
case 'spectrum'
   xpl=varargin{2};
   ypl=varargin{3};
   ypl=abs(fft(ypl));
   npl=length(xpl);
   tobs=(xpl(npl)-xpl(1))*npl/(npl-1);
   xpl=(0:npl-1)./tobs;
   ypl=ypl.*(tobs/npl);
   figure
   semilogy(xpl,ypl);
   grid on,zoom on
case 'histogram'
   xpl=varargin{2};
   ypl=varargin{3};
   figure
   hist(ypl,100);
   grid on,zoom on
case '3pexpsl'
   [x,y]=ginput(3);
   y1=y(1);
   y2=spline(x,y,(x(3)+x(1))/2);
   y3=y(3);
   ly=(y3-y2)/(y2-y1);
   exsl=-(x(3)-x(1))/(2*log(ly));
   strout=sprintf('tau =%f',exsl);
   msgbox(strout,'3-point exponential slope');
case '3pcircle'
   [x,y]=ginput(3);
   A(1,1)=2*(x(1)-x(2));
   A(1,2)=2*(y(1)-y(2));
   A(2,1)=2*(x(1)-x(3));
   A(2,2)=2*(y(1)-y(3));
   B(1)=x(1)^2+y(1)^2-x(2)^2-y(2)^2;
   B(2)=x(1)^2+y(1)^2-x(3)^2-y(3)^2;
   xx=A\B.';
   r=sqrt((x(1)-xx(1))^2+(y(1)-xx(2))^2);
   strout=sprintf('center at %f, %f \n  radius = %f',xx(1),xx(2),r);
   msgbox(strout,'3-points circle');
case 'polyfit'
   answ=inputdlg({'Enter number of points','Enter the degree of polyfit',...
         'Reduce coordinates ?','Plot fit ?'},...
      'Fit parameters',2,{'6','1','y','y'});
   [x,y]=ginput(eval(answ{1}));
   if answ{3} == 'y' | answ{3} == 'Y'
      x0=x(1);
      y0=y(1);
   else
      x0=0;
      y0=0;
   end
   xx=x-x0;
   yy=y-y0;
   c=polyfit(xx,yy,eval(answ{2}));
   yf=polyval(c,xx);
   if answ{4} == 'y' | answ{3} == 'Y'
      plot(x,yf+y0,'color','red','LineWidth',2);
   end
   n=length(y);
   err=sqrt(sum(((yf-yy).^2)/n));
   dy=sqrt(sum(((y-y0).^2)/n));
   lc=length(c);
   for i = 1:lc
      lci=lc-i;
      strout{i}=sprintf('coeff pw %u -> %f',lci,c(i));
   end
   strout{lc+1}=sprintf('     error -> %f',err);
   strout{lc+2}=sprintf('  %% error -> %f',err/dy);
   msgbox(strout,'Fit coefficients');
case 'pfylog'
   answ=inputdlg({'Enter number of points','Enter the degree of polyfit',...
         'Reduce coordinates ?','Plot fit ?'},...
      'Fit parameters',2,{'6','1','y','y'});
   [x,y]=ginput(eval(answ{1}));
   if answ{3} == 'y' | answ{3} == 'Y'
      x0=x(1);
   else
      x0=0;
   end
   xx=x-x0;
   yy=log(y);
   c=polyfit(xx,yy,eval(answ{2}));
   yf=polyval(c,xx);
   if answ{4} == 'y' | answ{3} == 'Y'
      plot(x,exp(yf),'color','green','LineWidth',2);
   end
   n=length(y);
   err=sqrt(sum(((yf-yy).^2)/n));
   dy=sqrt(sum((yy.^2)/n));
   lc=length(c);
   for i = 1:lc
      lci=lc-i;
      strout{i}=sprintf('coeff pw %u -> %f',lci,c(i));
   end
   strout{lc+1}=sprintf('     error -> %f',err);
   strout{lc+2}=sprintf('  %% error -> %f',err/dy);
   msgbox(strout,'Y-log fit coefficients');
case 'pfloglog'
   answ=inputdlg({'Enter number of points','Enter the degree of polyfit',...
         'Plot fit ?'},...
      'Fit parameters',2,{'6','1','y'});
   [x,y]=ginput(eval(answ{1}));
   xx=log(x);
   yy=log(y);
   c=polyfit(xx,yy,eval(answ{2}));
   yf=polyval(c,xx);
   if answ{3} == 'y' | answ{3} == 'Y'
      plot(x,exp(yf),'color','blue','LineWidth',2);
   end
   n=length(y);
   err=sqrt(sum(((yf-yy).^2)/n));
   dy=sqrt(sum((yy.^2)/n));
   lc=length(c);
   for i = 1:lc
      lci=lc-i;
      strout{i}=sprintf('coeff pw %u -> %f',lci,c(i));
   end
   strout{lc+1}=sprintf('     error -> %f',err);
   strout{lc+2}=sprintf('  %% error -> %f',err/dy);
   msgbox(strout,'log-log fit coefficients');
end
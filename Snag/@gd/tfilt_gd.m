function y=tfilt_gd(x,filt)
%GD/TFILT_GD   time domain filtering
%
%      y=tfilt_gd(x,filt)
%       or
%      y=tfilt_gd(x)
%
%   x,y    input,output gds
%   filt   am object filter
%
%  y(n) = b0*x(n) + b(1)*x(n-1) + ... + b(nb)*x(n-nb)
%                 - a(1)*y(n-1) - ... - a(na)*y(n-na)

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=dx_gd(x);

if nargin == 1
	[which,whok]=listdlg('PromptString','Filter type ?',...
		'Name','Filter choice',...
		'SelectionMode','single',...
   	'ListString',{'By name' 'By coefficients'}); 

	switch which
	case 1
    	filt=am(dt);
	case 2
        answ=inputdlg({'AR order' 'MA order'},'Order of the filter',1,{'1' '0'});
   
	   na=eval(answ{1});
   	nb=eval(answ{2});
   
	   filt=am(na,nb)
   end
end

na=na_am(filt);
nb=nb_am(filt);

a(1)=1;
a(2:na+1)=a_am(filt);
b(1)=b0_am(filt);
b(2:nb+1)=b_am(filt);

xx=y_gd(x);
yy=filter(b,a,xx);
if bilat_am(filt) > 0
   n=length(yy);
   xx=yy(n:-1:1);
   yy=filter(b,a,xx);
   yy=yy(n:-1:1);
end

y=x;
capt=[capt_gd(x) ' filtered'];

y=edit_gd(y,'y',yy,'capt',capt);

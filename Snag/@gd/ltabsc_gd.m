function a=ltabsc_gd(b,coef)
%GD/LTABSC_GD   linear transformation of the abscissa of b
%
%      a=ltabsc_gd(b,coef)
%       or
%      a=ltabsc_gd(b)
%
%      a.x=coef(1)+b.x*coef(2)

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;

if ~exist('coef')
   npol=2;

	prompt=cell(npol,1);
	defarg=cell(npol,1);

	for i = 1:npol+1
   	prompt{i}=sprintf('Coefficient of order %d',i-1);
   	defarg{i}='0';
	end

	defarg{npol+1}='1';

	answ1=inputdlg(prompt,'Coefficients',1,defarg);

	for i = 1:npol+1
   	coef(i)=eval(answ1{i});
   end
end

if a.type == 1
   a.x=coef(1)+b.x*coef(2);
else
   x=x_gd(b);
	a.x=x+coef(1);

	for i = 2:npol+1
   	a.x=a.x+x.^(i-1);
	end
end

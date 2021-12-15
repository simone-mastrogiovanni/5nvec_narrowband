function a=poliabsc_gd(b,coef)
%GD/POLIABSC_GD   polinomial transformation of the abscissa of b
%
%      a=poliabsc_gd(b,coef)
%       or
%      a=poliabsc_gd(b)
%
%   coef   coefficient of the polinomial, from a_0 to a_n
%          if coef is absent, interactive request

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;
a.type=2;

if ~exist('coef')
   promptcg1={'Order of the polinomial ?'};
	defacg1={'2'};
	answ=inputdlg(promptcg1,'Polinomial order',1,defacg1);

	npol=eval(answ{1});

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

x=x_gd(b);
a.x=x+coef(1);

for i = 2:npol+1
   a.x=a.x+x.^(i-1);
end

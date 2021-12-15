function a=am(na,nb)
%AM  an (ARMA) structure constructor
%
%      a=am(dt)
%          or
%      a=am(na,nb) 
%          or
%      a=am(b,a)
%
%   na,nb   AR and MA orders
%
%   b,a     AR and MA coefficients (if not ARMA(0,0))
%
%  Data members
%
%    a      AR coefficients
%    na     number of the a
%    b      MA coefficients
%    nb     number of the b
%    b0     MA zero coefficient
%    bilat  =1 bilateral
%    capt   caption
%    cont   control variable
%
%  call with one argument -> sampling time
%   "        two     "    -> AR and MA order
%   "        zero    "    -> suppose sampling time = 1
%
%  y(n) = b0*x(n) + b(1)*x(n-1) + ... + b(nb)*x(n-nb)
%                 - a(1)*y(n-1) - ... - a(na)*y(n-na)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if nargin == 0
   dt=1;
elseif nargin == 1
   dt=na;
end

if nargin < 2
   [which,whok]=listdlg('PromptString','Filter type ?',...
	   'Name','ARMA filter choice',...
   	'SelectionMode','single',...
      'ListString',{'Low pass' 'High pass' 'Band pass'});
   
   prompt{1}='Bilateral ? (0 no, 1 yes)';
   defarg{1}='0';
   
	answ=inputdlg(prompt,'Bilateral filtering (0 phase)',1,defarg);
   
   a.bilat=eval(answ{1});
   notyet(' ')
elseif nargin == 2 
   if length(na)+length(nb) == 2
       a.na=na;
       a.a=zeros(na,1);
       a.nb=nb;
       a.b=zeros(nb,1);
       a.b0=1;
       a.bilat=0;
       a.capt='not defined';
       a.cont=0;

       prompt=cell(na+1,1);
       defarg=cell(na+1,1);

       prompt{1}='Bilateral ? (0 no, 1 yes)';
       defarg{1}='0';

       for i = 1:na
          prompt{i+1}=sprintf('Coefficient AR %d',i);
          defarg{i+1}='0';
       end

       answ=inputdlg(prompt,'AR coefficients',1,defarg);

       a.bilat=eval(answ{1});

       for i = 1:na
          a.a(i)=eval(answ{i+1});
       end

       prompt=cell(nb+1,1);
       defarg=cell(nb+1,1);

       prompt{1}=sprintf('Coefficient MA 0');
       defarg{1}='1';

       for i = 2:nb+1
          prompt{i}=sprintf('Coefficient MA %d',i-1);
          defarg{i}='0';
       end

       answ=inputdlg(prompt,'MA coefficients',1,defarg);

       a.b0=eval(answ{1});

       for i = 2:nb+1
          a.b(i-1)=eval(answ{i});
       end
   else
       a.na=length(nb)-1;
       a.a=nb(2:length(nb));
       a.nb=length(na)-1;
       a.b=na(2:length(na));
       a.b0=na(1);
       a.bilat=0;
       a.capt='ARMA from coeffs';
   end
elseif isa(a,'am')
   a=x;
else
   error('am structure constructor error');
   return
end

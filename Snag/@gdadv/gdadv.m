function g=gdadv(a)
%GDADV gdadv (group of data advanced) class constructor
%
%              g=gd(a)
%  can be constructed by a vector (a is a double array), a gd or
%  just defining the length (a is a single double)
%
%  Data members
%
%    x      abscissa (absent if type=1, otherwise a column vector)
%    y      ordinate (column vector)
%    n      length
%    type   type (=1 -> virtual abscissa, =2 -> real abscissa)
%    ini    beginning of (virtual) abscissa
%    dx     sampling "time" (for virtual abscissa)
%    tfstr  time-frequency structure
%    adv    advanced structure
%    capt   caption
%    unc    uncertainty on y (optional)
%    uncx   uncertainty on x (optional)
%    cont   control or support variable (may be an array or cell array)

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if nargin == 0
   g.x=[];
   g.y=[];
   g.n=0;
   g.type=0;
   g.ini=0;
   g.dx=0;
   g.capt='empty';
   g.cont=0;
   g.unc=[];
   g.uncx=[];
   g.tfstr=struct();
   g.adv=struct();
   g=class(g,'gdadv',gd);
elseif isa(a,'gd')
   typ=type_gd(a);
   if typ == 1
       g.x=[];
   else
       g.x=x_gd(a);
   end
   g.y=y_gd(a);
   g.n=n_gd(a);
   g.type=typ;
   g.ini=ini_gd(a);
   g.dx=dx_gd(a);
   g.cont=cont_gd(a);
   g.capt=capt_gd(a);
   g.unc=unc_gd(a);
   g.uncx=uncx_gd(a);
   g.tfstr=struct();
   g.adv=struct();
   g=class(g,'gdadv',gd);
elseif isa(a,'double')
   if length(a) == 1 && isinteger(a) && a > 0
      g.x=[];
      g.y=zeros(a,1);
      g.n=a;
      g.type=1;
      g.ini=0;
      g.dx=1;
      g.capt=strcat('new gdadv');
      g.cont=0;
      g.capt=capt_gd(a);
      g.unc=[];
      g.uncx=[];
      g.tfstr=struct();
      g.adv=struct();
      g=class(g,'gdadv',gd);
      disp('gdadv created using the argument as length')
   else
      g.x=[];
      g.y=a(:);
      g.n=length(a);
      g.type=1;
      g.ini=0;
      g.dx=1;
      g.capt=strcat('vector :',inputname(1));
      g.cont=0;
      g.unc=[];
      g.uncx=[];
      g.tfstr=struct();
      g.adv=struct();
      g=class(g,'gdadv',gd);
   end
elseif isstruct(a)  
    g=gd(a.y);
    g=edit_gdadv(g,'ini',a.ini,'dx',a.dx,'cont',a.cont,'tfstr',a.tfstr,'adv',a.adv,'capt',a.capt);

    if a.type == 2
        g=edit_gdadv(g,'x',a.x);
    end
else
   error('gdadv class constructor error');
end

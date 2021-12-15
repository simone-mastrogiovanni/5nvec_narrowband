function g=gd(a)
%GD gd (group of data) class constructor
%
%              g=gd(a)
%  can be constructed by a vector (a is a double array) or
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
%    capt   caption
%    unc    uncertainty on y (optional)
%    uncx   uncertainty on x (optional)
%    cont   control or support variable (may be an array or cell array)

% Version 1.0 - July 1998
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
   g=class(g,'gd');
elseif isa(a,'gd')
   g=a;
elseif isa(a,'double')
   if length(a) == 1 && isinteger(a) && a > 0
      g.x=[];
      g.y=zeros(a,1);
      g.n=a;
      g.type=1;
      g.ini=0;
      g.dx=1;
      g.capt=strcat('new gd');
      g.cont=0;
      g.unc=[];
      g.uncx=[];
      g=class(g,'gd');
      disp('gd created using the argument as length')
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
      g=class(g,'gd');
   end
elseif isstruct(a)  
    g=gd(a.y);
    g=edit_gd(g,'ini',a.ini,'dx',a.dx,'cont',a.cont,'capt',a.capt);

    if a.type == 2
        g=edit_gd(g,'x',a.x);
    end
else
   error('gd class constructor error');
end

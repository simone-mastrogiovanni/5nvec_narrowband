function g2=gd2(a)
%GD2 gd2 (group of data - two dimension) class constructor, child of gd
%
%              g2=gd2(a)
%  can be constructed by a vector (a is a double array) or
%  just defining the length (a is a single double)
%
%  Data members, inherited from gd
%
%    x      primary abscissa (absent if type=1)
%    y      ordinate (a matrix m*(n/m))
%    n      total dimension
%    type   type (=1 -> virtual primary abscissa, =2 -> real abscissa)
%    ini    beginning of (virtual) primary abscissa
%    dx     primary sampling "time" (for virtual abscissa)
%    capt   caption
%    cont   control variable
%
%  Peculiar data members
%
%    m      secondary dimension
%    ini2   beginning of secondary abscissa (always virtual)
%    dx2    secondary abscissa sampling
%    mcapt  multiple caption (case of m monodimensional data)
%
%  Auxiliary data members (only for some applications)
%
%    va     alpha of detector velocity (deg)
%    vd     delta      "          "
%    ve     module     "          "    (/c)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if nargin == 0
   g2.x=[];
   g2.y=[];
   g2.n=0;
   g2.type=0;
   g2.ini=0;
   g2.dx=0;
   g2.capt='empty';
   g2.cont=0;
   g2.m=0;
   g2.ini2=0;
   g2.dx2=0;
   g2.mcapt={};
   g2.va=[];
   g2.vd=[];
   g2.ve=[];
   g2=class(g2,'gd2',gd);
elseif isa(a,'gd2')
   g2=a;
elseif isa(a,'double')
   if length(a) == 2
      g2.x=[];
      g2.y=zeros(a(1),a(2));
      g2.n=a(1)*a(2);
      g2.type=1;
      g2.ini=0;
      g2.dx=1;
      g2.capt=strcat('new gd2');
      g2.cont=0;
      g2.m=0;
      g2.ini2=0;
      g2.dx2=1;
      g2.mcapt={};
   	g2.va=[];
   	g2.vd=[];
   	g2.ve=[];
      g2=class(g2,'gd2',gd);
   else
      g2.x=[];
      g2.y=a;
      nn=size(a);
      g2.n=nn(1)*nn(2);
      g2.type=1;
      g2.ini=0;
      g2.dx=1;
%      g2.capt=strcat('map :',inputname(1));
      g2.capt=['map :' inputname(1)];
      g2.cont=0;
      g2.m=nn(2);
      g2.ini2=0;
      g2.dx2=1;
      g2.mcapt={};
   	g2.va=[];
   	g2.vd=[];
   	g2.ve=[];
      g2=class(g2,'gd2',gd);
   end
else
   error('gd2 class constructor error');
end

function gout=find(gin,expr)
% (NOT EXACT) find for gds
%
%  gin   input gd
%  expr  if present, expression (ex.: 'abs(y)>0.5' or 'x.^2>3')
%  gout contains the found elements of gin'
%
% Can transform a type 1 to a type 2 gd

% Version 2.0 - August 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

gout=gin;
x=x_gd(gin);

if exist('expr','var')
    y=y_gd(gin);
    str=['[i,j]=find(' expr ');']
    eval(str);
else
    [i,j]=find(gin.y);
end

if length(i) < gin.n
    gout.type=2;
    gout.y=gin.y(i);
    gout.x=x(i);
    gout.capt=['find on ' gin.capt];
    gout.n=length(i);
end


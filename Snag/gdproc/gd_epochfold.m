function gout=gd_epochfold(in,per)
%GD_EPOCHFOLD  does an epoch folding on gd or array
%             ONLY FOR TYPE 1 GDs 
%
%    gout=gd_epochfold(in,per)
%
%  in     input gd or array
%  per    period

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(in,'gd')
    dx=dx_gd(in);
    gout=edit_gd(in,'ini',0);
    in=y_gd(in);
else
    dx=1;
end

in=in(:);
n=length(in);

peri=per/dx;
nout=ceil(peri);
out=zeros(nout,1);
t=peri;

i1=1;
i2=round(t);
nn=0;

while i2 <= n
    n1=i2-i1+1;%size(in),size(out)
    out(1:n1)=out(1:n1)+in(i1:i2);
    i1=i2+1;
    t=t+peri;
    i2=round(t);
    nn=nn+1;
end

disp(sprintf(' %d folding',nn));
out=out/nn;

if exist('gout')
    gout=edit_gd(gout,'y',out);
else
    gout=out;
end
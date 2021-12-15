function [out1 out2]=parall_gd(in1,in2,dxout)
% PARALL_GD  creates two parallel gds from two different ones
%            only for type 1 gds
%
%     [out1 out2]=parall_gd(in1,in2,dxout)
%
%  in1,in2    input gds
%  dxout      output sampling time
%
%  out1,out2  output gds

% Version 2.0 - February 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if in1.type > 1 | in2.type > 1
    disp('At least one of the input gds is not type 1')
    return
end

ini=max(in1.ini,in2.ini);
fin=min(in1.ini+in1.dx*(in1.n-1),in2.ini+in2.dx*(in2.n-1));
n=round((fin-ini)/dxout)+1;
x=ini+(0:n-1)*dxout;

out1=spline(x_gd(in1),in1.y,x);
out2=spline(x_gd(in2),in2.y,x);

out1=gd(out1);
out1=edit_gd(out1,'ini',ini,'dx',dxout,'capt','parallelized');
out2=gd(out2);
out2=edit_gd(out2,'ini',ini,'dx',dxout,'capt','parallelized');
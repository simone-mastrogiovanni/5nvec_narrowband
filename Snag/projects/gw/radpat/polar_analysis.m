function g=polar_analysis(source,antenna,n)
%GW_POLARIZ polarized source signal
%
%  source       source structure
%  antenna      detector structure
%  n            number of points in the sidereal day

% Version 2.0 - August 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

source1=source;
source1.eps=1;
source1.psi=0;
source2=source;
source2.eps=1;
source2.psi=45;

eps=source.eps
psi=source.psi*pi/180;

dsid=24/n;
sid1=zeros(1,n);
sid2=sid1;

for i = 1:n
    tsid=i*dsid;
    if antenna.type == 1
        sid1(i)=lin_angr85(antenna,source1,tsid*15);
        sid2(i)=lin_angr85(antenna,source2,tsid*15);
    else
        sid1(i)=lin_radpat_interf(source1,antenna,tsid);
        sid2(i)=lin_radpat_interf(source2,antenna,tsid);
    end
end

figure
plot(sid1),hold on
plot(sid2,'r')
grid on

g=complex(sid1,sid2);

g=gd(g);
g=edit_gd(g,'dx',dsid);

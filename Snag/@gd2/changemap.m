function mapout=changemap(mapin,in,out)
%changemap  change map representation
%
%    mapout=changemap(mapin,in,out)
%
%  mapin,mapout   gd2
%  in,out         'rectangular'
%                 'rectnormal' rectangular normalized for cos d
%                 'cosd'

% Version 2.0 - April 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

mapout=mapin;

if strcmpi(in,'rectnormal')
    in='rectangular';
    M=mapin.y;
    d=x2_gd2(mapin);
    for i = 1:length(d)
        M(:,i)=M(:,i)*cos(d(i)*pi/180);
    end
    mapin.y=M;
end

if strcmpi(in,'rectangular') & strcmpi(out,'cosd')
    M=mapin.y;
    [na nd]=size(M);
    MM=zeros(na,nd);
    ia=0:na-1;
    for i = 1:nd
        dil=1/cos(d(i)*pi/180);
        ia1=round(ia/dil)+1;
        iamax=max(ia1);
        for j = 1:na
            MM(ia1(j),i)=MM(ia1(j),i)+M(j,i);
        end
        MM(:,i)=rota(MM(:,i),round(na/2-na/dis));
    end
    mapout.y=MM;
    mapout.ini=-180;
end
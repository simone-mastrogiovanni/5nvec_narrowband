function g=hdf52bsd(file,typ,dataset)
% converts hdf5 data files to full-spectrum bsd or a gd
%
%    g=hdf52bsd(file,typ,dataset)
%
%   file     hdf5 file
%   typ      1 -> bsd (def),  0 -> real gd with cont, 2 -> simple structure
%   dataset  hdf5 data set (def '/strain/Strain')

% Sapienza Università di Roma
% Laboratorio di Segnali e Sistemi II
% Author: Sergio Frasca - 2018

if ~exist('dataset','var')
    dataset='/strain/Strain';
end

if ~exist('typ','var')
    typ=1;
end

gps=h5read(file,'/meta/GPSstart');
y=h5read(file,dataset);
dt=h5readatt(file,'/strain/Strain','Xspacing');

cont.t0=gps2mjd(double(gps));

switch typ
    case 0
        g=gd(y);
        g=edit_gd(g,'dx',dt,'cont',cont);
    case 1
        cont.inifr=0;
        cont.bandw=1/(2*dt);
        n=length(y);
        n=floor(n/2)*2;
        y=y(1:n);
        y=fft(y);
%         y(n/2+1:n)=0;
        y=y(1:n/2);
        y=ifft(y);
        g=gd(y);
        g=edit_gd(g,'dx',dt*2,'cont',cont);
    case 2
        g.h=y;
        g.dt=dt;
        g.t0=cont.t0;
end

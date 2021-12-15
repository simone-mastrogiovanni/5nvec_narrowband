function out=bsd_piece_5vec(in,fr,dt1,dt2,rasc)
% computes the 5-vect for pieces
%
%    out=bsd_piece_5vec(in,fr,dt1,dt2)
%
%   in     input bsd
%   fr     frequency
%   dt1    distance between pieces (in SidDays)
%   dt2    length of pieces (in SidDays)

% Snag version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza Rome University

SD=86164.09053083288;

dt=dx_gd(in);
n=n_gd(in);
cont=ccont_gd(in);
tref=cont.t0;

T0=n*dt;
S1=dt1*SD;
S2=dt2*SD;%T0,S1,S2
N=floor((T0-S2)/S1)+1;%N,dt,n
mat_5vec=zeros(5,N);
tini=zeros(1,N);

for i = 1:N
    tt(1)=(i-1)*S1;
    tt(2)=tt(1)+S2;
    tini(i)=tt(1);
    [y1,i1(i),i2(i)]=cut_bsd(in,tt);
    mat_5vec(:,i)=bsd_5vec(y1,fr,rasc,tref);
end

out.dt1=dt1;
out.dt2=dt2;
out.T0=T0;
out.S1=S1;
out.S2=S2;
out.rasc=rasc;
out.N=N;
out.tini=tini;
out.mat_5vec=mat_5vec;
out.i1=i1;
out.i2=i2;
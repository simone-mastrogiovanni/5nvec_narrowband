function fcand=pss_creasourcefile(sourstr,outfile)
% PSS_CREASOURCEFILE  creates source file
%
%     fcand=pss_creasourcefile(sourstr,outfile)
%
%  sourstr    structure array for source creation; each structure contains:
%     .N      number of sources
%     .fr     [min max] frequency (at epoch 2000-1-1 0:0)
%     .sd1    [min max] first spin down parameter (Hz/day)
%     .sd2    [min max] second spin down parameter (Hz/day^2)
%     .amp    [min max] amplitude
%     .eps    [min max] percentage of linear polarization
%     .psi    [min max] linear polarization angle
%     .alpha  [min max] alpha (equatorial coordinates)
%     .delta   [min max] delta  (equatorial coordinates)
%
%  outfile    output file
%
%  fcand      candidate matrix (coordinates are converted to ecliptical)
%
%    all angles are in degrees
%    sources are frequency sorted

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('outfile','var')
    outfile='sourcefile.dat';
end

fid=fopen(outfile,'w');
fprintf(fid,'!         Fake Source List \n');
fprintf(fid,'!   \n');


n=length(sourstr);
set_random;
NN=0;

for i = 1:n
    NN=NN+sourstr(i).N;
    fprintf(fid,'! %d : %d sources - fr: [%f,%f]  sd1: [%f,%f]  sd2: [%f,%f] \n!    amp: [%f,%f]  eps: [%f,%f]  psi: [%f,%f] \n!    alpha: [%f,%f]  delta: [%f,%f] \n',...
        i,sourstr(i).N,sourstr(i).fr(1),sourstr(i).fr(2),sourstr(i).sd1(1),sourstr(i).sd1(2),sourstr(i).sd2(1),sourstr(i).sd2(2),...
        sourstr(i).amp(1),sourstr(i).amp(2),sourstr(i).eps(1),sourstr(i).eps(2),sourstr(i).psi(1),sourstr(i).psi(2),...
        sourstr(i).alpha(1),sourstr(i).alpha(2),sourstr(i).delta(1),sourstr(i).delta(2));
end

fprintf(fid,'! \n');
fprintf(fid,'!   N       freq       sd1         sd2          amp      eps      psi     alpha   delta \n! \n');

fcand=zeros(7,NN);
fr=zeros(1,NN);
sd1=fr;
sd2=fr;
amp=fr;
eps=fr;
psi=fr;
alpha=fr;
delta=fr;
ii=1;

for i = 1:n
    N=sourstr(i).N;
    r=rand(8,N);
    fr(ii:ii+N-1)=sourstr(i).fr(1)+(sourstr(i).fr(2)-sourstr(i).fr(1))*r(1,:);
    sd1(ii:ii+N-1)=sourstr(i).sd1(1)+(sourstr(i).sd1(2)-sourstr(i).sd1(1))*r(2,:);
    sd2(ii:ii+N-1)=sourstr(i).sd2(1)+(sourstr(i).sd2(2)-sourstr(i).sd2(1))*r(3,:);
    eps(ii:ii+N-1)=sourstr(i).eps(1)+(sourstr(i).eps(2)-sourstr(i).eps(1))*r(4,:);
    psi(ii:ii+N-1)=sourstr(i).psi(1)+(sourstr(i).psi(2)-sourstr(i).psi(1))*r(5,:);
    alpha(ii:ii+N-1)=sourstr(i).alpha(1)+(sourstr(i).alpha(2)-sourstr(i).alpha(1))*r(6,:);
    rr=sin(sourstr(i).delta(1)*pi/180)+(sin(sourstr(i).delta(2)*pi/180)-sin(sourstr(i).delta(1)*pi/180))*r(7,:);
    delta(ii:ii+N-1)=asin(rr)*180/pi;
    amp(ii:ii+N-1)=sourstr(i).amp(1).*(sourstr(i).amp(2)/sourstr(i).amp(1)).^r(8,:);
    ii=ii+N;
end

[fr,i1]=sort(fr);
sd1=sd1(i1);
sd2=sd2(i1);
amp=amp(i1);
eps=eps(i1);
psi=psi(i1);
alpha=alpha(i1);
delta=delta(i1);
fcand(1,:)=fr;
[lambda beta]=astro_coord('equ','ecl',alpha,delta);
lambda=mod(lambda,360);
fcand(2,:)=lambda;
fcand(3,:)=beta;
fcand(4,:)=sd1;
fcand(7,:)=amp;

for i = 1:NN
    fprintf(fid,'%6d %10.4f %6.4e %6.4e   %6.4e %6.4f %6.1f   %7.2f %7.2f \n',i,fr(i),sd1(i),sd2(i),amp(i),eps(i),psi(i),alpha(i),delta(i));
end

fclose(fid);
function [candbest ang cand1out]=psc_faketable(cand1,cand2,fakesour,ncand,dfr,outfil)
%PSC_FAKETABLE  fake candidate table
%
%       cand1out=psc_faketable(cand1,cand2,fakesour,ncand,dfr,outfil)
%
%   cand1      found candidate matrix
%   cand2      fake candidate matrix
%   fakesour   fake source matrix
%   ncand      max cr ncand 
%   dfr        frequency half window
%   outfil     output file

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('dfr','var')
    dfr=0.001;
end
if ~exist('outfil','var')
    outfil='coin_table.txt';
end
if ~exist('ncand','var')
    ncand=5;
end

i10=ncand;
% correz=180
correz=0
cand1(2,:)=mod(cand1(2,:)+correz,360);
[ix1,iy1]=size(cand1);
[ixf,iyf]=size(fakesour);
hit=zeros(1,iyf);

fid=fopen(outfil,'w');
fprintf(fid,'           Fake candidate analysis    \r\n\r\n');
fprintf(fid,'       Number of fake sources      %d  \r\n',iyf);
fprintf(fid,'       Number of found candidate   %d \r\n\r\n',iy1);

fr=fakesour(1,:);
[fr,IX]=sort(fr);
fakesour=fakesour(:,IX);
ntot=0;
cand1out=zeros(7,0);
cand2out=zeros(7,0);
candbest=zeros(7,0);
fail=0;
nbest=0;

for i = 1:iyf
    fprintf(fid,'Fake source %d:  fr = %f   pos. = (%f,%f)  amp = %f   sd = %f  \r\n',...
        i,fakesour(1,i),fakesour(2,i),fakesour(3,i),fakesour(7,i),fakesour(4,i));
    set0=find(abs(fr(i)-cand1(1,:))<=dfr*2);
    nset=length(set0);
    ntot=ntot+nset;
    in2=[fakesour(2,i) fakesour(3,i)];
    if nset > 0
        fprintf(fid,'   % d candidates found  \r\n',nset);
        cand1A=cand1(:,set0);
        cand2A=cand2(:,set0);
        [cr,IX]=sort(cand1A(5,:),'descend');
        cand1A=cand1A(:,IX);
        in=min(i10,nset);
        for k = 1:in
            fprintf(fid,'  cand %d:  dfr = %f   pos. = (%f,%f)  cr = %f   sd = %f  \r\n',...
                k,cand1A(1,k)-fakesour(1,i),cand1A(2,k),cand1A(3,k),cand1A(5,k),cand1A(4,k));
        end
        fprintf(fid,'     \r\n');
        
        in1=cand1A(2:3,:);
        ang0=astro_angle_m(in1',in2);
        [an,k]=min(ang0);
        fprintf(fid,'  nearest cand  :  dfr = %f   pos. = (%f,%f)  cr = %f   sd = %f  \r\n',...
                cand1A(1,k)-fakesour(1,i),cand1A(2,k),cand1A(3,k),cand1A(5,k),cand1A(4,k));
        candbest=[candbest cand1A(:,k)];
        nbest=nbest+1;
        if an > 5
            disp(sprintf('  *** %d source no hit; error %f deg',i,an));
            fprintf(fid,'  *** %d source no hit; error %f deg \r\n',i,an);
        end
        ang(nbest)=an;
            
        [an,k]=min(abs(mod(cand1A(2,:)-fakesour(2,i),360)));
        fprintf(fid,'  nearest lambda:  dfr = %f   pos. = (%f,%f)  cr = %f   sd = %f  \r\n',...
                cand1A(1,k)-fakesour(1,i),cand1A(2,k),cand1A(3,k),cand1A(5,k),cand1A(4,k));
            
        [an,k]=min(abs(cand1A(3,:)-fakesour(3,i)));
        fprintf(fid,'  nearest beta  :  dfr = %f   pos. = (%f,%f)  cr = %f   sd = %f  \r\n',...
                cand1A(1,k)-fakesour(1,i),cand1A(2,k),cand1A(3,k),cand1A(5,k),cand1A(4,k));
        fprintf(fid,'     \r\n');
        
        cand1out=[cand1out cand1A(:,1:in)];
        cand2out=[cand2out cand2A(:,1:in)];
        hit(i)=1;
    else
        fprintf(fid,'   No candidates found  \r\n\r\n');
        fail=fail+1;
    end
end

fprintf(fid,'  %d sources not seen on %d\r\n',fail,iyf);
disp(sprintf('  %d sources not seen on %d\r\n',fail,iyf));

if ntot ~= iy1
    disp(sprintf(' *** Error !  %d candidate not considered on %d',iy1-ntot,iy1))
    fprintf(fid,' *** Error !  %d candidate not considered on %d',iy1-ntot,iy1);
end

nbest
ihit=find(hit);
nohit=find(hit == 0);

figure, plot(fakesour(2,ihit),fakesour(3,ihit),'ko'), hold on
plot(fakesour(2,nohit),fakesour(3,nohit),'go')
plot(cand1out(2,:),cand1out(3,:),'rx'), grid on
xlim([0 360]);ylim([-90 90]);
title('Fake source and hit')

figure, plot(fakesour(2,ihit),fakesour(3,ihit),'ko'), hold on
plot(fakesour(2,nohit),fakesour(3,nohit),'go')
plot(cand2out(2,:),cand1out(3,:),'x')
plot(cand1out(2,:),cand2out(3,:),'rx'), grid on
xlim([0 360]);ylim([-90 90]);
title('Fake source and hit - fixed beta and lambda')

figure, plot(fakesour(2,ihit),fakesour(3,ihit),'o'), hold on
plot(fakesour(2,nohit),fakesour(3,nohit),'go')
plot(candbest(2,:),candbest(3,:),'rx'), grid on
xlim([0 360]);ylim([-90 90]);
title('Fake source and best hit')

fclose(fid);
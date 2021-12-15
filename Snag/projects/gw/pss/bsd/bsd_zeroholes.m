function out=bsd_zeroholes(in1,in2)
% forces to zero the holes; if a single bsd is given, it uses the tfstr.zeros
%
%   in1   bsd to be zeroed
%   in2   bsd with the holes

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

global bsd_glob_nozeroing

if bsd_glob_nozeroing 
    disp('no-zeroed')
    out=in1;
    return
end

if exist('in2','var')
    zhole=bsd_holes(in2); % figure,plot(zhole(:,2)-zhole(:,1),'.'),grid on
    n1=n_gd(in1);
    n2=n_gd(in2);
    zhole1=round(zhole*n1/n2); % n1,n2,disp('entro in zeroholes')
    [i1,i2]=find(zhole1 < 1);
    zhole1(i1,i2)=1;
    [i1,i2]=find(zhole1 > n1);
    zhole1(i1,i2)=n1; % figure,plot(zhole1(:,2)-zhole1(:,1),'r.'),grid on
    out=bsd_zerointerv(in1,zhole1);
    % figure,plot(in1),hold on,plot(out)
    % figure,plot(in2)
else
    tfstr=tfstr_gd(in1);
    zers=tfstr.zeros;
    [nz,~]=size(zers);
    y=y_gd(in1);
    dt=dx_gd(in1);
    izers=floor(zers/dt)+1;
    out=bsd_zerointerv(in1,izers);
%     for i = 1:nz
%         i1=izers(i,1);
%         i2=izers(i,2);
%         if i1 <= 0
%             i1=1;
%         end
%         y(i1:i2)=0;
%     end
%     out=edit_gd(in1,'y',y);
end
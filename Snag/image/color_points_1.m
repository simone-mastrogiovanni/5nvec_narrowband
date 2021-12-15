function color_points_1(A,iclog,spotind)
%
%    color_points(A,iclog)
%
%    A      (N,3) matrix [x y amplitude]
%    iclog   =1  log plot
%    spot indices

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('iclog','var')
    iclog=0;
end
res=50;
mi1=min(A(:,1));
ma1=max(A(:,1));
mi2=min(A(:,2));
ma2=max(A(:,2));
mi3=min(A(:,3));
ma3=max(A(:,3));
iv=(A(:,3)-mi3)/(ma3-mi3);

if iclog == 1
    miv=log10(mi3);
    mav=log10(ma3);
    iv=(log10(A(:,3))-miv)/(mav-miv);
end
    
figure,hold on,grid on

for i = 1:res
    rgb=p2rgb((i-0.5)/res);
    ii=find(iv <= i/res & iv > (i-1)/res);
    if ~isempty(ii)
        plot(A(ii,1),A(ii,2),'.','Color',rgb),hold on
    end
end
grid on

if exist('spotind','var')
    plot(A(spotind,1),A(spotind,2),'rO'),plot(A(spotind,1),A(spotind,2),'gX')
end


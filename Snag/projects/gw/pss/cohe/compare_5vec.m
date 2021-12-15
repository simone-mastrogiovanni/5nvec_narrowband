function out=compare_5vec(v1,v2,icplot)
% 5-vect comparison
%
%  v1,v2   the 2 5-vects
%  icplot  > 0 plot (def)

% Snag version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('icplot','var')
    icplot=1;
end

rat=v1(:)./v2(:);

if icplot > 0
    figure
    v1n=show_5vect(v1,1);
    v2n=show_5vect(v2,1,'r');

    figure,show_5vect(rat,1);

    for i = 1:5
        k=i-3;
        fprintf('%2d amp = %e  ang = %f \n',k,abs(rat(i)),angle(rat(i))*180/pi);
    end
else
    v1n=v1/norm(v1);
    v2n=v2/norm(v2);
end

out.rat=rat;
out.eff=abs(sum(rat))/sum(abs(rat));
out.loss=1-out.eff;
% out.eff1=abs(sum(rat))/sqrt(sum(abs(rat).^2));
% out.loss1=1-out.eff1;

out.A0=norm(v1)/norm(v2);
R=sum(rat.*abs(v2n(:)).^2);
out.R=R;
out.A=abs(R);
out.Fi0=angle(R)*180/pi;

out.eff1=out.A/out.A0;
out.loss1=1-out.eff1;

dots=abs(dot(v1n,v2n));
out.dist=sqrt(1-dots.^2);

if icplot > 0
    fprintf('\n  eff = %f  loss = %f  dist = %f \n',out.eff,out.loss,out.dist)
    fprintf('\n  A = %f  Fi0 = %f  \n',out.A,out.Fi0)
end

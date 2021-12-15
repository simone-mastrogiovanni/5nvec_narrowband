function gij=compute_metric_for_desourcing(f0,f0dot,alfa,delta,time,reftime,px,py,pz)
%time in seconds
%alfa RAD
%delta RAD



dphi_a=(f0+f0dot*(time-reftime)).*(-px*sin(alfa)*cos(delta)+py*cos(delta)*cos(alfa));
dphi_d=(f0+f0dot*(time-reftime)).*(-px*cos(alfa)*sin(delta)-py*sin(delta)*sin(alfa)+pz*cos(delta));
tobs=time(end)-time(1);
gij(1,1)=(1/tobs)*trapz((time-reftime),dphi_a.*dphi_a)-(1/tobs^2)*trapz((time-reftime),dphi_a)^2;
gij(1,2)=(1/tobs)*trapz((time-reftime),dphi_a.*dphi_d)-(1/tobs^2)*trapz((time-reftime),dphi_a)*trapz((time-reftime),dphi_d);
gij(2,1)=(1/tobs)*trapz((time-reftime),dphi_d.*dphi_a)-(1/tobs^2)*trapz((time-reftime),dphi_d)*trapz((time-reftime),dphi_a);
gij(2,2)=(1/tobs)*trapz((time-reftime),dphi_d.*dphi_d)-(1/tobs^2)*trapz((time-reftime),dphi_d)*trapz((time-reftime),dphi_d);
gij=gij*2*pi;

end
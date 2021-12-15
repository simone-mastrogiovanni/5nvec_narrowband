function [sd sd1 sd2 R]=shapiro_delay(mjd,source)
% SHAPIRO_DELAY  computes the shapiro delay in s
%
%    mjd      time in MJD (array)
%    source   [ra d] of the source (degrees)
%
%  Uses reduced ephem package

sourecl=coco(source,'j2000.0','e','d','r');
sourecl=astro2rect(sourecl,1);
% snag_constant;
c_=2.997924580E8;
G_=6.67259E-11;
sol_m_=1.9891E30;
sol_app_=0.5358;
AU_=149597870691;
deg2rad_=pi/180;
rad2deg_=1/deg2rad_;

n=length(mjd);
sd=zeros(n,1);
sd1=sd;
sd2=sd;
R=sd;
maxang= sol_app_*deg2rad_/2;

for i = 1:n
    date=jd2date(mjd(i)+2400000.5);
    [sunlong lat r]=ple_earth(date);
    R(i)=r;
    sunlong=mod(sunlong+pi,2*pi)*rad2deg_;
    r=astro2rect([sunlong 0 1]);
    ps=sum(r.*sourecl);
    sd(i)=-(2*G_*sol_m_/c_^3)*log(1-ps+1.e-20);
    sd1(i)=-(2*G_*sol_m_/c_^3)*log(R(i)*(1-ps+1.e-20));
    sd2(i)=sd1(i);
%     ang=acos(ps);
    if sd(i) > 0.0002
        sd(i)=0.0002;
        sd1(i)=0.0002;
    end
end

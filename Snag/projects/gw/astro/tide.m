function [V Z g0 g2]=tide(t1,lat,long,height)
%
%     g0=tide(time,lat,long,height)
%
%   t1          mjd  (tmin:dt:tmax)
%   lat,long    deg 
%   height      m
%
%   g1,g0       gals

% modified from internet c code of 2008 Tom Van Baak - April 2012
%
% The tide function below was changed as little as possible from the
% original fortran version.
%
% Units: originally time in days from "epoch 2000" (12h GMT December 31, 1999)
% with east longitude is positive; height is meters.
%

time=t1-v2mjd([1999 12 31 12 0 0]);

e     = 0.054899720;
c     = 3.84402E10;
c1    = 1.495E13;
aprim = 1 / (c * (1 - e * e));
i     = 0.08979719;
omega = 0.4093146162;
ss    = 1.993E33;
mm    = 7.3537E25;
my    = 6.670E-8;
m     = 0.074804;

%
% computation point
%

coslambda = cos(lat / 180 * pi);
sinlambda = sin(lat / 180 * pi);
r = 6.378270E8 / sqrt(1 + 0.006738 * sinlambda.^2) + height * 100;
LL = long / 180 * pi;

%
% Julian centuries and series in tt,
% Longman (10), (11), (12), (19), (26) and (27).
%
% Sun:
% Longman Exp. Sup (p.98)
% h (12) LL
% p1 (26) GAMMA
% e1 (27) e
%

tt = time / 36525 + 1.0;
tt2 = tt .* tt;
tt3 = tt2 .* tt;
s = 4.720023438  + 8399.7093 * tt    + 4.40695E-5 * tt2 + 3.29E-8  * tt3;
p = 5.835124721  + 71.018009 * tt    - 1.80546E-4 * tt2 - 2.181E-7 * tt3;
h = 4.881627934  + 628.33195 * tt    + 5.2796E-6  * tt2;
N = 4.523588570  - 33.757153 * tt    + 3.67488E-5 * tt2 + 3.87E-8  * tt3;
p1 = 4.908229467 + 3.0005264E-2 * tt + 7.9024E-6  * tt2 + 5.81E-8  * tt3;
e1 = 0.01675104  - 4.18E-5   * tt    - 1.26E-7    * tt2;

%
% reciprocal distances
%

a1prim = 1 ./ (c1 .* (1 - e1 .* e1));
resd = 1 / c + aprim .* e .* cos(s - p) ...
             + aprim .* e .* e .* cos(2 * (s - p)) ...
             + 15.0 ./ 8 .* aprim .* m .* e .* cos(s - 2 * h + p) ...
             + aprim .* m .* m .* cos(2 * (s - h));
resdd = 1 / c1 + a1prim .* e1 .* cos(h - p1);

%
% longitude of moons ascending node
%

cosii = cos(omega) .* cos(i) ...
      - sin(omega) .* sin(i) .* cos(N);
sinii = sqrt(1 - cosii.^2);
ii = atan(sinii ./ cosii);
ny = asin(sin(i) .* sin(N) ./ sinii);

%
% longitude and right ascension
%

t = 2 * pi * (time - floor(time)) + LL;
ksi1 = t + h;
ksi = ksi1 - ny;
L1 = h + 2 * e1 .* sin(h - p1);
alfa = 2 * atan((sin(omega) .* sin(N) ./ sinii) ./ ...
       (1 + cos(N) .* cos(ny) + sin(N) .* sin(ny) .* cos(omega)));
sigma = s - N + alfa;
L = sigma + 2.0 * e .* sin(s - p) ...
          + 5.0 ./ 4 .* e .* e .* sin(2 * (s - p)) ...
          + 15.0 ./ 4 .* m .* e .* sin(s - 2 * h + p) ...
          + 11.0 ./ 8 .* m .* m .* sin(2 .* (s - h));

%
% zenith angles
%

costheta = sinlambda .* sinii .* sin(L) ...
         + coslambda .* (cos(ii / 2).^2 .* cos(L - ksi) + ...
                        sin(ii / 2).^2 .* cos(L + ksi));
cosphi = sinlambda .* sin(omega) .* sin(L1) ...
       + coslambda .* (cos(omega / 2).^2 .* cos(L1 - ksi1) + ...
                      sin(omega / 2).^2 .* cos(L1 + ksi1));
%
% gravities
%

gs = my .* ss .* r .* resdd.^3 .* (3 * cosphi.^2 - 1);
gm = my .* mm .* r .* resd.^3 .* (3 * costheta.^2 - 1) + ...
     3.0 / 2 .* my .* mm .* r.^2 .* resd.^4 .* (5 * costheta.^3 - 3 * costheta);
g1 = gm + gs;

geq = 9.780327*100;
g0 = geq * (1.0 + 0.0053024 * (sin(lat / 180 * pi).^2) ...
                     - 0.0000058 * (sin(lat / 90 * pi).^2)) ...
   - 3.086e-6 * height;

Vs=gs*r/2;
Vm=gm*r/2;
V=Vs+Vm;

% Love numbers

h2=0.6032;
k2=0.2980;
l2=0.0839;

love_grav=1+h2-3*k2/2;
love_height=1+k2-h2;
love_tilt=1+k2-h2;

Z=love_height*V/geq;

g2=love_grav*g1;
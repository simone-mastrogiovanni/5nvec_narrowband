function g0=tide_calc_gal(t1,lat,long,alt)
%
%     g=tide_calc_gal(t,lat,long,alt)
%
%   t           mjd  (tmin:dt:tmax)
%   lat,long    deg 
%   alt         m
%
%   g0          gals

% developed from internet c code by 2004 Tom Van Baak - April 2012

% Constants.

mu = 6.67e-08;
m = 7.3537e+25;
s = 1.993e+33;
% il = 0.08979719;
% omega = 0.4093146162;
ml = 0.074804;
el = 0.0549;
cl1 = 1.495e+13;
cl = 3.84402e+10;
% al = 6.37827e+08;

% Love Numbers.

h2 = 0.612;
k2 = 0.303;

tl0=mod(t1,1)*24;
j1900=t1-15019.5;
t = j1900 / 36525;

n = POLY(t, 4.523601612, -33.75715303, 0.0000367488, 0.0000000387);
el1 = POLY(t, 0.01675104, -0.0000418, 0.000000126, 0);
sl = POLY(t, 4.720023438, 8399.7093, 0.0000440695, 0.0000000329);
pl = POLY(t, 5.835124721, 71.01800936, -0.0001805446, -0.0000002181);
hl = POLY(t, 4.881627934,628.3319508, 0.0000052796, 0);
pl1 = POLY(t, 4.908229467, 0.0300052641, 7.9024e-06, 0.0000000581);
i = acos(0.9136975738 - 0.0356895353 * cos(n));
nu = asin(0.0896765581 * sin(n) / sin(i));
tl = RAD(15 * tl0 + long);
chi = tl + hl - nu;
chi1 = tl + hl;
ll1 = hl + 2 .* el1 .* sin(hl - pl1);
cosalf = cos(n) * cos(nu) + sin(n) * sin(nu) * 0.9173938078;
sinalf = 0.3979806546 * sin(n) / sin(i);
alf = 2 * atan(sinalf ./ (1 + cosalf));
xi = n - alf;
sigma = sl - xi;
ll = sigma + 0.1098 * sin(sl - pl)...
    + 0.0037675125 * sin(2 * (sl - pl))...
    + 0.0154002735 * sin(sl - 2 * hl + pl)...
    + 0.0076940028 * sin(2 * (sl - hl));
lm = RAD(lat);   % lambda
costht = sin(lm) .* sin(i) .* sin(ll) + cos(lm) .*...
    (cos(0.5 * i).^2 .* cos(ll - chi) + sin(0.5 * i).^2 .* cos(ll + chi) );
cosphi = sin(lm) * 0.3979806546 * sin(ll1) + cos(lm) *...
    ( 0.9586969039 .* cos(ll1 - chi1) + 0.0413030961 * cos(ll1 + chi1) );
c = 1 ./ sqrt(1 + 0.006738 * sin(lm).^2);
rl = 6.37827e+08 * c + alt * 100.0; % meters to cm
ap = 2.60930776e-11;
ap1 = 1 ./ (1.495e+13 * (1 - el1 .* el1));
dl = 1 ./ ( 1 ./ cl...
    + ap .* el .* cos(sl - pl)...
    + ap .* el .* el .* cos(2 * (sl - pl))...
    + 1.875 .* ap .* ml * el .* cos(sl - 2 * hl + pl)...
    + ap .* ml .* ml .* cos(2 * (sl - hl)));
D = 1 ./ (1 ./ cl1...
    + ap1 .* el1 .* cos(hl - pl1));
gm = mu .* m .* rl .* (3 * costht.^2 - 1) ./ dl.^3 ...
    + 1.5 * mu .* m .* rl .* rl .* (5 * costht.^3 - 3 * costht) ./ dl.^4;
gs = mu .* s .* rl .* (3 * cosphi.^2 - 1) ./ D.^3;
love = (1 + h2 - 1.5 * k2);
g0 = (gm + gs) * love;

g0=gd(g0);
g0=edit_gd(g0,'dx',t1(2)-t1(1));
figure,plot(g0)


function p=POLY(t,a,b,c,d)

p=polyval([d c b a],t);


function r=RAD(x)

r=x*pi/180;
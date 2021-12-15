function out=varie_5vect()
% 

psi=0:180;
eta=-1:0.01:1;

Hp=zeros(181,201);
Hc=Hp;

for i = 1:181
    Hp(i,:)=(1./sqrt(1+eta.^2)).*(cos(psi(i)*pi/90)-1j*eta*sin(psi(i)*pi/90));
    Hc(i,:)=(1./sqrt(1+eta.^2)).*(sin(psi(i)*pi/90)+1j*eta*cos(psi(i)*pi/90));
end

Hp=gd2(Hp);
Hp=edit_gd2(Hp,'ini',0,'dx',1,'ini2',-1,'dx2',0.01);
Hc=gd2(Hc);
Hc=edit_gd2(Hc,'ini',0,'dx',1,'ini2',-1,'dx2',0.01);

out.Hp=Hp;
out.Hc=Hc;

plot(real(Hp)),xlabel('\psi'),ylabel('\eta'),title('Real(H_+)')
plot(imag(Hp)),xlabel('\psi'),ylabel('\eta'),title('Imag(H_+)')
plot(abs(Hp)),xlabel('\psi'),ylabel('\eta'),title('abs(H_+)')

plot(real(Hc)),xlabel('\psi'),ylabel('\eta'),title('Real(H_x)')
plot(imag(Hc)),xlabel('\psi'),ylabel('\eta'),title('Imag(H_x)')
plot(abs(Hc)),xlabel('\psi'),ylabel('\eta'),title('abs(H_x)')

plot(abs(Hp).^2+abs(Hc).^2),xlabel('\psi'),ylabel('\eta'),title('abs(H_+)^2+abs(H_x)^2')

sour.d=-90:90;
d=sour.d*pi/180;

ant.lat=-90:90;
ant.azim=0;
l=ant.lat*pi/180;
az=ant.azim*pi/180;

a=0;
long=0;

al=exp(-1j*(a-long));

c2a=cos(2*az);
c2d=cos(2*d);
c2l=cos(2*l);
s2a=sin(2*az);
s2d=sin(2*d);
s2l=sin(2*l);

cd=cos(d);
cl=cos(l);
sd=sin(d);
sl=sin(l);

a0=zeros(181,181);
a1c=a0;
a1s=a0;
a2c=a0;
a2s=a0;
b1c=a0;
b1s=a0;
b2c=a0;
b2s=a0;

for id = 1:181
    a0(id,:)=-(3/16)*(1+c2d(id).*(1+c2l).*c2a);
    a1c(id,:)=-(1/4)*s2d(id).*s2l.*c2a;
    a1s(id,:)=-(1/2)*s2d(id).*cl.*s2a;
    a2c(id,:)=(-1/16)*(3-c2d(id)).*(3-c2l).*c2a;
    a2s(id,:)=-(1/4)*(3-c2d(id)).*sl.*s2a;

    b1c(id,:)=-cd(id).*cl.*s2a;
    b1s(id,:)=(1/2)*cd(id).*s2l.*c2a;
    b2c(id,:)=-sd(id).*sl.*s2a;
    b2s(id,:)=(1/4)*sd(id).*(3-c2l).*c2a;
end

A0=gd2(a0);
A0=edit_gd2(A0,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(A0),xlabel('\delta'),ylabel('lat'),title('a0 azim=0')

A1c=gd2(a1c);
A1c=edit_gd2(A1c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(A1c),xlabel('\delta'),ylabel('lat'),title('a1c azim=0')

% A1s=gd2(a1s);
% A1s=edit_gd2(A1s,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
% plot(A1s),xlabel('\delta'),ylabel('lat'),title('a1s')

A2c=gd2(a2c);
A2c=edit_gd2(A2c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(A2c),xlabel('\delta'),ylabel('lat'),title('a2c azim=0')

% A2s=gd2(a2s);
% A2s=edit_gd2(A2s,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
% plot(A2s),xlabel('\delta'),ylabel('lat'),title('a2s azim=0')

% B1c=gd2(b1c);
% B1c=edit_gd2(B1c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
% plot(B1c),xlabel('\delta'),ylabel('lat'),title('b1c azim=0')

B1s=gd2(b1s);
B1s=edit_gd2(B1s,'ini',-90,'dx',1,'ini2',-90,'dx2 azim=0',1);
plot(B1s),xlabel('\delta'),ylabel('lat'),title('b1s azim=0')

% B2c=gd2(b2c);
% B2c=edit_gd2(B2c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
% plot(B2c),xlabel('\delta'),ylabel('lat'),title('b2c azim=0')

B2s=gd2(b2s);
B2s=edit_gd2(B2s,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(B2s),xlabel('\delta'),ylabel('lat'),title('b2s azim=0')

ant.azim=45;
az=ant.azim*pi/180;
c2a=cos(2*az);
s2a=sin(2*az);

for id = 1:181
    a0(id,:)=-(3/16)*(1+c2d(id).*(1+c2l).*c2a);
    a1c(id,:)=-(1/4)*s2d(id).*s2l.*c2a;
    a1s(id,:)=-(1/2)*s2d(id).*cl.*s2a;
    a2c(id,:)=(-1/16)*(3-c2d(id)).*(3-c2l).*c2a;
    a2s(id,:)=-(1/4)*(3-c2d(id)).*sl.*s2a;

    b1c(id,:)=-cd(id).*cl.*s2a;
    b1s(id,:)=(1/2)*cd(id).*s2l.*c2a;
    b2c(id,:)=-sd(id).*sl.*s2a;
    b2s(id,:)=(1/4)*sd(id).*(3-c2l).*c2a;
end

A0=gd2(a0);
A0=edit_gd2(A0,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(A0),xlabel('\delta'),ylabel('lat'),title('a0 azim=45')

% A1c=gd2(a1c);
% A1c=edit_gd2(A1c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
% plot(A1c),xlabel('\delta'),ylabel('lat'),title('a1c azim=0')

A1s=gd2(a1s);
A1s=edit_gd2(A1s,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(A1s),xlabel('\delta'),ylabel('lat'),title('a1s azim=45')

% A2c=gd2(a2c);
% A2c=edit_gd2(A2c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
% plot(A2c),xlabel('\delta'),ylabel('lat'),title('a2c azim=0')

A2s=gd2(a2s);
A2s=edit_gd2(A2s,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(A2s),xlabel('\delta'),ylabel('lat'),title('a2s azim=45')

B1c=gd2(b1c);
B1c=edit_gd2(B1c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(B1c),xlabel('\delta'),ylabel('lat'),title('b1c azim=45')

% B1s=gd2(b1s);
% B1s=edit_gd2(B1s,'ini',-90,'dx',1,'ini2',-90,'dx2 azim=0',1);
% plot(B1s),xlabel('\delta'),ylabel('lat'),title('b1s')

B2c=gd2(b2c);
B2c=edit_gd2(B2c,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
plot(B2c),xlabel('\delta'),ylabel('lat'),title('b2c azim=45')

% B2s=gd2(b2s);
% B2s=edit_gd2(B2s,'ini',-90,'dx',1,'ini2',-90,'dx2',1);
% plot(B2s),xlabel('\delta'),ylabel('lat'),title('b2s azim=0')

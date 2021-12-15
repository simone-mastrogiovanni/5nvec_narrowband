function [h,f,A]=r_modes(f0,t,alf,d)
% r-modes
% equations given by A.Miller

n=length(t);
dt=t(2)-t(1);
t=t(:);

lam=1e-20;
A0=20/d; % d in Mpc

f=f0./(1+lam*alf^2*f0^6.*t).^(1/6);
A=A0*1.8e-24*alf*(f/1000).^3;

size(f),size(A)
% h=vfs_create(n,dt,0,0,f',A');
h=0
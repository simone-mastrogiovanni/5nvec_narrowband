function [sp,ac,ch]=spacch(b,a,dt,lsp,prech,lch)
%SPACCH  given a sistem, computes the spectrum the autocorrelation and a chunk
%
%  a,b      sistem parameters
%  dt       sampling time
%  lsp      length of the spectrum (bilateral - should be even)
%  prech    length of the prechunk
%  lch      length of the chunk
%
%  sp,ac,ch  output gds

% Version 2.0 - August 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

 F=gd_bode(b,a,lsp,dt,-1);
 f=y_gd(F);
 df=dx_gd(F);
 iccompl=0;
 
 sp1=(abs(f).^2)*dt;
 ac1=ifft(sp1)*df*lsp;
 if max(abs(imag(ac1))) < 10^-14*max(abs(real(ac1)))
     ac1=real(ac1);
     disp('Real Autocorrelation')
 else
     iccompl=1;
 end
 
 N2=lsp/2;
 
 sp=sp1;
 sp(1:N2)=sp1(N2+1:lsp);
 sp(N2+1:lsp)=sp1(1:N2);
 sp=gd(sp);
 sp=edit_gd(sp,'capt','Spectrum','dx',df,'ini',-N2*df);
 
 ac=ac1;
 ac(1:N2)=ac1(N2+1:lsp);
 ac(N2+1:lsp)=ac1(1:N2);
 if iccompl == 1
     figure
     plot((-N2:N2-1)*dt,real(ac));
     grid on, hold on
     plot((-N2:N2-1)*dt,imag(ac),'r:');
 end
 ac=gd(ac);
 ac=edit_gd(ac,'capt','Autocorrelation','dx',dt,'ini',-N2*dt);
 
 if prech > 1000
     prech1000=floor(prech/1000);
     prech=prech-prech1000*1000;
 else
     prech1000=0;
 end
 
 na=length(a);
 zi=zeros(max(length(a),length(b))-1,1);
 
 for i = 1:prech1000
     if na > 1
         [y,zi]=filter(b,a,randn(1000,1),zi);
     else
         y=filter(b,a,randn(1000,1));
     end
 end
 
 if na > 1
     [y,zi]=filter(b,a,randn(prech,1),zi);
 else
     y=filter(b,a,randn(prech,1));
 end
 
 if na > 1
     ch=filter(b,a,randn(lch,1),zi);
 else
     ch=filter(b,a,randn(lch,1));
 end

 if ~isreal(ch)
     figure
     plot((0:lch-1)*dt,real(ch));
     grid on, hold on
     plot((0:lch-1)*dt,imag(ch),'r:');
 end
 
 ch=gd(ch);
 ch=edit_gd(ch,'capt','Chunk','dx',dt);
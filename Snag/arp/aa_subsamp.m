function out=aa_subsamp(in,lpin,lpout)
%AA_SUBSAMP  anti-aliasing sub-sampling
%
%    in     input vector
%    out    output vector
%    lpin   length subpieces in (should be dvisible by 4)
%    lpout  length subpieces out (should be dvisible by 4)

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nin=length(in);
lpin2=lpin/2;
lpin4=lpin/4;
lpout2=lpout/2;
lpout4=lpout/4;
nout=nin*lpout/lpin;
nou1=1;
nou2=0;
out=zeros(1,nout);

in1=zeros(1,lpin);
in1(lpin4+1:lpin)=in(1:3*lpin4);
inread=3*lpin4;
rem=0;

while nou2 < nout
    nou1=nou2+1;
    nou2=nou2+lpout2;
	IN1=fft(in1);
	OUT1(1:lpout2)=IN1(1:lpout2);
	OUT1(lpout2)=OUT1(lpout2)*0.25;
	OUT1(lpout2-1)=OUT1(lpout2-1)*0.5;
	OUT1(lpout2-2)=OUT1(lpout2-2)*0.75;
	OUT1(lpout2+1)=0;
	OUT1(lpout:-1:lpout2+2)=conj(OUT1(2:lpout2));
	out1=ifft(OUT1);
    out(nou1:nou2)=out1(lpout4+1:lpout4*3);
    
    in1(1:lpin2)=in1(lpin2+1:lpin);
    in1(lpin2+1:lpin)=0;
    inread1=inread+1;
    inread=inread+lpin2;
    if inread > nin
        rem=inread-nin;
        inread=nin;
    end
    in1(lpin2+1:lpin-rem)=in(inread1:inread);
end

out=real(out(1:nout))*(lpout/lpin);

function [y,par]=comb_10hz(x,par)
%COMB_10HZ  applies a comb filter at 10 Hz and multiples
%
%      x          input gd
%      par        parameters
%        .no50    1 -> no 50 Hz and multiples
%        .lowfr   low frequency (lower freq are cut)
%        .pieces  numer of interlaced pieces
%        .width   frequency width (0 default)

if ~exist('par','var')
    par.no50=1
    par.lowfr=200;
    par.pieces=8;
    par.width=0;
end
par

len=n_gd(x);
dt=dx_gd(x);

lenfilt=round(len/par.pieces);
dfr=1/(dt*lenfilt);
widfil=round(par.width/dfr);

dfr=1/(lenfilt*dt);
nn=10/dfr;
ii=round(1:nn:lenfilt/2);
ii(1)=0;

if par.no50 > 0
    ii(6:5:length(ii))=0;
    [a,b,ii]=find(ii);
end

ii=ii(find(ii>par.lowfr/dfr));

frfilt=zeros(lenfilt/2,1);

for i = ii
    frfilt(i-1-widfil:i+1+widfil)=1;
    frfilt(i-2-widfil)=1/2;
    frfilt(i+2+widfil)=1/2;
end

frfilt(lenfilt:-1:lenfilt/2+2)=frfilt(2:lenfilt/2);
frfilt(lenfilt/2+1)=0;
frfilt=create_frfilt(frfilt);

y=gd_frfilt(x,frfilt,1);

y=edit_gd(y,'dx',dt,'capt','combed signal');
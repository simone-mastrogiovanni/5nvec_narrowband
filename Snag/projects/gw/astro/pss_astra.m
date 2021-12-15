function astra=pss_astra(typ)
%PSS_ASTRA  stars and galaxies
%
%    typ    0    all
%           1    galactic objects
%           2    extragalactic objects
%           3    other

N=5;

alpha(1)=266.4;
delta(1)=-28.93;
name{1}='Gal.Center';
ty(1)=1;

alpha(2)=10.6;
delta(2)=41.27;
name{2}='Andromeda';
ty(2)=2;

alpha(3)=79.9;
delta(3)=-68.95;
name{3}='LMC';
ty(3)=2;

alpha(4)=12.9;
delta(4)=-73.23;
name{4}='SMC';
ty(4)=2;

alpha(5)=5.5;
delta(5)=-72.36;
name{5}='47 Tuc';
ty(5)=1;

% alpha(6)=
% delta(6)=
% name{6}='Scl - NGC 288';
% ty(6)=1;
% 
% alpha(7)=
% delta(7)=
% name{7}=
% ty(7)=
% 
% alpha(8)=
% delta(8)=
% name{8}=
% ty(8)=

n=0;

for i = 1:N
    if ty(i) == typ | typ == 0
        n=n+1;
        astra(n).alpha=alpha(i);
        astra(n).delta=delta(i);
        astra(n).name=name(i);
    end
end
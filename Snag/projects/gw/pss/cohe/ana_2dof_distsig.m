% ana_2dof_distsig
%
% after driver_5band_ana, containing
% 
% fr0=0.38194046
% 
% agwC=compute_5comp(gwC,fr0);
% 
% sigs(1,:)=compute_5comp(pL0wien,fr0);
% sigs(2,:)=compute_5comp(pL45wien,fr0);
% sigs(3,:)=compute_5comp(pCAwien,fr0);
% sigs(4,:)=compute_5comp(pCCwien,fr0);
% 
% [outmf cohe x inif DF]=band_5ana(gwC,fr0,sigs,agwC,[0.255 0.495],8);

TS=86164.09053083288;
[i1 N]=size(outmf);

% k1=floor(-(inif-fr0+2/TS)/DF)+1;
% k2=ceil(-(inif-fr0+2/TS)/DF)+1;
% x1=x(k1);
% x2=x(k2); % x1,x2
% k0=round((fr0-inif-2/TS)/DF)+1; % k0,k1,k2

[hist dist xh]=test_chisq(outmf(1,:),[1 2 4 8 16]);
[hist dist xh]=test_chisq(outmf(2,:),[1 2 4 8 16]);
[hist dist xh]=test_chisq(outmf(3,:),[1 2 4 8 16]);
[hist dist xh]=test_chisq(outmf(4,:),[1 2 4 8 16]);
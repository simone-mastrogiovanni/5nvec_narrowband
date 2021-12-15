function out=plot_ptable(pt,typ)
% plot of a [5,N] peak table
%
%   pt     peak table
%   typ    type [5 normal (def), 3 or 4 other ch, 54 ch5/ch4, 0 zeros

out=1;
N=length(pt);
pt1=zeros(N,3);
pt1(:,1)=pt(1,:)-floor(pt(1,1));
pt1(:,2)=pt(2,:);

if ~exist('typ','var')
    typ=5;
end

switch typ
    case 5
        pt1(:,3)=pt(5,:);
    case 3
        pt1(:,3)=log10(pt(3,:));
    case 4
        pt1(:,3)=pt(4,:);
    case 54
        ii=find(pt(4,:));
        N=length(ii);
        pt1=zeros(N,3);
        pt1(:,1)=pt(1,ii)-floor(pt(1,1));
        pt1(:,2)=pt(2,ii);
        pt1(:,3)=pt(5,ii)./pt(4,ii);
    case 0
        ii=find(pt(4,:) == 0);
        N=length(ii);
        pt1=zeros(N,3);
        pt1(:,1)=pt(1,ii)-floor(pt(1,1));
        pt1(:,2)=pt(2,ii);
        pt1(:,3)=pt(3,ii);
end

color_points(pt1)
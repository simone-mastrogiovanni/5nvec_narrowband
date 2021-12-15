% merge_coin merge coincidence matrices

load c6c7_coinab
load c6c7coin_c1
load c6c7coin_c2
load c6c7coin_c3
load c6c7coin_c4
load c6c7coin_c5

[ii,ia]=size(c_cand1A);
[ii,ib]=size(c_cand1B);
[ii,ic1]=size(c_cand1C1);
[ii,ic2]=size(c_cand1C2);
[ii,ic3]=size(c_cand1C3);
[ii,ic4]=size(c_cand1C4);
[ii,ic5]=size(c_cand1C5);

ii=ia+ib+ic1+ic2+ic3+ic4+ic5

c_cand1=zeros(7,ii);
c_cand1(:,1:ia)=c_cand1A;
c_cand1(:,1+ia:ia+ib)=c_cand1B;
c_cand1(:,1+ia+ib:ia+ib+ic1)=c_cand1C1;
c_cand1(:,1+ia+ib+ic1:ia+ib+ic1+ic2)=c_cand1C2;
c_cand1(:,1+ia+ib+ic1+ic2:ia+ib+ic1+ic2+ic3)=c_cand1C3;
c_cand1(:,1+ia+ib+ic1+ic2+ic3:ia+ib+ic1+ic2+ic3+ic4)=c_cand1C4;
c_cand1(:,1+ia+ib+ic1+ic2+ic3+ic4:ia+ib+ic1+ic2+ic3+ic4+ic5)=c_cand1C5;

c_cand2=zeros(7,ii);
c_cand2(:,1:ia)=c_cand2A;
c_cand2(:,1+ia:ia+ib)=c_cand2B;
c_cand2(:,1+ia+ib:ia+ib+ic1)=c_cand2C1;
c_cand2(:,1+ia+ib+ic1:ia+ib+ic1+ic2)=c_cand2C2;
c_cand2(:,1+ia+ib+ic1+ic2:ia+ib+ic1+ic2+ic3)=c_cand2C3;
c_cand2(:,1+ia+ib+ic1+ic2+ic3:ia+ib+ic1+ic2+ic3+ic4)=c_cand2C4;
c_cand2(:,1+ia+ib+ic1+ic2+ic3+ic4:ia+ib+ic1+ic2+ic3+ic4+ic5)=c_cand2C5;

clear c_cand1A c_cand1B c_cand1C1 c_cand1C2 c_cand1C3 c_cand1C4 c_cand1C5
clear c_cand2A c_cand2B c_cand2C1 c_cand2C2 c_cand2C3 c_cand2C4 c_cand2C5
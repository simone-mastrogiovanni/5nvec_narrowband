function out=lcm_arr(arr)
% LCM_ARR  least common multiple on the elements of an array of integers

[i1,i2,arr]=find(arr);
arr=sort(arr);
n=length(arr);
ma=0;

for i = 1:n
    fa=factor(arr(i));
    [str(i).num,str(i).item]=numeros(fa);
    ma=max(ma,max(str(i).item));
end

z=zeros(1,ma);
z1=z;

for i = 1:n
    z1(str(i).item)=str(i).num;
    z=max(z,z1);
end

[i1,i2,i3]=find(z);
out=prod(i2.^i3);
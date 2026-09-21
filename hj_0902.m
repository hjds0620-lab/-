clear all; close all; clc;

1+3;
13-4;
12*3;
36/3;

x=[1 2 3 4 5]; y=[5 4 3 2 1];
x<y;
x<=y;
x==y;
x>=y;
x>y;

for x=0:2:10
    a=2^x;
end

a=3;
if a<1
    a=1;
    b=1;
else
    c=a+2;
end

a=1;
while a<4
    a=a+1
end



x=linspace(0,2*pi);
y=sin(x);
plot(x,y,'ro'); grid on; axis image;

ones(3,5);
zeros(3,5);
rand(3,5);













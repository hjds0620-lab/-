clear all; close all; clc;format long;
t=0.1; ix=0.25; 
ss=8; ue(1:ss,1)=0; un1=ue; un2=ue;
for n=1:ss
    N=5*(2^n); h=1/N; hh(n)=h;
    x=[ix-2*h  ix-h ix ix+h ix+2*h]; 
    p=min(find(x==ix));
    u=sin(pi*x)*exp(-pi*pi*t);
    ue(n)=pi*cos(pi*x(p))*exp(-pi*pi*t);
un1(n)=(u(p+1)-u(p))/h;
un2(n)=(u(p+1)-u(p-1))/(2*h);
clear x
nume1(n)=abs(ue(n)-un1(n)); % L1 error between exact and 1st-order forward difference method
nume2(n)=abs(ue(n)-un2(n)); % L1 error between exact and 2nd-order forward difference method
end
plot(hh,ue,'k-'); %exact
hold on;
plot(hh,un1,'b:'); %1st-order
plot(hh,un2,'r-.'); %2nd-order
legend('exact','1st','2nd')
[nume1; nume2]

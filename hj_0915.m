clear all; close all; clc
Nx=20; Ny=30; h=1.0; dt=0.1*h^2;
x=linspace(-0.5*h,h*(Nx+0.5),Nx+2);
y=linspace(-0.5*h,h*(Ny+0.5),Ny+2);
phi(1:Nx+2,1:Ny+2)=0; phin=phi;
maxiter=1000;
for i=1:Nx+1
for j=1:Ny+1
if x(i)>5 && x(i)<15 && y(j)>5 && y(j)<25
phi(i,j)=1;
else
phi(i,j)=0;
end
end
end
iphi=phi; xx=2:Nx+1; yy=2:Ny+1;
mesh(x(xx),y(yy),phi(xx,yy)')
%% main loop
for iter=1:maxiter
phi(1,:)=phi(2,:); phi(Nx+2,:)=phi(Nx+1,:);
phi(:,1)=phi(:,2); phi(:,Ny+2)=phi(:,Ny+1);
for i=2:Nx+1
    for j=2:Ny+1
phin(i,j)=phi(i,j)+...
    dt*(phi(i+1,j)+phi(i-1,j)+phi(i,j+1)+phi(i,j-1)-4*phi(i,j))/h^2;
    end
end
phi=phin;
mesh(x(xx),y(yy),phi(xx,yy)');
axis([x(1) x(end) y(1) y(end) 0 1])
box on; pause(0.1)
end


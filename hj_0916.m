clear all; close all; clc
Nx=30; Ny=30; Nz=30; h=1.0; dt=0.1*h^2;
x=linspace(-0.5*h,h*(Nx+0.5),Nx+2);
y=linspace(-0.5*h,h*(Ny+0.5),Ny+2);
z=linspace(-0.5*h,h*(Nz+0.5),Nz+2);
phi=zeros(Nx+2,Ny+2,Nz+2); phin=phi;
maxiter=1000;
tol=1e-8;
energy=zeros(1,maxiter);
xx=2:Nx+1; yy=2:Ny+1; zz=2:Nz+1;

% --- 초기조건: 3중 for문 대신 ndgrid + 논리 인덱싱으로 벡터화 ---
[Xg,Yg,Zg]=ndgrid(x,y,z);
mask = (Xg>5 & Xg<15) & (Yg>5 & Yg<25) & (Zg>5 & Zg<25);
phi(mask)=1;
iphi=phi;

[X,Y,Z]=meshgrid(x(xx),y(yy),z(zz));
figure(1);
p=isosurface(X,Y,Z,permute(phi(xx,yy,zz),[2 1 3]),0.5);
hp=patch(p,'FaceColor',[0.0 0.3627 0.913],'EdgeColor','none');
alpha(hp,0.5);
view(-33,33)
camlight;
lighting flat
axis([x(1) x(end) y(1) y(end) z(1) z(end)])
axis image; box on;

% --- 안전 정지 버튼 ---
stopFlag = false;
uicontrol('Style','pushbutton','String','정지',...
    'Position',[20 20 60 30],...
    'Callback', @(src,evt) assignin('base','stopFlag',true));

figure(2);
h_energy = plot(nan, nan, 'LineWidth', 1.5);
title('System Energy Decay over Time')
xlabel('Iteration')
ylabel('Energy')
grid on

r = dt/h^2;   % 반복 계산되는 상수는 루프 밖으로 미리 빼둠

%% main loop
for iter=1:maxiter
% --- 경계조건 (Neumann, 6면) ---
phi(1,:,:)=phi(2,:,:);       phi(Nx+2,:,:)=phi(Nx+1,:,:);
phi(:,1,:)=phi(:,2,:);       phi(:,Ny+2,:)=phi(:,Ny+1,:);
phi(:,:,1)=phi(:,:,2);       phi(:,:,Nz+2)=phi(:,:,Nz+1);

% --- 3중 for문 대신 배열 슬라이싱으로 라플라시안을 한 번에 계산 (벡터화) ---
phin(xx,yy,zz) = phi(xx,yy,zz) + r*( ...
      phi(xx+1,yy,zz) + phi(xx-1,yy,zz) + ...
      phi(xx,yy+1,zz) + phi(xx,yy-1,zz) + ...
      phi(xx,yy,zz+1) + phi(xx,yy,zz-1) - 6*phi(xx,yy,zz) );

phi=phin;

% --- 에너지 계산 (3중 for문 없이 배열 전체 합) ---
current_energy = 0.5 * sum(phi(xx,yy,zz).^2,'all') * (h^3);
energy(iter) = current_energy;

% --- figure(1): isosurface 갱신 (5회마다 한 번) ---
if mod(iter,5)==0
    if ~ishandle(hp)
        break
    end
    figure(1);
    delete(hp);
    p=isosurface(X,Y,Z,permute(phi(xx,yy,zz),[2 1 3]),0.5);
    hp=patch(p,'FaceColor',[0.0 0.3627 0.913],'EdgeColor','none');
    alpha(hp,0.5);
    lighting flat
end

% --- figure(2): 에너지 그래프 갱신 ---
if ~ishandle(h_energy)
    break
end
figure(2);
set(h_energy, 'XData', 1:iter, 'YData', energy(1:iter));
xlim([0 max(iter,10)])
drawnow

if current_energy < tol
    fprintf('Energy reached near zero at iteration %d. Stopping loop.\n', iter);
    break
end

if exist('stopFlag','var') && stopFlag
    fprintf('사용자가 정지 버튼을 눌러 iteration %d에서 종료합니다.\n', iter);
    break
end
end
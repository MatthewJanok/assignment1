% clc
% clear
% 
% mo = 9.11e-31;
% mn = 0.26*mo;
% kb = 1.381e-23;
% T = 300;
% Pscat = 1-exp(-1e-14/0.2e-12);
% tauMN = 0;
% 
% %Initialize Bottleneck
% % BLX = [0.8e-7 0.8e-7; 0.8e-7 1.2e-7; 1.2e-7 1.2e-7]; 
% % BLY = [0 0.4e-7; 0.4e-7 0.4e-7; 0.4e-7 0];
% % BHX = [0.8e-7 0.8e-7; 0.8e-7 1.2e-7; 1.2e-7 1.2e-7]; 
% % BHY = [1e-7 0.6e-7; 0.6e-7 0.6e-7; 0.6e-7 1e-7];
% % figure(3)
% % plot(BLX,BLY,'k',BHX,BHY,'k')
% % hold on
% 
% %Initialise the particles
% initialX = 200e-9*rand(100,1);
% initialY = 100e-9*rand(100,1);
% axis ([0 200e-9 0 100e-9])
% 
% %Initialise angles
% angleRad = 2*pi*rand(100,1);
% 
% %Set velocity
% vth = sqrt((kb*T)/mn);
% 
% %Maxwell Boltzman Inital Velocity
% MD1 = randn(100,1).*(vth/sqrt(2));
% MD2 = randn(100,1).*(vth/sqrt(2));
% MaxwellBoltzman = sqrt((MD1).^2+(MD2).^2);
% initialRV = MaxwellBoltzman;
% 
% % figure(1)
% % velocity = histogram(initialRV,20);
% 
% scat = 0;
% 
% 
% % velocityX = initialRV.*cos(angleRad);
% % velocityY = initialRV.*sin(angleRad);
% velocityX = initialX.*cos(angleRad);
% velocityY = initialY.*sin(angleRad);
% 
% for time = 0:1e-14:0.01
%     
% 
%     %Find new positions
%     newX = initialX + velocityX*1e-14;
%     newY = initialY + velocityY*1e-14;
%     
% %     %Check for Scatter
% %     Escat = rand(100,1) < Pscat;
% % %     if newX(Escat) > 0
% %         %Rethermalize
% %         MD1 = randn(100,1).*(vth/sqrt(2));
% %         MD2 = randn(100,1).*(vth/sqrt(2));
% %         MaxwellBoltzman = sqrt((MD1).^2+(MD2).^2);
% %         initialRV = MaxwellBoltzman;
% % 
% %         %Find New Velocities
% %         angleRad = 2*pi*rand(100,1);
% %         velocityX(Escat) = initialRV(Escat).*cos(angleRad(Escat));
% %         velocityY(Escat) = initialRV(Escat).*sin(angleRad(Escat));
% %         figure(1)
% %         velocity = histogram(initialRV,25);
% % 
% %         %Mean Free Path/Time Between Collisions
% % 
% %         scat = scat+ sum(Escat);
% %         tauMN = (time*100)/scat;
% %         Vavg = mean((velocityX.^2) + (velocityY.^2));
% %        
% %         MFP = tauMN*Vavg;
% %         
% %  
% %         figure(2)
% %         subplot(2,1,1)
% %         title('Mean Free Time')
% %         plot(time, tauMN, 'b.')
% %         hold on
% %         
% %         figure(2)
% %         subplot(2,1,2)
% %         title('Mean Free Path')
% %         plot(time, MFP, 'g.')
% %         hold on
%         
% %     end
% 
%    
%     
%     %Find temperature
%     Vavg = mean((velocityX.^2) + (velocityY.^2));
%     T = (mn*Vavg)/(kb);
% 
% 
% 
%     %Check X boundary conditions
%     [NH,IH] = max(newX);
%     [NL,IL] = min(newX);
%     
%     upperX = newX > 200e-9;
%     newX(upperX)= newX(upperX)-200e-9;
%     
%     lowX = newX < 0;
%     newX(lowX) = newX(lowX)+200e-9;
% 
%     
%     
%     %Check Y boundary conditions
%     [NumH,IndexH] = max(newY);
%     [NumL,IndexL] = min(newY);
%     
%     upperY = newY > 100e-9;
%     velocityY(upperY)= -velocityY(upperY);
%     
%     lowY = newY < 0;
%     velocityY(lowY) = -velocityY(lowY);
%     
%     
%    
%     
%     xv = [initialX newX];
%     yv = [initialY newY];
% %     Color =  colormap(hsv(100));
%     
% 
%     
% 
%     figure(3)
%     title('Confined Atoms');
%     plot(xv.', yv.', '.' );
% %     , BLX,BLY,'k',BHX,BHY,'k');
%     hold on
% 
%     axis ([0 200e-9 0 100e-9])
%     
%     
%     figure(4)
%     title('Average Temperature (C)');
%     plot(time, T, 'r.')
%     hold on  
% 
%  
%     initialX = newX;
%     initialY = newY;
%     
%     
%     pause(0.001)
%     time
% 
% end
% 
% hold off



clc
clear

mo = 9.11e-31;
mn = 0.26*mo;
kb = 1.381e-23;
T = 300;

%Initialise the particles
initialX = 200e-9*rand(100,1);
initialY = 100e-9*rand(100,1);
axis ([0 200e-9 0 100e-9])

%Initialise angles
angleRad = 2*pi*rand(100,1);

%Set velocity
vth = sqrt((kb*T)/mn);
velocityX = vth.*cos(angleRad);
velocityY = vth.*sin(angleRad);

for time = 0:1e-15:0.01
    %Find new positions
    newX = initialX + velocityX*1e-15;
    newY = initialY + velocityY*1e-15;
    
    
    %Find temperature
    Vavg = mean((velocityX.^2) + (velocityY.^2));
    T = (mn*Vavg)/(kb);
    
    
    %Check X boundary conditions
    [NH,IH] = max(newX);
    [NL,IL] = min(newX);
    
    upperX = newX > 200e-9;
    newX(upperX)= newX(upperX)-200;
    
    lowX = newX < 0;
    newX(lowX) = newX(lowX)+200;

    
    
    %Check Y boundary conditions
    [NumH,IndexH] = max(newY);
    [NumL,IndexL] = min(newY);
    
    upperY = newY > 100e-9;
    velocityY(upperY)= -velocityY(upperY);
    
    lowY = newY < 0;
    velocityY(lowY) = -velocityY(lowY);

    
    initialX = newX;
    initialY = newY;
    
    figure(1)
    plot(newX,newY, 'b.')
    hold on
    
    axis ([0 200e-9 0 100e-9])
    
    
    figure(4)
    title('Average Temperature (C)');
    plot(time, T, 'r.')
    hold on
    
    
    pause(0.01)
    time

end






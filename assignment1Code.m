clc
clear

mo = 9.11e-31;
mn = 0.26*mo;
kb = 1.381e-23;
T = 300;
Pscat = 1-exp(-1e-14/0.2e-12);
tauMN = 0;

%Initialize Bottleneck
BLX = [0.8e-7 0.8e-7; 0.8e-7 1.2e-7; 1.2e-7 1.2e-7]; 
BLY = [0 0.4e-7; 0.4e-7 0.4e-7; 0.4e-7 0];
BHX = [0.8e-7 0.8e-7; 0.8e-7 1.2e-7; 1.2e-7 1.2e-7]; 
BHY = [1e-7 0.6e-7; 0.6e-7 0.6e-7; 0.6e-7 1e-7];


%Initialise the particles
initialX = 200e-9*rand(100,1);
initialY = 0.2e-7.*rand(100,1) + 0.4e-7;
axis ([0 200e-9 0 100e-9])

%Initialise angles
angleRad = 2*pi*rand(100,1);

%Set velocity
vth = sqrt((kb*T)/mn);

%Maxwell Boltzman Inital Velocity
MD1 = randn(100,1).*(vth/sqrt(2));
MD2 = randn(100,1).*(vth/sqrt(2));
MaxwellBoltzman = sqrt((MD1).^2+(MD2).^2);
initialRV = MaxwellBoltzman;

% figure(1)
% velocity = histogram(initialRV,20);

scat = 0;


velocityX = initialRV.*cos(angleRad);
velocityY = initialRV.*sin(angleRad);


for time = 0:1e-14:0.01
    

    %Find new positions
    newX = initialX + velocityX*1e-14;
    newY = initialY + velocityY*1e-14;
    
    %Check for Scatter
    Escat = rand(100,1) < Pscat;
     if newX(Escat) > 0
        %Rethermalize
        MD1 = randn(100,1).*(vth/sqrt(2));
        MD2 = randn(100,1).*(vth/sqrt(2));
        MaxwellBoltzman = sqrt((MD1).^2+(MD2).^2);
        initialRV = MaxwellBoltzman;

        %Find New Velocities
        angleRad = 2*pi*rand(100,1);
        velocityX(Escat) = initialRV(Escat).*cos(angleRad(Escat));
        velocityY(Escat) = initialRV(Escat).*sin(angleRad(Escat));
        figure(1)
        velocity = histogram(initialRV,25);

        %Mean Free Path/Time Between Collisions

        scat = scat+ sum(Escat);
        tauMN = (time*100)/scat;
        Vavg = mean((velocityX.^2) + (velocityY.^2));
       
        MFP = tauMN*Vavg;
        
 
        figure(2)
        subplot(2,1,1)
        title('Mean Free Time')
        xlabel('Total Time in Sim (s)')
        ylabel('Mean Free Time (s)')
        plot(time, tauMN, 'b.')
        hold on
        
        figure(2)
        subplot(2,1,2)
        xlabel('Total Time in Sim (s)')
        ylabel('Mean Free PAth (m)')
        title('Mean Free Path')
        plot(time, MFP, 'g.')
        hold on
        
    end

   
    
    %Find temperature
    Vavg = mean((velocityX.^2) + (velocityY.^2));
    T = (mn*Vavg)/(kb);



    %Check X boundary conditions
    [NH,IH] = max(newX);
    [NL,IL] = min(newX);
    
    upperX = newX > 200e-9;
    newX(upperX)= newX(upperX)-200e-9;
    
    lowX = newX < 0;
    newX(lowX) = newX(lowX)+200e-9;

    
    
    %Check Y boundary conditions
    [NumH,IndexH] = max(newY);
    [NumL,IndexL] = min(newY);
    
    upperY = newY > 100e-9;
    velocityY(upperY)= -velocityY(upperY);
    
    lowY = newY < 0;
    velocityY(lowY) = -velocityY(lowY);
    
    
    
    %Check Upper Box Conditions
    %Left Condition
    UpperBoxLeftX0 = initialX < 0.8e-7;
    UpperBoxLeftX1 = newX > 0.8e-7; 
    UpperBoxLeftX = UpperBoxLeftX0>0 & UpperBoxLeftX1>0;
    
    UpperBoxLeftY = newY > 0.6e-7;
    
    bouncebackL = UpperBoxLeftX>0 & UpperBoxLeftY>0;
    velocityX(bouncebackL) = -velocityX(bouncebackL);
   
    
    %Center Condition
    UpperBoxCenterX1 = newX > 0.8e-7 ;
    UpperBoxCenterX2 = newX < 1.2e-7;
    UpperBoxCenterX = UpperBoxCenterX1>0 & UpperBoxCenterX2>0;
    
    UpperBoxCenterY0 = initialY < 0.6e-7;
    UpperBoxCenterY1 = newY > 0.6e-7;
    UpperBoxCenterY = UpperBoxCenterY0>0 & UpperBoxCenterY1>0;
    
    
    bouncebackC = UpperBoxCenterX>0 & UpperBoxCenterY>0;
    velocityY(bouncebackC) = -velocityY(bouncebackC);
    
    %Right Condition
    UpperBoxRightX0 = initialX > 1.2e-7;
    UpperBoxRightX1 = newX < 1.2e-7; 
    UpperBoxRightX = UpperBoxRightX0>0 & UpperBoxRightX1>0;
    
    UpperBoxRightY = newY > 0.6e-7;
    
    bouncebackR = UpperBoxRightX>0 & UpperBoxRightY>0;
    velocityX(bouncebackR) = -velocityX(bouncebackR);
      
    
    
    
    
    
    %Check Lower Box Conditions
    %Left Condition
    LowerBoxLeftX0 = initialX < 0.8e-7;
    LowerBoxLeftX1 = newX > 0.8e-7; 

    LowerBoxLeftX = LowerBoxLeftX0>0 & LowerBoxLeftX1>0;
    LowerBoxLeftY = newY < 0.4e-7;
    
    bouncebackL = LowerBoxLeftX>0 & LowerBoxLeftY>0;
    velocityX(bouncebackL) = -velocityX(bouncebackL);
   
    
    %Center Condition
    LowerBoxCenterX1 = newX > 0.8e-7 ;
    LowerBoxCenterX2 = newX < 1.2e-7;
    LowerBoxCenterX = LowerBoxCenterX1>0 & LowerBoxCenterX2>0;
    
    LowerBoxCenterY0 = initialY > 0.4e-7;
    LowerBoxCenterY1 = newY < 0.4e-7;
    LowerBoxCenterY = LowerBoxCenterY0>0 & LowerBoxCenterY1>0;
    
    
    bouncebackC = LowerBoxCenterX>0 & LowerBoxCenterY>0;
    velocityY(bouncebackC) = -velocityY(bouncebackC);
    
    %Right Condition
    LowerBoxRightX0 = initialX > 1.2e-7;
    LowerBoxRightX1 = newX < 1.2e-7; 

    LowerBoxRightX = LowerBoxRightX0>0 & LowerBoxRightX1>0;
    LowerBoxRightY = newY < 0.4e-7;
    
    bouncebackR = LowerBoxRightX>0 & LowerBoxRightY>0;
    velocityX(bouncebackR) = -velocityX(bouncebackR);
    
 
    
    
    
    xv = [initialX newX];
    yv = [initialY newY];
%     Color =  colormap(hsv(100));
    

    

    figure(3)
    title('Confined Atoms');
    plot(xv.', yv.','.', BLX,BLY,'k',BHX,BHY,'k');  
    hold on

    axis ([0 200e-9 0 100e-9])
    
    
    figure(4)
    title('Average Temperature (C)');
    plot(time, T, 'r.')
    hold on  

 
    initialX = newX;
    initialY = newY;
    
    
    pause(0.001)
    time

end

hold off









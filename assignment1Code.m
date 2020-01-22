clc
clear

mo = 9.11e-31;
mn = 0.26*mo;
kb = 1.381e-23;
T = 300;

%Initialise the particles
initialX = 200*rand(100,1);
initialY = 100*rand(100,1);
%boudaries = [200 200 200 200 200 200 200 200 200 200];
%scatter(initialX, initialY)
axis ([0 200 0 100])

%Initialise angles
angleRad = 2*pi*rand(100,1);

%Set velocity
vth = sqrt((kb*T)/mn);
velocityX = vth.*cos(angleRad);
velocityY = vth.*sin(angleRad);

for time = 0:0.00001:0.01
    %Find new positions
    newX = initialX + velocityX*0.00001;
    newY = initialY + velocityY*0.00001;
    
    
    
    %Check X boundary conditions
    [NH,IH] = max(newX);
    [NL,IL] = min(newX);
    
    upperX = newX > 200;
    newX(upperX)= newX(upperX)-200;
    
    lowX = newX < 0;
    newX(lowX) = newX(lowX)+200;

    
    
    %Check Y boundary conditions
    [NumH,IndexH] = max(newY);
    [NumL,IndexL] = min(newY);
    
    upperY = newY > 100;
    velocityY(upperY)= -velocityY(upperY);
    
    lowY = newY < 0;
    velocityY(lowY) = -velocityY(lowY);

    
    initialX = newX;
    initialY = newY;
    
    
    scatter(newX,newY)
 
    
    axis ([0 200 0 100])
    
    
    
    pause(0.01)
    time

end



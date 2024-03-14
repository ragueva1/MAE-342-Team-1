close all; clear; clc;

%% User Inputs & Definitions

n = 2; % F.S.
Sy = 39.5; % MPa, static yield strength
guess = 2; % inches, initial guees for the diameter, then we'll iterate
L = 22; % Length of the shaft, change as desired

% Write the vector componets of the forces applied. Fy1 and Fz1
% are the loads applied gear 1
Fy1 = 350; Fy2 = 0;
Fz1 = 0;   Fz2 = 451;

% Write the diamters of Gear 1 and Gear 2
gDia1 = 8;
gDia2 = 6;

% Write the x position of each gear along the shaft
xPosGr1 = 8;
xPosGr2 = 16;


%% Solving Support Reactions

% Fy and Fz are single point loadings along x axis in the y and z direction
% respectively. These need to be defined by the user.
% xFy and xFz are the positions along x

Fy = [Fy1 Fy2]; 
Fz = [Fz1 Fz2]; 
 
xPos = [xPosGr1; xPosGr2];
Fy = [Fy1 Fy2]; 
Fz = [Fz1 Fz2]; 
 
xPos = [xPosGr1; xPosGr2];

By = -Fy*xPos/L;
Bz = -Fz*xPos/L;

Ay = -(sum(Fy)+By);
Az = -(sum(Fz)+Bz);

gDia = [gDia1 gDia2; gDia1 gDia2]
FT = [-300 50; 392 -59]

Tx = FT*(gDia/2)


%% Calcs. for Shear-Moment Diagrams   
% very boof, don't judge, ME major not CSE, just works :)

x1 = 0:.1:xPos(1);
Vy1 = Ay*ones(size(x1));
Mz1 = Ay*x1;
Vz1 = Az*ones(size(x1));
My1 = Az*x1;

x2 = xPos(1):.1:xPos(2);
Vy2 = (Ay+Fy(1))*ones(size(x2));
Vz2 = (Az+Fz(1))*ones(size(x2));
X2 = x2-xPos(1);
Mz2 = (Ay+Fy(1))*X2+Mz1(end);
My2 = (Az+Fz(1))*X2+My1(end);

x3 = xPos(2):.1:L-.1;
Vy3 = (Ay+Fy(1)+Fy(2))*ones(size(x3));
Vz3 = (Az+Fz(1)+Fz(2))*ones(size(x3));
X3 = x3-xPos(2);
Mz3 = (Ay+Fy(1)+Fy(2))*X3+Mz2(end);
My3 = (Az+Fz(1)+Fz(2))*X3+My2(end);

x4 = L;
Vy4 = 0;
Mz4 = 0;
Vz4 = 0;
My4 = 0;

X = [x1 x2 x3 x4];
Vy = [Vy1 Vy2 Vy3 Vy4];
MZ = [Mz1 Mz2 Mz3 Mz4];
Vz = [Vz1 Vz2 Vz3 Vz4];
MY = [My1 My2 My3 My4];
Mr = (MY.^2+MZ.^2).^(1/2);
% Mr is the resultant moment from taking the magnitude of the two
% orthagonal moments Mzz and Myy. From This moment we can find critical
% points of interes. 

%% Ploting the Shear Moment Diagrams
% Here I will add, 0 is the side closes to the input side of the
% shaft...doesn't really change anything because you can look at the box
% from many different perspectives.
tiledlayout("flow");
nexttile
plot(X, Vy);
title('Shear in Y')
set(gca, 'XAxisLocation', 'O');
xlabel('Position (x)');
ylabel('Shear Vy(x)');

nexttile
plot(X, Vz);
title('Shear in Z');
set(gca, 'XAxisLocation', 'O');
xlabel('Position (x)');
ylabel('Shear Vz(x)');

nexttile;
plot(X,MZ);
title('Moment around Z');
set(gca, 'XAxisLocation', 'top');
xlabel('Position (x)')
ylabel('Moment My(x)')

nexttile
plot(X, MY);
title('Moment around Y');
set(gca, 'XAxisLocation','Top');
xlabel('Position (x)')
ylabel('Momenent My(x)')

figure;
plot(X, Mr);
title('Combined Moment');
xlabel('Position (x)')
ylabel('Moment Mr(x)')

 
%% Solving Directional Stresses
 loc1 = find(X==xPos(1));
 loc2 = find(X==xPos(2));
 
 Mcp = [Mr(1,loc1(1)); Mr(1, loc2(1))];

 sigx = 32*Mcp/(pi()*guess^3);
 tauxy = 16*Tx(1)/(pi()*guess^3);

 VM = (sigx.^2+tauxy.^2).^(1/2);

% Solving for diameter, iterates until SF req is met


while VM(1,1) >= Sy/n && VM(2,1) >= Sy/n
    guess = guess+.1;
    sigx  = 32.*Mcp./(pi()*guess^3);
    tauxy = 16*Tx(1)/(pi()*guess^3);
    VM    = (sigx.^2+tauxy.^2).^(1/2);
end

VM(end)
guess

% ASSUMPTIONS
%  1. Spure gears are being used
%       - no axial loadings
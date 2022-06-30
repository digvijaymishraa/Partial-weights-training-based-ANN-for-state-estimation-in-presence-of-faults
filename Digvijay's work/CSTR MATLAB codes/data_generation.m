clear all
clc
close all
SetGraphics;

% CHANGES DONE
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % -ADDITION OF WITHOUT NOISE AND AT STEADY VALUE OF DISTURBANCE=2.
 
 % MEASUREMENT NOISE V(K) WHICH WAS GIVEN 2D VECTOR REDUCED TO 1D AS ONLY
 % TEMP IS MEASURED AND NOT CONC AND CORRESPONDING VARIANCE IS 0.15^2.
 
 % ADDITION OF RNG(2) AT LINE 25 WHICH ACTS AS SEED AND PRBS CYCLE REMAINS
 % SAME AND MAKE RANDOM ALLOTMENT CONSTANT.
 
 % PUT C=[0,1]  AS TO GET ONLY TEMP AS IT IS THE ONLY MEASUREMENT
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%rng(2);
randn('seed',0);
global Uk
global d1

%global k0      %% uncomment to generate multiple datasets for rate
%constant

% global hr     %% uncomment to generate multiple datasets for heat of
% reaction

u=[1 15]';

d=2;
xstar=[0 0]';

%HR = linspace(9,11,100); %% range for which u want to generate datasets 
 j=1;
 
 %%%%%%% change the value of 'o' to generate multiple datasets 
for o=1
   
    
    %hr = HR(o)

X=fsolve('cstrequations2',xstar);
s=[X;u;d];
steady(:,1)=s(1:2,1);

C=eye(2);
Ts=0.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_samples = 20000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ip1t = 0.1*idinput( N_samples, 'prbs', [0 0.05]) ;
ip2t = 1.5*idinput( N_samples, 'prbs', [0 0.05]) ;
ukt = [ ip1t'; ip2t'] ;


% ip1t1 = 0.05*idinput( N_samples, 'prbs', [0 0.005]) ;
% ip1t2 = 0.04*idinput( N_samples, 'prbs', [0 0.01]);
% ip1t = ip1t1 + ip1t2;
% 
% ip2t1 = 0.7*idinput( N_samples, 'prbs', [0 0.005]) ;
% ip2t2 = 0.8*idinput( N_samples, 'prbs', [0 0.01]) ;
% ip2t  = ip2t1 + ip2t2;

ukt = [ ip1t'; ip2t'] ;

%%%%%%%%%%%%%%%%%% For temp and conc as measured state %%%%%%%%%%%%%

R=diag([0.01^2 0.15^2]);
mean=zeros(2,1);
vk=mvnrnd(mean,R,N_samples);

%%%%%%%%%%%%%%%%%%%% For temp as measured state  %%%%%%%%%%%%%%
% R= 0.25^2;
% mean= 0;
% vk=mvnrnd(mean,R,N_samples);

Qd=(0.012)^2;
mean=0;
dk=mvnrnd(mean,Qd,N_samples);
Q = diag([(0.012)^2,(0.012)^2]);

xinitialdyn = zeros(2,N_samples);
xinitialdyn2 = zeros(2,N_samples);
Ykt = zeros(2,N_samples);
Ykt2 = zeros(2,N_samples);

xinitialdyn(:,1)=steady + (sqrt(Q)* randn(2,1));
xinitialdyn2(:,1)= steady ;

Ykt(:,1) = C*xinitialdyn(:,1)+ sqrt(R)* randn(2,1);
Ykt2(:,1) = C*xinitialdyn2(:,1);


for i=1:(N_samples-1)
    
    U_kt(:,i)=u+ukt(:,i);
    D_k(i)=d+dk(i);
    
end

% Uncomment only to get manipulated input plots

% time = Ts*(1:N_samples-1);
% 
% figure(1)
% plot(time(1:600), U_kt(1,1:600));
% title('U1: Feed flowrate of reactant A')
% xlabel('Time')
% ylabel('U1')
% ylim([0.5 1.3])
% figure(2)
% plot(time(1:600), U_kt(2,1:600));
% title('U2: Flow rate of coolant in jacket')
% xlabel('Time')
% ylabel('U2')
% ylim([12 18])
% 


for i=1:(N_samples-1)
  
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   % WITH DISTURBANCE AND MEASUREMENT NOISE
   
    Uk=U_kt(:,i);
    %Uk = u;
    d1=2;
    %d1=0;
    
    [T,X]=ode45('cstrdynnon2',[0 0.1],xinitialdyn(:,i));
    xinitialdyn(:,i+1)=X(end,:)'+ sqrt(Q)* randn(2,1);
    Ykt(:,i+1) = C*xinitialdyn(:,i+1) + sqrt(R)* randn(2,1);
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % WITH D=2 AND NO MEASUREMENT NOISE
   d1 = 2;
   [T,X2] = ode45('cstrdynnon2',[0 0.1],xinitialdyn2(:,i));
   xinitialdyn2(:,i+1)=X2(end,:)';
   Ykt2(:,i+1) = C*xinitialdyn2(:,i+1);
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

Ykt = Ykt';
Ykt2 = Ykt2';
xinitialdyn2 = xinitialdyn2';
xinitialdyn = xinitialdyn';

% time = Ts*(1:N_samples-1);
% 
% figure(1)
% plot(time(1:600), xinitialdyn2(1:600,1));
% title('X1: Concentration of A in reactor')
% xlabel('Time')
% ylabel('X1')
% % ylim([0.5 1.3])
% figure(2)
% plot(time(1:600), xinitialdyn2(1:600,2));
% title('X2: Reactor Temperature')
% xlabel('Time')
% ylabel('X2')
% ylim([12 18])


% 
% time = Ts*(1:N_samples-1);
% 
% figure(1)
% subplot(311)
% plot(time(50:500), U_kt(1,50:500));
% subplot(312)
% plot(time(50:500), U_kt(2,50:500));
% 
% figure(2)
% %plot(time(100:1500), Ykt(100:1500,2));
% plot(time(50:500), Ykt(50:500,1));
% title('With measurement noise')
% 
% figure(3)
% plot(time(50:500), Ykt2(50:500,1));
% title('Without measurement noise & PROCESS NOISE')
% 
% figure(4)
% hold on
% plot(time(50:500), Ykt(50:500,1));
% plot(time(50:500), Ykt2(50:500,1));
% legend('With measurement noise','Without measurement noise & PROCESS NOISE');
% 
% 
% % UNCOMMENT COMMANDS TO SAVE DATA AS CSV FILES
% % 
% % input_neural = U_kt';
% % csvwrite('Input 20k with 0.05 band and 10% pertub.csv', input_neural)

  %%% generate ready to use output files for different values of HR 
  p = string(o);
  q = 'output without noise.csv';
  r = p+' '+q;
  output3 = xinitialdyn2(2:19999,:);
  csvwrite(r,output3)
  
  %%% generate ready to input output files for different values of HR
  p = string(o);
  q = 'input without noise.csv';
  r = p+' '+q;
  input_neural = U_kt';
  outt = [input_neural(1:19998,1),input_neural(1:19998,2),xinitialdyn2(1:19998,2),xinitialdyn2(1:19998,1)];
  csvwrite(r , outt)

  %%% generate ready to use disturbance files for different values of HR
output5 = D_k';
csvwrite('Random Disturbance.csv', output5)

%%% generate ready to use plant measurement files for different values of HR
output6 = Ykt;
dlmwrite("Plant_Measurement.csv", output6, 'delimiter', ',', 'precision', '%i')

%%% generate ready to use true state files for different values of HR
output1 = xinitialdyn;
dlmwrite("True_states.csv", output1, 'delimiter', ',', 'precision', '%i')

end
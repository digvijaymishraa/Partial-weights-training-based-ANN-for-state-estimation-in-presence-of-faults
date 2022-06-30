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
 
 % PUT C=[0,1] (LINE 87)  AS TO GET ONLY TEMP AS IT IS THE ONLY MEASUREMENT
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(2);
global Uk
global d1
u=[1 15]';

d=2;
xstar=[0 0]';

X=fsolve('cstrequations',xstar);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %R=diag([0.01^2 0.15^2]);
% mean=zeros(2,1);
% vk=mvnrnd(mean,R,N_samples);

R= 0.25^2;
mean= 0;
vk=mvnrnd(mean,R,N_samples);

Qd=(0.012)^2;
mean=0;
dk=mvnrnd(mean,Qd,N_samples);

xinitialdyn(1,:)=steady';


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



 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 xinitialdyn2(1,:)= steady';
 C = [0 1];
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:(N_samples-1)
  
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   % WITH DISTURBANCE AND MEASUREMENT NOISE
   
    Uk=U_kt(:,i);
    %Uk = u;
    d1=D_k(i);
    %d1=0;
    
    [T,X]=ode45('cstrdynnon',[0 0.1],xinitialdyn(i,:)');
    xinitialdyn(i+1,:)=X(end,:);
    Ykt(i,:) = C*(xinitialdyn(i,:)') + vk(i,:)';
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % WITH D=2 AND NO MEASUREMENT NOISE
   d1 = 2;
   [T,X2] = ode45('cstrdynnon',[0 0.1],xinitialdyn2(i,:)');
   xinitialdyn2(i+1,:) = X2(end,:);
   Ykt2(i,:) = C*(xinitialdyn2(i,:)');
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

time = Ts*(1:N_samples-1);

figure(1)
plot(time(1:600), xinitialdyn2(1:600,1));
title('X1: Concentration of A in reactor')
xlabel('Time')
ylabel('X1')
% ylim([0.5 1.3])
figure(2)
plot(time(1:600), xinitialdyn2(1:600,2));
title('X2: Reactor Temperature')
xlabel('Time')
ylabel('X2')
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
% % output = Ykt;
% % csvwrite('output 20k with temp and conc.csv', output)
% 
% 
% % for i= 1:(N_samples-1)
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % FOR NO MEASUREMENT AND PROCESS NOISE
% %     past(i,:) = xinitialdyn2(i+1,:);   
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% %   
% %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   % FOR MEASUREMENT AND PROCESS NOISE
% %     past_noise(i,:) = xinitialdyn(i+1,:);   
% %   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% % 
% % end
% 
% % input_neural = U_kt';
% % csvwrite('1)MAnipulated Input 20k with 0.05 band and 10% pertub.csv', input_neural)
% 
% % output1 = xinitialdyn;
% % csvwrite('2)State variables(T&C) 20k with PRocess noise .csv', output1)
% 
% % output2 = Ykt;
% % csvwrite('3)Measurement variable(T) 20k with PRocess and measurement noise .csv', output1)
% % 
% % output3 = xinitialdyn2;
% % csvwrite('4)State variables(T&C) 20k NO noise .csv', output3)
% % output4 = Ykt2;
% % csvwrite('5)Measurement variable(T) 20k NO noise .csv', output4)
% 
% % output5 = D_k';
% % csvwrite('Disturbance added.csv', output5)
% 
% % output6 = Ykt;
% % % csvwrite('Plant_Measurement.csv', output6)
% % dlmwrite("Plant_Measurement2.csv", output6, 'delimiter', ',', 'precision', '%i')
% % 
% % output1 = xinitialdyn;
% % dlmwrite("True_states_PRocessnoise.csv", output1, 'delimiter', ',', 'precision', '%i')
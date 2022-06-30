close all
clear all

% rng(3);
randn('state',0);    %Note run this each time simulation happening, if simulation happening and this not run then it will generate random numbers(not fixed)

global UK_NL
UK_NL = [152.46,155.60]';
Uk_steady = UK_NL;
xstar=[17,16,7,4]';
sampling_period = 5;
N_samples = 5000;
C = [1,0,0,0; 0,1,0,0];

x_steady = fsolve('four_tank_fsolve_equation',xstar); 

%%%%%%%%%%%%%%%%%%%%% generating prbs signal%%%%%%%%%%%%%%%%%%%%% 
% 
% ip1t = 15*idinput( N_samples, 'prbs', [0 0.05]) ;
% ip2t = 17*idinput( N_samples, 'prbs', [0 0.05]) ;
ip1t = 15*idinput( N_samples, 'prbs') ;
ip2t = 17*idinput( N_samples, 'prbs') ;
uk = [ip1t,ip2t];

Uk_withprbs = UK_NL' + uk;


%%%%%%%%%%%%%%%%%%%%% Process and mesurement noises %%%%%%%%%%%%%%%%%

% Process Noise

randn('state',0);
Qd= 0.01 * eye(4);
mean= zeros(4,1);
wk=mvnrnd(mean,Qd,N_samples);

% Measurement Noises

randn('state',0);
R= 0.01*eye(2);
mean= zeros(2,1);
vk=mvnrnd(mean,R,N_samples);

%%%%%%%%%%%%%%%%%%%%% SImulation without process & measurement noise %%%%%%%%%%%%%%%%%

x_without_processnoise(1,:)= x_steady';


for i=1:N_samples
    
    UK_NL = Uk_withprbs(i,:);
    [T,X] = ode45('four_tank_ODE_equation',[0 sampling_period],x_without_processnoise(i,:)');
    x_without_processnoise(i+1,:) = X(end,:);
    Y_without_noises(i,:)= (C*x_without_processnoise(i+1,:)')' ;
end


%%%%%%%%%%%%%%%%%%%%% SImulation with process & measurement noise %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%

x_with_noises(1,:)= x_steady';


for i=1:N_samples
    
    UK_NL = Uk_withprbs(i,:);
    [T,X] = ode45('four_tank_ODE_equation',[0 sampling_period],x_with_noises(i,:)');
    x_with_noises(i+1,:) = X(end,:) + wk(i,:);
    Y_with_noises(i,:) = (C*x_with_noises(i+1,:)')'  + vk(i,:);
end

%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%% 
% 
% figure(1)
% % time = 1:length(Uk_withprbs);
% time = 1:length(50:1000);
% hold on
% plot(Uk_withprbs(50:1000,1));
% plot(time,Uk_steady(1),'*');
% 
% figure(2)
% hold on
% plot(Uk_withprbs(50:1000,2));
% plot(time,Uk_steady(2),'*');
% 
figure(3)
hold on
plot(x_without_processnoise(50:1000,1));
plot(x_without_processnoise(50:1000,2));
plot(x_without_processnoise(50:1000,3));
plot(x_without_processnoise(50:1000,4));
legend('Height 1','Height 2','Height 3','Height 4' );
% 
% % Figure consisting comparison of addition of process noise
% 
% figure(4)
% hold on
% plot(x_without_processnoise(50:100,1));
% plot(x_with_noises(50:100,1),'R');
% legend({'Without Process noise','With process noise'},'Location','best');
% 
% figure(5)
% hold on
% plot(Y_without_noises(50:100,1));
% plot(Y_with_noises(50:100,1),'R');
% legend({'Without Process & measurement noise','With process & measurement noise'},'Location','best');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%% Autocorrelation %%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% [c,lags] = xcorr(x_without_processnoise(10:40,1),'normalized');
% figure(5)
% stem(lags,c);
% xlabel('Time Lag');
% ylabel('Normalized correlation value')
% legend('Height 1')
% [c,lags] = xcorr(x_without_processnoise(10:40,2),'normalized');
% figure(6)
% stem(lags,c);
% xlabel('Time Lag');
% ylabel('Normalized correlation value')
% legend('Height 2')
% [c,lags] = xcorr(x_without_processnoise(10:40,3),'normalized');
% figure(7)
% stem(lags,c);
% xlabel('Time Lag');
% ylabel('Normalized correlation value')
% legend('Height 3')
% [c,lags] = xcorr(x_without_processnoise(10:40,4),'normalized');
% figure(8)
% stem(lags,c);
% xlabel('Time Lag');
% ylabel('Normalized correlation value')
% legend('Height 4')
% [c,lags] = xcorr(x_without_processnoise(10:40,:),'normalized');
% figure(9)
% stem(lags,c);
% xlabel('Time Lag');
% ylabel('Normalized correlation value')
% legend('All 16 combinations')

% 
% %%%%%%%%%%%%%%%%%%%%%%%% Save data files as csv files%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Save Manipulated input files
% input_neural = Uk_withprbs;
% csvwrite('1)MAnipulated Input 20k with and approx more than 10% pertub.csv', input_neural)
% 
% 
% % Save noise free states
% input_neural = x_without_processnoise;
% csvwrite('2)State variables(h1,h2,h3,h4) 20k with no noise .csv', input_neural)
% 
% % Save measurement without any noises (which is same as state1 and state2
% input_neural = Y_without_noises;
% csvwrite('3)State variables(h1,h2) which are measured 20k with no noise .csv', input_neural)
% 

% Save states with only process noise
% input_neural = x_with_noises;
% csvwrite('4)State variables(h1,h2,h3,h4) 20k with only process noise .csv', input_neural)
% 
% % Save measurement with measurement noise (which is same as state1 and state2
% input_neural = Y_with_noises;
% csvwrite('5)State variables(h1,h2) which are measured 20k with measurement noise .csv', input_neural)


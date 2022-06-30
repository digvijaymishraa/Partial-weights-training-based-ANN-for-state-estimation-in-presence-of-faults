function dh = four_tank_fsolve_equation(h)
% global A1 A2 A3 A4 a1 a2 a3 a4 gama_1 gama_2 g
global UK_NL
A1 = 192; A2 = 192; A3 = 192; A4 = 192;
a1 = 0.852; a2 = 0.755; a3 = 0.661; a4 = 0.612;
gama_1 = 0.55; gama_2 = 0.47; g = 981;

dh(1)= -(a1/A1)*(2*g*h(1))^0.5 + (a3/A1)*(2*g*h(3))^0.5 + gama_1*UK_NL(1)/A1;
dh(2)= -(a2/A2)*(2*g*h(2))^0.5 + (a4/A2)*(2*g*h(4))^0.5 + gama_2*UK_NL(2)/A2;
dh(3)= -(a3/A3)*(2*g*h(3))^0.5 + (1-gama_2)*UK_NL(2)/A3;
dh(4) = -(a4/A4)*(2*g*h(4))^0.5 + (1-gama_1)*UK_NL(1)/A4;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HERE ADDTION OF K1 AND K2 (PARAMETER OF PUMP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTO THE EQUATION %%%%%%%%%%%%%%%%%%%%%%%%%%%

% NOT USED IN TATHAGAT'S RESEARCH, HENCE IGNORE

% k1= 3.33; k2= 3.35;
% 
% dh(1)= -(a1/A1)*(2*g*h(1))^0.5 + (a3/A1)*(2*g*h(3))^0.5 + gama_1*k1*UK_NL(1)/A1;
% dh(2)= -(a2/A2)*(2*g*h(2))^0.5 + (a4/A2)*(2*g*h(4))^0.5 + gama_2*k2*UK_NL(2)/A2;
% dh(3)= -(a3/A3)*(2*g*h(3))^0.5 + (1-gama_2)*k2*UK_NL(2)/A3;
% dh(4) = -(a4/A4)*(2*g*h(4))^0.5 + (1-gama_1)*k1*UK_NL(1)/A4;

dh=dh';



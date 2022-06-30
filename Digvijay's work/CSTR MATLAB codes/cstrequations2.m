function dx=cstrequations2(x)


%%%% uncomment if want to generate multiple datasets
%global k0
% global hr

u=[1;15];
d1=2;
x1=x(1);
x2=x(2);


%%%% comment that perticular variable for which you are generating
%%%% different datasets and taking it as global variable

k0=10000000000*1.3; % reaction rate constant
v=1;
rho=1000000;
cp=1;
hr=130*10^6; % heat of reaction
rhoc=1000000; % density of the coolant
cpc=1;
tcin=365;
t0=323;
er=8330;
a=1678000;
b=0.5;
dx1bydt(1)=u(1)/v*(d1-x1)-k0*x1*exp(-er/(x2));
q=a*((u(2))^(b+1))*(x2-tcin)/(u(2)+(a*u(2)^b/(2*rhoc*cpc)));
dx1bydt(2)=u(1)/v*(t0-x2)+hr*k0/(rho*cp)*x1*exp(-er/(x2))-q/(v*rho*cp);
dx=dx1bydt';
end
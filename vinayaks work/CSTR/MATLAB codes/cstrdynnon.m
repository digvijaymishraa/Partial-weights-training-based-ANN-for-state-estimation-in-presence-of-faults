function dx=cstrdynnon(time,x)
   global Uk;
   global d1;

x1=x(1);
x2=x(2);



k0=10000000000;
v=1;
rho=1000000;
cp=1;
hr=130000000;
rhoc=1000000;
cpc=1;
tcin=365;
t0=323;
er=8330;
a=1678000;
b=0.5;
dx1bydt(1)=Uk(1)/v*(d1-x1)-k0*x1*exp(-er/(x2));
q=a*((Uk(2))^(b+1))*(x2-tcin)/(Uk(2)+(a*Uk(2)^b/(2*rhoc*cpc)));
dx1bydt(2)=Uk(1)/v*(t0-x2)+hr*k0/(rho*cp)*x1*exp(-er/(x2))-q/(v*rho*cp);
dx=dx1bydt';
end
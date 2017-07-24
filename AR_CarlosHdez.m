%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%AUTOREGRESIVO%%%% Carlos Hernández Hernández

%%% Algoritmo predicción de oleaje con método autoregresivo

%Análisis univariante de serie temporal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;

%Cargamos datos oleaje, Documentos Z 1, Z 2 y Z 3.
olas=xlsread('Olas desplazamiento Z 1');

%Filtro, función filtro, para eliminar frecuencias superiores a 0.4 Hz.
flim=0.4 ;

olas=olas(1:2000);
datos=olas;
[fun_ifft]=filtro(olas,flim); %Función filtro. Desarrollada conjuntamente con Guillermo Álamo Meneses.
olas=fun_ifft;

%Representamos y calculamos correlograma

figure(4)
subplot(2,2,1), plot(olas);
ylabel('Xn')
title('Trayectoria')

[fac_y,m]=autocorr(olas,[],2);
subplot(2,2,2), autocorr(olas,[],2)
title('fac');

[facp_y, mp] = parcorr(olas,[],2);
subplot(2,2,3), parcorr(olas,[],2)
title('facp');

v = (fac_y(1)-fac_y)/(fac_y(1)-fac_y(2));

subplot(2,2,4), stem(m,v);
grid
title('Variograma')

xt=olas-mean(olas);

figure(5)
% uso de la funcion "compare"
mitad = floor(length(xt)/2);
ye = xt(1:mitad);
yv = xt(mitad+1:end);
model= ar(ye,32);
compare(yv,model,1);
xlim([32 64]);


%Coeficientes del vector. Ecuaciones de Yules-Walker

vector=polydata(model).*(-1);


%Predice los datos de la siguiente ola, los 32 time step siguientes.

y=forecast(model, olas(1:32),32);

%Representamos datos calculados

x=33:1:64;
figure(6)
plot(x,y,'*-r');
xlim([32 64]);
ylim([-100 100]);

%Representamos datos reales, datos de olas reales para comparar con los
%calculados

hold on;
x=33:1:64;
plot(x,datos(33:64),'*-k');
xlim([32 64]);
ylim([-100 100]);
recta=(-100):1:100;
x= linspace(42,42,201);

%Representamos recta para diferenciar los 10 time step, o lo que es
%equivalente a 7 segundos, periodo de oleaje medio.

hold on;
plot(x,recta,'--b');
xlim([32 64]);
ylim([-100 100]);


%%% Conclusiones %%%

% Con el método autoregresivo y un buen filtrado se obtienen valores
% cercanos al 99 % de ajuste, no obstante, a la hora de predecir en base a
% los propios valores predichos se produce un fenómeno de propagación del
% error, por lo que la calidad en la predicción va disminuyendo conforme no
% se obtengan datos reales nuevos.



nombreArchivo = ; %Completar con el nombre del archivo que contiene la señal
%RDS de una transmisión FM pasada a bandabase.  Se asume que el canal 1 es la componente
%en fase, y el canal 2 es la cuadratura.
x=audioread(nombreArchivo);
data=x(:,1); %Componente en fase

%%
delay=  %Completar con el valor de delay óptimo

%% Visualizar histograma con delay elegido:
samples = (data(delay:16:end));
figure;
hist(samples)
title(['Histograma de muestras con delay ' num2str(delay)])

%% Determinar bits transmitidos
umbral = % Completar con umbral apropiado
bits = samples>umbral;
dbits = abs(diff(bits))>0; %Calcular diferencia de bits
chars = RDS_textDemod(dbits); %Determinar texto a partir de los bits


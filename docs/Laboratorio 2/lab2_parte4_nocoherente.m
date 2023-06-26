
nombreArchivo = ; %Completar con el nombre del archivo que contiene la señal
%RDS de una transmisión FM pasada a bandabase.  Se asume que el canal 1 es la componente
%en fase, y el canal 2 es la cuadratura.
x=audioread(nombreArchivo);
x = x(1:end-16,:)-x(17:end,:); %Diferencia con 16 samples de delay exactamente
data=abs(x(:,1)+1i*x(:,2)); %Magnitud de diferencia


%%
delay=  %Completar con el valor de delay óptimo

%% Visualizar histograma con delay elegido:
samples = (data(delay:16:end));
figure;
hist(samples,[min(data):std(data)/100:max(data)])
title(['Histograma de muestras con delay ' num2str(delay)])

%% Determinar bits transmitidos
umbral = % Completar con umbral apropiado
bits = samples>umbral;
dbits = abs(diff(bits))>0; %Calcular diferencia de bits
chars = RDS_textDemod(dbits); %Determinar texto a partir de los bits


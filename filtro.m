
function [fun_ifft]=filtro(olas,flim)

N=size(olas);
N=N(1);

dt=0.7; % paso de tiempo de muestreo
T=dt*N; % periodo de la señal
t=0:dt:dt*(N-1); % vector de tiempos

fm=1/dt; % freq. muestreo (Hz)
fny=fm/2; % freq. Nyquist (la maxima que podemos ver con la fm)
df=fny/(N/2); % paso del vector de frecuencias
f=0:df:fny; % vector de frecuencias

fun=olas;

FUN_ffto=fft(fun,N); % transformada (resultado en bruto de la fft)

FUN = FUN_ffto(1:floor((N/2+1))); % transformada (solo la correspondiente a frecuencias positivas)
figure(1);
plot(f,abs(FUN));

FUN(f>flim)= 0;


FUN_fft = [FUN ; conj(FUN(N/2:-1:2))]; % para antitrasformar debe tener el mismo formato que usa la fft: la freq. va de 0 a fny y luego las negativas de -fny+df hasta -df
fun_ifft = ifft(FUN_fft);
figure(2);
plot(t,fun_ifft);
figure(3);
plot(t,olas);

end


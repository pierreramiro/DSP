t=1:0.01:3;tiledlayout(3,1);nexttile;
stem(t,y1);
title('Señal muestreada');
nexttile;
stem(t,y2);
title('Señal windowed');...
nexttile;
stem(t,y3);
title('error de predicción');
axis([1 3 -1 1])
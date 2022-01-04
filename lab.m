close all
clear
[y,Fs]=audioread('vocales.wav');
vocales_char = ['a' 'e' 'i' 'o' 'u'];
vocal_a=y(1:16284);
vocal_e=y(16285:33729);
vocal_i=y(33730:50594);
vocal_o=y(52721:68867);
vocal_u=y(72080:length(y));
tiledlayout(2,3);
for i=1:length(vocales_char)
    command=sprintf('vocal=vocal_%c;',vocales_char(i));
    eval(command);
    tfinal=(length(vocal)-1)/Fs;
    t=(0:1/Fs:tfinal)';
    vocal_Table = timetable(seconds(t),vocal);    
    nexttile
    periodogram(vocal,[],length(vocal),Fs);

    
%     [pxx,f]=pspectrum(vocal_Table);%command=sprintf('plot(vocal_%c)',vocales_char(i));
%     nexttile
%     plot(f,pow2db(pxx));
%     grid on
%     xlabel('Frequency (Hz)');ylabel('Power Spectrum (dB)');title('Default Frequency Resolution')
end

theta=0.0833;
Q=0.98;
den=[1 -2*Q*cos(2*pi*theta) Q*Q];
figure; freqz(0.01,den,[],Fs);
%H_z=tf(0.01,den,1/Fs,'Variable','z^-1');
signal=100*randn(size(t));
figure;tiledlayout(2,1);
nexttile; periodogram(signal);
new_signal=filter(0.01,den,signal);
nexttile; periodogram(new_signal);

%buscamos la relación entre theta y la freq fundamental
%obtenemos vector theta_freq. Que nos ayudará a la hora de crear los
%filtros
%en la primera fila están los valores de theta
%en la segunda fila, los valores de freq correspondientes
cantidad_thetas=200;
theta_freq(2,cantidad_thetas)=0;
for i=1:cantidad_thetas
theta=0.5/(cantidad_thetas-1)*(i-1);
theta_freq(1,i)=theta;
den=[1 -2*Q*cos(2*pi*theta) Q*Q];
[h,w]=freqz(0.01,den,[],Fs);
[max_val,index]=max(h);
theta_freq(2,i)=w(index);
end
%plot(theta_freq(2,:),theta_freq(1,:))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%vocal a
% f1 =  934 a -40 dB 
% f2 = 1868.32 a -65.78 dB
% f3 = 2696.14 a -63.99 dB
% f4 = 3593.22 a -65.71 dB
% f5 = 4616    a -83.66 dB
%creamos los filtro
Q_a=0.98;
gain_vocal_a = 10.^([-40 -65.78 -58.99 -60.71 -83.66]/20);
freq_vocal_a = [934;1868.32;2704;3593.22;4616];
theta_vocal_a(length(freq_vocal_a))=0;
vocal_a_sint=zeros(length(t),1);%se puede modificar el valor de t

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%vocal e
%creamos los filtro
Q_e=0.97;
gain_vocal_e = 10.^([-61 -51.24 -64 -80 -81]/20);
freq_vocal_e = [620;2374.55;3600;4800;5479.16];
theta_vocal_e(length(freq_vocal_e))=0;
vocal_e_sint=zeros(length(t),1);%se puede modificar el valor de t

%vocal i
Q_i=0.97;
gain_vocal_i = 10.^([-65.72 -48.62 -40 -79 -79]/20);
freq_vocal_i = [351;2396.55;3569;5425.67;6548];
theta_vocal_i(length(freq_vocal_i))=0;
vocal_i_sint=zeros(length(t),1);%se puede modificar el valor de t

%vocal o
Q_o=0.95;
gain_vocal_o = 10.^([-38.84 -49.12 -49.96 -67.70 -80]/20);
freq_vocal_o = [800;2427.7;3246.18;5119.96;5950.33];
theta_vocal_o(length(freq_vocal_o))=0;
vocal_o_sint=zeros(length(t),1);%se puede modificar el valor de t


%vocal u
% f1 =  582.83 a -55.29 dB 
% f3 = 2330.32 a -68.93 dB
% f10= 4756.92 a -83.99 dB
% f12= 6851.06 a -92.76 dB
% f13  = 7617.65 a -96.66 dB
%creamos los filtro
Q_u=0.98;
gain_vocal_u = 10.^([-55.29 -68.93 -83.99 -92.76 -96.66]/20);
freq_vocal_u = [582.83;2330.32;4756.92;6851.06;7617.65];
theta_vocal_u(length(freq_vocal_u))=0;
vocal_u_sint=zeros(length(t),1);%se puede modificar el valor de t


figure
tiledlayout(2,3);
for ii=1:5
    command=sprintf('freq_vocal=freq_vocal_%c;',vocales_char(ii));
    eval(command);
    vocal_sint=zeros(length(t),1);
    for i=1:length(freq_vocal)
        temp=abs(theta_freq(2,:)-freq_vocal(i));
        [~,ind]=min(temp);
        theta=theta_freq(1,ind);
        command=sprintf('theta_vocal_%c(i)=theta;gain=gain_vocal_%c(i);Q=Q_%c;',vocales_char(ii),vocales_char(ii),vocales_char(ii));
        eval(command);
        %generamos la "formante"
        signal=randn(size(t)); %se puede modificar el valor de t. Aumenta o no el muestreo
        den=[1 -2*Q*cos(2*pi*theta) Q*Q];
        temp=filter(gain,den,signal);
        vocal_sint=vocal_sint+temp;
    %     figure
    %     periodogram(temp,[],length(vocal),Fs)
    end
    eval(sprintf('vocal_%c_sint=vocal_sint;',vocales_char(ii)));
    eval(command);
    
    tfinal=(length(vocal_sint)-1)/Fs;
    t=(0:1/Fs:tfinal)';
    nexttile
    periodogram(vocal_sint,[],length(vocal_sint),Fs);
end

gap=zeros(Fs*0.03,1);
new_vocales_sound=[gap;vocal_a_sint;gap;vocal_e_sint;gap;vocal_i_sint;gap;vocal_o_sint;gap;vocal_u_sint;gap];
sound(new_vocales_sound,Fs);
%sound(y,Fs);
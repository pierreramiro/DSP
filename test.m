close all
cantidad_thetas=200;
Q=0.99;
theta_freq(2,cantidad_thetas)=0;
for i=1:cantidad_thetas
theta=0.5/(cantidad_thetas-1)*(i-1);
theta_freq(1,i)=theta;
den=[2 -2*Q*cos(2*pi*theta) Q*Q];
[h,w]=freqz(0.01,den,[],Fs);
[max_val,index]=max(h);
theta_freq(2,i)=w(index);
end
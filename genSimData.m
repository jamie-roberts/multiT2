%Marcus Bj�rk & Dave Zachariah 2015
%Generate multi-exponential data, both Rice and Gaussian distributed.
clear


%% Set parameters
%Samples
N = 32;

%Set SNR in the resulting real-valued simulated data
SNR = 150; %note the MRI definition of SNR as mean signal over standard deviation

%MRI example
dt=10; %Sampling interval (ms)
%Relaxation times (ms)
T2_true=[200 
         80 
         20];
%Damping
d_true=dt./T2_true;
c_true=[0.2 
        1
        0.4];
    
%Model order (number of exponentials)
m_true = length(c_true);
    
%Time vector (here, uniform sampling)
t = dt*(0:N-1)';

%Simulate noise-free data
x_true = exp(-bsxfun(@times,1./T2_true(:)',t(:)))*c_true(:);

%Compute noise for given SNR (MRI-definition of SNR)
sigma2 = (mean(x_true)./SNR).^2;

%Compute real-valued data with Rician noise (sigma2-noise in both real and imag part)
y_Rice=abs(x_true + sqrt(sigma2)*(randn(N,1)+1i*randn(N,1)));
y_Gauss=x_true + sqrt(sigma2)*randn(N,1);

%Save data in mat-file (indicating SNR, number of samples, and number of exponentials)
save(['data_SNR' num2str(SNR) '_N' num2str(N) '_M' num2str(m_true)])

figure
plot(t,y_Rice,t,y_Gauss)
legend('Rice','Gauss')
xlabel('Time [ms]')
ylabel('Amplitude')
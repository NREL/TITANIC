function [mx,f] = SubSimpleFFTPSD(x,Fs)

% uses http://www.mathworks.com/support/tech-notes/1700/1702.html

%nfft = 2^(nextpow2(length(x))-1);
nfft = length(x) -1;

% Take fft, padding with zeros so that length(fftx) is equal to nfft 

fftx = fft(x,nfft);
% Calculate the number of unique points

NumUniquePts = ceil((nfft+1)/2);

% FFT is symmetric, throw away second half

fftx = fftx(1:NumUniquePts);

mx = abs(fftx);

% Scale the fft so that it is not a function of the length of x

mx = mx/length(x);


% Now, take the square of the magnitude of fft of x which has been scaled properly.
mx = mx.^2; 


% Since we dropped half the FFT, we multiply mx by 2 to keep the same energy.
% The DC component and Nyquist component, if it exists, are unique and should not be multiplied by 2. 

if rem(nfft, 2) % odd nfft excludes Nyquist point 
  mx(2:end) = mx(2:end)*2;
else
  mx(2:end -1) = mx(2:end -1)*2;
end

% This is an evenly spaced frequency vector with NumUniquePts points.

f = (0:NumUniquePts-1)*Fs/nfft;

% tidy outputs
mx = mx';
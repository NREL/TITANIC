function [w, U] = spectrum_FFT(u,dt,Nband,Nfft,ZeroPadding,Wname)
%SPA_AVF Spectral analysis with frequency averaging
%   [G,W]=SPA_AVF(U,Y,Ts,Nband) determines a frequency-domain estimate
%   SYS=FRD(G,W) of the transfer function of the plant. The sample time is
%   given in Ts. Nband is the number of frequency bands to average.
%   Averaging in the frequency domain is used to get a smoother frequency
%   response function. The spectrum is smoothed locally in the region of
%   the target frequencies, as a weighted average of values to the right
%   and left of a target frequency. The variance of the spectrum will
%   decrease as the number of frequencies used in the smoothing increases.
%   As the bandwidth increases, more spectral ordinates are averaged, and
%   hence the resulting estimator becomes smoother, more stable and has
%   smaller variance.

%   [G,W]=SPA_AVF(U,Y,R,Ts,Nband) determines a frequency-domain estimate
%   SYS=FRD(G,W) of the transfer function of the plant operating in
%   closed-loop. Because the conventional transfer function estimate, will
%   give a biased estimate under closed-loop [2]. An unbiased alternative
%   is to use cross-spectral between the input/output signals with an
%   external excitation signal r [1]. Hence, we define the estimate:
%             G(exp(j*omega)) = Phi_yr(omega)*inv(Phi_ur(omega))

%   [G,W]=SPA_AVF(...,Ts,Nband,Nfft) specifies the number of evaluated
%   frequencies. For large data sequences it is wortwhile to choose the
%   value Nfft as function of the power of two. In this case a faster
%   method is used durring the FFT. Nfft <= length(u), unless zeros are
%   added. See also, FFT.

%   [G,W]=SPA_AVF(...,Ts,Nband,Nfft,ZeroPading) adds additional zeros to
%   the data sequences. Usefull for increasing the number of evaluated
%   frequencies.

%   [G,W]=SPA_AVF(...,Ts,Nband,Nfft,ZeroPading,Wname) specifies and aplies
%   an window to the data. Windowing weigths the data, it increases the
%   importance of the data in the middle of the vector and decreases the
%   importance of the data at the end and the beginning, thus reducing the
%   effect of spectral leakage. See also, WINDOW.

%   [G,W,Coh,mSuu,mSyy,U,Y]=SPA_AVF(...) gives the coherence function as output
%   and mSuu and mSyy will give the PSD's of u and y, respectively. The
%   matrices U and Y are the not averaged FFT's (note: you can use squeeze
%   to turn it into a vector when you don't have a MIMO system)


%   Revsion 2: Now also works properly for MIMO cases.



% References:
%   [1] Akaike, H., Some problems in the application of the cross-spectral
%       method, In spectral analysis of time series, pp. 81-107, Wiley,
%       New York, 1967.
%   [2] van den Hof, P., System Identification, Lecture Notes, Delft, 2007.

%  Ivo Houtzager
%
% Minor modifications Jan-Willem van Wingerden 2010
%  Delft Center of Systems and Control
%  The Netherlands, 2008


% Transpose vectors if needed
if size(u,2) < size(u,1);
    u = u';
end
nu = size(u,1); % number of inputs

% Apply window and zeros if needed
if nargin == (6)
    u = u.*(ones(nu,1)*p_hamming(size(u,2))); % remove dependcy on signal toolbox
    %u = u.*(ones(nu,1)*window(Wname,size(u,2))');

end
if nargin == (5)
    u = [u zeros(nu,ZeroPadding)];
end
if nargin < (4)
    Nfft = [];
end

% Some administration
Fs = 1./dt;                         % Sample frequency
N  = length(u);                     % Number of samples
T  = N*dt;                          % Total time
if isempty(Nfft)
    f = (0:N-1)'/T;                 % Frequency vector (double sided)
else
    f = (linspace(0,N-1,Nfft))'/T;  % Frequency vector (double sided)
end
Nf = length(f);

% Determine Fourier transforms
U = zeros(nu,1,Nf);
for i = 1:nu
    ut = dt*fft(u(i,:),Nfft);
    for k = 1:Nf
        U(i,:,k) = ut(k);
    end
end



% Apply frequency averaging

mf = freqAvg(f,Nband);



% Construct function output
fmax = Fs/2;
fi = find(mf <= fmax);
w = mf(fi).*2*pi;
U=U(:,:,fi)./T;
end

function out = freqAvg(in,nrbands)
%FREQAVG Frequency averaging
%  out=freqAvg(in,nrbands) averages the input 'in' over the number of
%  frequency bands 'nrbands'.

N      = length(in);
Nmod   = floor((N/nrbands));   % number of remaining frequencies after averaging
tmp    = zeros(nrbands,Nmod);  % initialization of temporary matrix for averaging: nrband rows and nmod columns
tmp(:) = in(1:nrbands*Nmod);   % arrange the samples of 'in' in the elements of tmp.
out    = mean(tmp,1)';         % average over columns and make it a vector
end
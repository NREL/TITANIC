function [F,SmoothData, Hpsd] = GPP_PSD(Fs,X, GPP_detrend, windowType, cosTaper)
%[F,SmoothData, Hpsd] = GPP_PSD(Fs,X, GPP_detrend, windowType)
% test gpp/matlab psds
%----------------------------------
% F and SmoothData are the filtered results (frequency and PSD, respectively)
% Hpsd is a data structure containing the (non-smoothed) results of the PSD
%
%INPUTS:
%-------------
% Fs is the sampling frequency (i.e. 1/(time step)) of the time series
% X is the time series for which you want to find the PSD
% GPP_detrend is a true/false switch; if true, it will remove a linear
%             trend from the data; otherwise it removes the mean
% %windowType is the name of the window to use.  'log' uses 'rectwin', but
%             logarithmically smooths the data at the end.  all other
%             window types use the specified window and a smoothing filter
%             afterwards.
% fGPP is the (optional) frequency column from GPP
% SGPP is the (optional) PSD column from GPP
%---------------------------------

%window types, to correspond with GPP
% 'bartlett' or 'triang'    %Triangular window (these are only the same for L odd?)
% 'hamming'                 %Cosine/Hamming window
% 'rectwin'                 %Rectangular window (i.e. no window)
% 'rectwin'                 %log (no window, just smooth the resulting data)
% 'rectwin'                 %band smoothing


% FROM GPP USER'S GUIDE:
% The PSD Tool removes the means from each time series before generating the PSDs. It also tapers the
% ends of the data with a cosine rolloff and zero-fills the rest of the array that holds the data. You have the
% option to detrend the data with a straight line, which Numerical Recipes (Press et al. 1990) recommends.

    windowSize   = 25;
    if nargin < 3, GPP_detrend  = true; end
    if nargin < 4
        LogSmoothing = true; 
    else
        if strcmpi(windowType,'log')
            LogSmoothing = true;
        else
            LogSmoothing = false;
        end
    end
    if nargin < 5, cosTaper = true; end
    
    debug        = false;

    nfft        = length(X); 
   
    if debug, figure; plot(X,'k-'), end;
    
        % detrend signal
    if GPP_detrend
        X       = detrend(X);        % remove linear trend
    else            
        X       = X - mean(X);       % remove mean only
    end

    if debug, hold on; plot(X,'k:'), end;

    if cosTaper
            % taper the ends with cosine taper
        nTap        = round(.05*nfft); % taper first and last 5% of the records
        tapIX       = 1:nTap;
        taper       = 0.5*(1-cos(tapIX*pi/nTap));
        taper       = [taper fliplr(taper)];               %the taper, bringing the signal to zero at the endpoints
        tapIX       = round( [tapIX tapIX+(nfft-nTap)] );  %the indicies to taper
        X(tapIX)    = X(tapIX).*taper(:);   
    end
    
    if debug, plot(X,'bx'), end;
    
%bjj Start  
    %GPP has some restrictions on what nfft can be: 
    % it must be reducible to prime factors no larger than 5    
    %Find (and add) the number of zeros that must be added
    % to X to meet this restriction
    pp          = factor(nfft);
    nadded      = 0;
    while any(pp > 5)
        nfft   = nfft+1;
        nadded = nadded + 1;
        pp     = factor(nfft);
    end
    X = [X(:); zeros(nadded,1)];
    
    if debug, plot(X,'bo'); legend('original','detrend','cosine taper','zeros added'), end;
    
%bjj End    
    
    
        % set up a spectrum object, specifying the window for PSD
    if LogSmoothing || strcmpi(windowType,'rectwin')|| strcmpi(windowType,'none')
        Hs      = spectrum.periodogram; %default values (no window)
    else
%         Hs      = spectrum.periodogram({'bartlett',windowSize});  %Triangular window
        Hs      = spectrum.periodogram({windowType,windowSize});    %Triangular window
    end
    Hs_opts     = psdopts(Hs);
    set(Hs_opts, 'Fs',Fs, 'SpectrumType','onesided', 'NFFT',nfft );
        
    
        % get PSD
    Hpsd       = psd(Hs,X,Hs_opts); %the psd method of a spectrum object
%   Hpsd       = psd(Hs,X,'Fs',Fs, 'SpectrumType','onesided','NFFT',nfft);      

            % filter the raw spectra        
    if LogSmoothing
        [SmoothData, F] = OctaveSmoothing(Hpsd);
    else
            % set up running-average filter(2)s
        HwindowSize = floor(windowSize/2); %half of the window size
        filt1       = ones(1,HwindowSize)/HwindowSize;

        % The filter here is not the same one that's implemented in GPP,
        % nor do I necessarially recommend it for general use.
        % It needs to be replaced with a running average w/o phase shift.
        SmoothData = filtfilt(filt1,1,Hpsd.Data); % 2-pass running-average filter w/ no phase shift; I'm sure there is a better function for this       
%         SmoothData = filter(filt1,1,Hpsd.Data); % This creates a running with a phase shift       
        
        F          = Hpsd.Frequencies;
    end
    
%     if nargin > 3
%         figure;
%         loglog(F, SmoothData, fGPP,SGPP); legend('Matlab','GPP');
%     end

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bjj: This function altered 7/29/2009 due to inconsistancy with frequencies 
%before and after smoothing;  the variable fr was added to replace the f
%output and IBand was replaced with the actual function from GPP
function [y, fr, f] = OctaveSmoothing(Hpsd)  
%rm    IBand  = @(x)round(10*log10(x));
    
    df     = Hpsd.Frequencies(2); %Frequencies(1) = 0
    
    LoBand = IBand(df);
    HiBand = IBand(Hpsd.Frequencies(end));
    NBands = HiBand - LoBand + 1;
    
        % create zero-filled arrays
    y      = zeros(NBands,1);
    cnt    = y;
    fr     = y;
    
        % sum into individual bands
    for iFreq = 2:length(Hpsd.Frequencies)
        JBand      = IBand(Hpsd.Frequencies(iFreq)) - LoBand + 1;  
        cnt(JBand) = cnt(JBand) + 1;
        y(  JBand) = y(  JBand) + Hpsd.Data(iFreq);
        fr( JBand) = fr( JBand) + Hpsd.Frequencies(iFreq);        
    end
    Indx    = cnt > 0;        
    y( Indx) = y( Indx) ./ cnt(Indx);
    fr(Indx) = fr(Indx) ./ cnt(Indx);   % the frequencies are averaged just like the spectral amplitudes
    
    if HiBand == IBand( df + Hpsd.Frequencies(end) )  %this band isn't full so we'll discard it. 
        NBands = NBands - 1;
        y = y(1:NBands);
        Indx = Indx(1:NBands);  %added to 
    end
    f = 10.^(0.1*( LoBand+(0:NBands-1)))';  %Center frequency for each band  %BJJ: this seems to be incorrect... look at it later.
    
        % remove the empty bands
    y = y(Indx);
    f = f(Indx);
    fr=fr(Indx);
    
return;
% function [y, fr, f] = OctaveSmoothing(freq,S) 
% %this function assumes f is monotonically increasing
% %
% %     IBand  = @(x)round(10*log10(x));
%     
%     df     = freq(1); % mean(diff(freq));
%     
%     LoBand = IBand(df);
%     HiBand = IBand(freq(end));
%     NBands = HiBand - LoBand + 1;
%     
%         % create zero-filled arrays
%     y      = zeros(NBands,1);
%     fr     = y;
%     cnt    = y;
%     
%         % sum into individual bands
%     for iFreq = 1:length(freq) %was 2???
%         JBand      = IBand(freq(iFreq)) - LoBand + 1;  
%         cnt(JBand) = cnt(JBand) + 1;
%         y(  JBand) = y(  JBand) + S(iFreq);   %average the frequencies in the band
%         fr( JBand) = fr( JBand) + freq(iFreq);
%     end
%     Indx    = cnt > 0;        
%     y(Indx) = y(Indx) ./ cnt(Indx);
%     fr(Indx)=fr(Indx) ./ cnt(Indx);
%     
%     if HiBand == IBand( df + freq(end) )  %this band isn't full so we'll discard it. 
%         NBands = NBands - 1;
%         y = y(1:NBands);
%         Indx = Indx(1:NBands);  %added to 
%     end
%     f = 10.^(0.1*( LoBand+(0:NBands-1)))';  %Center frequency for each band   ?? bjj: CENTER??? really???
%     
%         % remove the empty bands
%     y = y(Indx);
%     f = f(Indx);
%     fr=fr(Indx);
%     
% return;
function [y] = IBand(x)

    y = 10*log10(x) - 0.5;
    if y >= 0
        yI = int8(y + 1.0);
    else
        yI = int8(y);
    end
    
    y = double(yI);
    
return;
function [ ls, iac, zcl, zct, lsz, iacz, L_kaim, time_kaim, L_peakK, t_peakK ] = IntegralLengthScales(x,mws,dt)
%function [ ls, iac, zcl, zct, lsz, iacz  ] = IntegralLengthScales(x,mws,dt)
%Inputs: 
%  x        a vector or 2-D matrix containing the time series signal 
%           for which the length scale is calculated. If a matrix, 
%           lengths are calculated for each column.
%  mws      mean wind speed, used to calculate lengths
%           if x is a matrix, multiple wind speeds (one for each column)
%           may be supplied; otherwise the same wind speed is used for each
%           column.
%  dt       the mean delta time for the time series.  like mws, a time
%           delta may be supplied for each column of matrix x.  (units
%           must correspond to units of mws)
%Outputs
%  ls       the integral length scale, integrated over [0, inf), one for each column of x
%  iac      the correlation times (integrated autocorrelation time over [0, inf) ),
%           one for each column of x (iac = ls/mws)
%  zcl      the zero-crossing or characteristic distance, one for each
%           column of x
%  zct      the zero-crossing or characteristic time, one for each column
%           of x (zct = zcl/mws)
%  lsz      the integral length scale, integrated over [0, zct], one for each column of x
%  iacz     the correlation times (integrated autocorrelation time over [0, zct]),
%           one for each column of x (iacz = lsz/mws)
%  L_kaim   the integral length scale, assuming the data fits the Kaimal
%           spectral shape
%  time_kaim  the corresponding time scale for the Kaimal spectral shape.
%  L_peakK  the length associated with the peak of the spectrum: f*S(f),
%           divided by 4, assuming the same relationship between the Kaimal
%           spectral peak and the length scale.
%  t_peakK  the time associated with L_peakK

[nr,nc] = size(x);
if nr == 1  %flip the matrix
    x  = x';
%     nr = nc;
    nc = 1;
end

if length(mws) == 1
    mws = repmat(mws,1,nc);
end
if length(dt) == 1
    dt = repmat(dt,1,nc);
end

ls  = zeros(nc,1);
lsz = zeros(nc,1);
iac = zeros(nc,1);
iacz= zeros(nc,1);
zcl = zeros(nc,1);
zct = zeros(nc,1);
if nargout > 6
    L_kaim  = zeros(nc,1);
    time_kaim = zeros(nc,1);
    L_peakK = zeros(nc,1);
    t_peakK = zeros(nc,1);
end

% maxlags = 2^( fix( log(nr)/log(2) ) -1); %this will correspond to Neil's Fortran program

% figure;
for ic = 1:size(x,2)  %go through the columns

        % get auto correlation, normalized so that the value at zero lag =
        % 1.0, assuming zero-mean.  In general, normalize by the variance
%bjj edit 1/2008     [ac, lags] = xcorr(x(:,ic),'coeff');   %this assumes zero mean     
    [ac, lags] = xcorr(x(:,ic),'biased');
    normalize = var(x(:,ic),1);
    ac = ac./normalize;
%bjj end edit 1/2008    
    
% plot(lags*dt(ic),ac,'b');hold on;
        %integrate over domain [0, inf)
    Pos     = lags>=0;                                          % this is the non-negative domain
    iac(ic) = dt(ic)*integrate( lags(Pos)', ac(Pos) );          % integrated auto correlation: time

        % find the time where the auto-correlation first goes negative
    tmp     = min( lags( (Pos(:) & ac<=0) ) );   % zero crossing time
    if isempty(tmp), tmp = inf; end;    
    
        % integrate over domain [0, zc];
    zct(ic) = dt(ic)*tmp;    
    Zc      = Pos & lags <= tmp;
    iacz(ic)= dt(ic)*abs( integrate( lags(Zc)', ac(Zc) ));
        
        %multiply by mean wind speed to get length
    ls( ic) = mws(ic)*iac( ic);                                 % integral length scale
    lsz(ic) = mws(ic)*iacz(ic);                                 % integrated zero-crossing length scale
    zcl(ic) = mws(ic)*zct( ic);                                 % zero-crossing length        
    
    
    %%%%%%%%%%
    if nargout > 6
            % calculate a logarithmic spectra
        [f, ps] = GPP_PSD(1/dt(ic),x(:,ic));                

            % Fit the spectra to a Kaimal Neutral spectral shape to find
            % length scale
        SubSet2    = find( ps > 0  );            
        SubSet     = SubSet2(2:end);
        Kaimal     = @(L) std(x(:,ic))^2 * (4*L/mws(ic)) ./ ((1 + 6*f(SubSet)*L/mws(ic)).^(5/3));                     
%bjj         Kaimal_Err = @(L) log( ps(SubSet) ) - log( Kaimal(L) );
        Kaimal_Err = @(L) log( f(SubSet).*ps(SubSet) ) - log( f(SubSet).*Kaimal(L) );

            % use line-search method to find best value for L in the equation
        StartVals = [1 10 50 100 300];
        Ltmp = zeros(size(StartVals));
        Lerr = Ltmp;
        for iStart = 1:5
            [Ltmp(iStart), y, ErrVal] = quasi_newton_NonSquare(Kaimal_Err,...
                                                      StartVals(iStart),0,0,150,10^-3);
            Lerr(iStart) = norm( Kaimal_Err(Ltmp(iStart)),2 );
        end
        [minErr, IX] = min(Lerr);
        L_kaim(ic) = Ltmp(IX);
        time_kaim(ic) = L_kaim(ic)/mws(ic);
       
            %smooth the spectra (S*normalize) and find the peak
            %of the individual record.
        fRange = log10([f(SubSet(1)) f(SubSet(end))]);
        fNew   = fRange(1):.01:fRange(2);  %log10 of the frequency in Hz

        fps_c  = ChebyshevSVD(log10(f(SubSet)),log10(f(SubSet).*ps(SubSet)),[2 4], fRange(1),fRange(2));
        fps_sm = getChebyshevValues(fNew,fps_c, fRange(1),fRange(2));             

        fps_sm = 10.^fps_sm;
        [mx, ix] = max(fps_sm);

            %get peak f and output 
        t_peakK(ic) = (1/(10.^fNew(ix)))/4;  %divide by 4 to get integral time scale
        L_peakK(ic) = mws(ic) * t_peakK(ic);
        
%         figure; 
%         loglog( f,f.*ps,'b+-',10.^fNew,fps_sm,'g-', ...
%                 f(SubSet),f(SubSet).*Kaimal(L_kaim( ic)),'k^-',...
%                 f(SubSet),f(SubSet).*Kaimal(L_peakK(ic)),'rs-');
%         legend('orig data','Cheby fit','Kaimal fit','spectral peak');
%         [f(SubSet(1)) f(SubSet(end))]
    end %nargout
    
end
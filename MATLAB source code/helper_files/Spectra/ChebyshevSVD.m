function [coeffs, newY, otherVars] = ChebyshevSVD(x,y,m,minX,maxX)
% m is the number of coefficients, it can be a range

x = x(:);
y = y(:);

%----------------------
n = length(x);
if length(y) ~= n
    error('Vectors x and y in the call to ChebyshevSVD() must be the same length.');
% elseif m <=0 
%     error('m must be positive in the call to ChebyshevSVD()');    
end

% throw out non-sensical data
nf_msk = isfinite(x) & isfinite(y);
x      = x(nf_msk);
y      = y(nf_msk);

n      = length(x);
%----------------------

if nargin < 5
    minX = min(x);
    maxX = max(x);    

    if nargin <= 2
        m = 0;
    end       
end


if length(m) == 1
    m = [m; m];
end

if m(1) <=0
    m(1) = 3;  %there must be at least 3 coeffs
end
if m(2) <= 0
    m(2) = min(8,n-1);
end    
    
m_max = min(n,max(m));
m_min = min(n,min(m));

minX = min(minX,min(x));
maxX = max(maxX,max(x));


Fstat_max = -inf;

x_hat = (2.0*x - maxX - minX)/(maxX - minX);

A = ones(n,m_min);
if m_min>1
    A(:,2) = x_hat;
    for i=3:m_min
        A(:,i) = 2*x_hat.*A(:,i-1) - A(:,i-2);
    end
end

for m=m_min:m_max

    if m==2
        A(:,m) = x_hat;
    else
        if m > 2
            A(:,m) = 2*x_hat.*A(:,m-1) - A(:,m-2);
        end
    end
    
    coeffs = A\y;
    newY   = A * coeffs;

    % statistics

    SSE    = sum( (newY-y).^2 );
    SSM    = sum( (y-mean(y)).^2 );
    if SSM ~= 0
        r2     = 1 - SSE/SSM;
    else
        r2     = 1;
    end
    DOF    = n-m;
    if DOF ~= 0
        MSE    = SSE/DOF;
    else
        MSE    = 0;
    end
    RMS    = sqrt(MSE);
    MSR    = (SSM-SSE)/(m-1);
    if MSE ~= 0
        Fstat  = MSR/MSE;
    else
        Fstat  = inf;
    end
    
    if Fstat > Fstat_max
        Fstat_max = Fstat;
        coeff_max = coeffs;
        newY_max  = newY;
        m_size    = m;
    end    
end

if exist('coeff_max', 'var')
    coeffs = coeff_max;
    newY   = newY_max;
end

otherVars = [r2, RMS, m_size];

return;
    
    
    
   


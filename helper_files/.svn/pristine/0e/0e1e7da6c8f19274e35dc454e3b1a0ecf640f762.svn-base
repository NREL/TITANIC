function [y] = getChebyshevValues(x,coeffs,minX,maxX)

if nargin < 4
    minX = min(x);
    maxX = max(x);
end

m     = length(x);
n     = length(coeffs);
A     = ones(m,n);
x_hat = (2.0*x(:) - maxX - minX)/(maxX - minX);

if n>1
    A(:,2) = x_hat;
    for i=3:n
        A(:,i) = 2*x_hat.*A(:,i-1) - A(:,i-2);
    end
end

y   = A * coeffs;

return;
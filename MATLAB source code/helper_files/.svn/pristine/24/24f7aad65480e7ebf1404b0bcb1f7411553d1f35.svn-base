function [y] = integrate(x,f)

    if any( size(x) ~= size(f) )
        error('Vectors in integrate(x,f) must be the same size')
    end

        % works for non-uniformally spaced x
    y  = sum( diff(x) .* 0.5 .* ( f(2:end) + f(1:(end-1)) ) );
end
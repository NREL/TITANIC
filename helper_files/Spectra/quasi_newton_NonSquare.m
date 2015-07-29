function [root, y, ErrVal] = quasi_newton_NonSquare(funname,xold,info,newton,maxnewt,TOL,alpha,rho)
% Help for quasi_newton.m
% Programmer:   Bonnie Jonkman
% Date:         6 November 2000
% Last Update:  30 July 2007
%
% PURPOSE       This code has been designed to implement the quasi-Newton algorithm 
%               that was developed in M651.
%
% REQUIRED INPUTS
%  funname:    the function name( variable x )
%  xold:       the initial guess
%
% OPTIONAL INPUTS
%  info:       indicates whether or not to display info
%  newton:     indicates whether the program should use a pure Newton iteration or 
%              a global line search. newton = 1 means use a pure Newton iteration.
%              newton <> 1 means use a global line search. Default is 0.
%  maxnewt:    the maximum number of Newton iterations. Default is 25.
%  TOL:        the tolerance for stopping criteria. Default is 10^-14.
%  alpha:      parameter determining required amount of decrease in function value.
%              Default is 10^-4.
%  rho:        amount by which step length decreases in line search. Default is 0.5.

% first determine which optional inputs have been specified
num_args = nargin;
ErrVal = false;

if (or(num_args > 8,num_args < 2))
   error('Incorrect number of input arguments in quasi_newton()!')
elseif num_args == 2
   info = 0;
   newton = 0;
   maxnewt = 25;
   TOL = 10^-15;
   alpha = 10^-4;
   rho = .5;
elseif num_args == 3
   newton = 0;
   maxnewt = 25;
   TOL = 10^-15;
   alpha = 10^-4;
   rho = .5;
elseif num_args == 4
   maxnewt = 25;
   TOL = 10^-15;
   alpha = 10^-4;
   rho = .5;
elseif num_args == 5
   TOL = 10^-15;
   alpha = 10^-4;
   rho = .5;
elseif num_args == 6
   alpha = 10^-4;
   rho = .5;
elseif num_args == 7
   rho = .5;
end


if info ~= 0
   info = 1;
end

root = NaN;
% fmt  = '%20.15f ';
fmt  = '%10.5g ';

if isa(funname,'function_handle')
    f = funname;                   
    funname = func2str(f);   
else
    f = inline(funname,'x');        % use the function whose name was input as a string
end

n      = length(xold);              % determine the length of the input vector
xnew   = xold;                      % initialize xnew
y      = zeros(2,n);

fold   = f(xold);                   % calculate the function value at the initial iterate
fscale = max( ones(size(fold)) , abs(fold) );   % begin computing scale for function values

m      = length(fold);
Jf     = zeros(m,n);                % initialize the approximate Jacobian


% display initial values
if info == 1
   fprintf('Quasi-Newton solver for the function %s .\n',funname)
    
   fprintf('   starting value: ( ')
   fprintf(fmt, xold')
   fprintf(')\n')
   fprintf('   norm of starting function value: %8.4e\n',norm(fold))
end

% quasi-Newton iteration
for newtstep = 1:maxnewt
   if info == 1
      fprintf(' Newton Step %g\n',newtstep)
   end
   
   y(newtstep,:) = xold';
   
   % compute approximate Jacobian
   for j = 1:n
      xnew = xold;
      h = sqrt(eps) * max( abs(xnew(j)), 1);    % compute optimal value of h, eps is machine precision
      
      if xold(j) < 0
         h = -h;
      end
      
      xnew(j) = xold(j) - h;
      h = xnew(j) - xold(j);
      fnew = f(xnew );
      
      for i = 1:m
         Jf(i,j) = (fnew(i) - fold(i)) / h;
      end      
   end

   
   % compute Newton step
   if isfinite(Jf)
       newtdir = - pinv(Jf) * fold;
   else
       if info == 1
           fprintf('\n Stopping because the derivative is not finite.\n')
           fprintf('    approximate root: ( ')
           fprintf(fmt, root')
           fprintf(')\n')
           fprintf('    relative error estimate: %8.4e\n',norm((xold-xnew)/max(norm(xold,inf),1)))
       end
            
       root = xnew;
       return;       
   end
      
   % check to see if relative change in the Newton iterates meets stop criteria
   relchange = norm(newtdir,inf) / max( norm(xold,inf), 1 );
   if relchange < TOL
      root = xold;
      
      if info == 1
         fprintf('\n Stopping because the iterates have become close.\n')
         fprintf('    approximate root: ( ')
         fprintf(fmt, root)
         fprintf(')\n')
         fprintf('    relative error estimate: %8.4e\n',norm((xold-xnew)/max(norm(xold,inf),1)))
      end
            
      return;
   end
   
   % check if a pure Newton iteration is to be used
   if newton == 1
      % use Newton's method
      xnew = xold + newtdir;
      fnew = f(xnew );
      
      if info == 1
         fprintf('    new iterate: ( ')
         fprintf(fmt, xnew')
         fprintf(')\n')
         fprintf('    norm of new function value: %8.4e\n',norm(fnew))
      end
      
   else 
      % perform line search
   
      % compute the norm of the initial rate of decrease in the Newton direction
      initslope = norm(fold)^2;
   
      % take a full Newton step to begin
      lambda = 1;
      xnew = xold + lambda * newtdir;
      fnew = f(xnew );
      isearch = 0;
      
      if info == 1
         fprintf('    old iterate: ( ')
         fprintf(fmt, xold')
         fprintf(')\n')
         fprintf('    full step:   ( ')
         fprintf(fmt, xnew')
         fprintf(')\n')
         fprintf('        norm squared of old function value: %8.4e\n',norm(initslope))
         fprintf('        acceptance criteria               : %8.4e\n',(1-2*alpha*lambda)*initslope)    
         fprintf('        norm squared of new function value: %8.4e\n',norm(fnew)^2)
      end
            
      while norm(fnew)^2 > ((1 - 2 * alpha * lambda) * initslope)
         isearch = isearch + 1;
         lambda = lambda * rho;
         xnew = xold + lambda * newtdir;
         fnew = f(xnew );
      
         % stop if new change satisfies the stop criteria on the relative change
         if (lambda * relchange) < TOL
%             fprintf('        Stopping line search because relative change in step is too small.\n')
            break;
         end
         
      end 
      if isearch > 0 && info == 1
         fprintf('      line search step #%g: ( ',isearch)
         fprintf(fmt,xnew)
         fprintf(')\n')
         fprintf('        norm squared of new function value: %8.4e\n',norm(fnew)^2)
      end
            
   end
   
   % update function scale
   fscale = max( fscale, abs(fnew) );
   
   % compute scaled function values
   scaledf = fnew ./ fscale;
   
   % check if function values are sufficiently small
   if norm(scaledf,inf) < TOL
      y(newtstep+1,:) = xnew';
      break;
   end
   
   xold = xnew;
   fold = fnew;
end

% return root if maximum number of Newton steps was not taken
if newtstep < maxnewt
   root = xnew;
   
   if info == 1
      fprintf('\n Stopping after %g iterations because the function values have become small.\n',newtstep)
      fprintf('    approximate root: ( ')
      fprintf(fmt, root')
      fprintf(')\n')
      fprintf('    relative error estimate: %8.4e\n',norm((xold-xnew)/max(norm(xold,inf),1)))
      fprintf('    function value:   ( ')
      fprintf(fmt, fnew)
      fprintf(')\n')
      fprintf('    norm of function value:  %8.4e\n',norm(fnew))
   end
   
   return;   
else
%START BONNIE......    
   root = xnew; 
%END BONNIE.......   
   fprintf(' Iteration reached maximum number of steps allowed.\n')
   ErrVal = true;
   return;
end

   

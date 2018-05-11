  function g = sincfun(p,x)
%
% For an input vector "x" returns a sinc function centered at c = p(1) with
% b = p(2) and a = p(3).
% s = a*sinc(pi*b*(x-c))
%--------------------------------------------------------------------------

  % Buggy version
  %g = p(3) .* sinc(pi.*p(2).*(x-p(1)));
  % Supposedly correct version
  g = p(3) .* sinc(p(2).*(x-p(1)));
  return

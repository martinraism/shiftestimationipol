  function g = esincfunOriginalArticle(p,x)
%
% For an input vector "x" returns a sinc function centered at c = p(1) with
% b = p(2) and a = p(3).
% s = a*sinc(pi*b*(x-c))
%--------------------------------------------------------------------------

  % Original version vy Argyriou (buggy)
  %g = p(3) .* exp(-((p(2).*(x-p(1))).*(p(2).*(x-p(1))))).* sinc(pi.*p(2).*(x-p(1)));
  % Supposedly correct version
  bxmc = p(2) .* (x-p(1));
  bxmc2 = bxmc .* bxmc;
  g = p(3) .* exp(-bxmc2).* sinc(bxmc);
  % Article version
  %g = p(3) .* exp(-bxmc2).* sinc(x-p(1));
%
  return

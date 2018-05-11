function out=eSincFit(xx, yy)

aa=[xx(2) 1 1];

options = optimoptions('lsqcurvefit', 'Display', 'none');

out = lsqcurvefit(@esincfun,aa, xx, yy,[],[],options);

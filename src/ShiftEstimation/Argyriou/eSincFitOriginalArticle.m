function out=eSincFitOriginalArticle(xx, yy)

aa=[xx(2) 1 1];

options = optimoptions('lsqcurvefit', 'Display', 'none');

out = lsqcurvefit(@esincfunOriginalArticle,aa, xx, yy,[],[],options);

function out=SincFit(xx, yy, withContrastAndIlluminationCompensation)


options = optimoptions('lsqcurvefit', 'Display', 'none');

if (withContrastAndIlluminationCompensation)
    aa=[xx(2) 1 1];
    out = lsqcurvefit(@sincfun,aa, xx, yy,[],[],options);
else
    aa= xx(2);
    out = lsqcurvefit(@sincfunNoIlluminationAndContrast, aa, xx, yy,[],[],options);
end

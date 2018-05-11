function out=SincNoOptimFit(xx, yy)

highPeak = yy(3);
xHigh = xx(3);
if yy(1) > yy(3)
    highPeak = yy(1);
    xHigh = xx(1);
end

out = (((highPeak * xHigh + yy(2) * xx(2)) / (highPeak + yy(2))));

% dx1 = xx(2) + highPeak/(highPeak+yy(2));
% dx2 = xx(2) + highPeak/(highPeak-yy(2));
% if (xx(1) <= dx1 && dx1 <= xx(3))
%     out = dx1;
% else
%     out = dx2;
% end

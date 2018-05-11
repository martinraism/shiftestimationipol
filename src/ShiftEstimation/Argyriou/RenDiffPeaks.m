function out=RenDiffPeaks(xx, yy)
delta = 0.95;
if (yy(3)/yy(2) > delta)
    out = xx(2) + 0.5;
elseif (yy(1)/yy(2) > delta)
    out = xx(2) - 0.5;
else
    D = yy(3) - yy(1);
    out = xx(2) + D / (yy(2) + abs(D));
end

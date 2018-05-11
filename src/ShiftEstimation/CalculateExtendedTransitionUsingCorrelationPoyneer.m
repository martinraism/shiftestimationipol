function [output] = CalculateExtendedTransitionUsingCorrelationPoyneer(u, v, windowType)
    [I1w, I2w] = ApplyWindow(u,v, windowType);
    [I1w, I2w] = CleanNaNBorders(I1w, I2w);

    U = fft2(I1w);
    V = fft2(I2w);
    
    siz1 = size(u, 1); siz2 = size(u, 2);
    
    PC = fftshift(real(ifft2(conj(U) .* V)));

    [valMax, imax] = max(abs(PC(:)));
    [ypeak, xpeak] = ind2sub(size(PC), imax(1));
    if (xpeak > 1 && xpeak < size(PC,2) && ypeak > 1 && ypeak < size(PC,1))
        x_0 = xpeak + (0.5 * (PC(ypeak,xpeak-1) - PC(ypeak,xpeak+1)))/(PC(ypeak,xpeak-1) + PC(ypeak,xpeak+1) - 2*valMax);
        y_0 = ypeak + (0.5 * (PC(ypeak-1,xpeak) - PC(ypeak+1,xpeak)))/(PC(ypeak-1,xpeak) + PC(ypeak+1,xpeak) - 2*valMax);
        my = y_0 - 1; mx = x_0 - 1;
        output = (floor([siz2 siz1]/2) - [mx my])';
    else
        output = [-1;-1];
    end
end
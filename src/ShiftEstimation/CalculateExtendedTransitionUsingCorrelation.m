function [output] = CalculateExtendedTransitionUsingCorrelation(u, v)
    ccorr = xcorr2(u,v);
    [valMax, imax] = max(abs(ccorr(:)));
    [ypeak, xpeak] = ind2sub(size(ccorr), imax(1));
    %output = [(ypeak - size(v,1)) (xpeak - size(v,2))];

    % Filter the cc with the values I will use
    ccorr2 = zeros(size(ccorr));
    windowsSize = 1;
    if (xpeak > windowSize && xpeak + windowSize <= size(PC,2) && ypeak > windowSize && ypeak + windowSize <= size(PC,1))
        ccorr2((ypeak-windowsSize):(ypeak+windowsSize),(xpeak-windowsSize):(xpeak+windowsSize)) = ccorr((ypeak-windowsSize):(ypeak+windowsSize),(xpeak-windowsSize):(xpeak+windowsSize));
        ccorr2(ccorr2 < 0.5 * valMax) = 0;
        % Compute center of mass
        idxsX = repmat(-size(u,2)+1:size(u,2)-1,size(ccorr2,1),1);
        idxsY = repmat((-size(u,1)+1:size(u,1)-1)',1, size(ccorr2,2));
        deltax = sum(sum(ccorr2.*idxsX))/sum(sum(ccorr2));
        deltay = sum(sum(ccorr2.*idxsY))/sum(sum(ccorr2));
        output = [deltax; deltay];
    else
        output = [-1;-1];
    end
    
end
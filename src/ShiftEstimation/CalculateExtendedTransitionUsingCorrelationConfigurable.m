function [output] = CalculateExtendedTransitionUsingCorrelationConfigurable(u,v, freqsToUse)
    F = fftshift(fft2(u));
    G = fftshift(fft2(v));

    PS = (conj(F) .* G);
    PS = PS ./(abs(PS));
    PC = angle(PS);
    N = size(F,1);
    if (mod(N,2) == 0)
       freqsY = [-N/2:N/2-1];
    else
       freqsY = [-(N-1)/2:(N-1)/2];
    end
    N = size(F,2);
    if (mod(N,2) == 0)
       freqsX = [-N/2:N/2-1];
    else
       freqsX = [-(N-1)/2:(N-1)/2];
    end
    %Mask out spectral compnents that lie outside a radius of R from the
    %central peak.
    freqsX = repmat(freqsX, size(u,1),1);
    freqsY = repmat(freqsY', 1, size(u,2));
    freqsToKeep = false(size(PC));
    for i=1:size(freqsToUse,1)
        freqToUse = freqsToUse(i,:);
        fx = find(freqsX==freqToUse(1));
        fy = find(freqsY==freqToUse(2));
        fs = intersect(fx,fy);
        freqsToKeep(ind2sub(size(freqsToKeep),fs)) = true;
    end

    freqsXToUse = freqsX(freqsToKeep);
    freqsYToUse = freqsY(freqsToKeep);
    bToUse = PC(freqsToKeep);
    A = [freqsXToUse freqsYToUse];
    output = ((A'*A)\(A'*bToUse)) * size(u,1) / (2*pi);
end
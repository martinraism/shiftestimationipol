function [output] = CalculateTransitionBetweenFramesStone(I1, I2, windowType)
if (strcmp(windowType,'extend'))
    [h, w] = size(I1);
    I1w = zeros(2*h-1, 2*w-1);
    I1w(1:h,1:w) = I1;
    I2w = zeros(2*h-1, 2*w-1);
    I2w(1:h,1:w) = I2;
else
    [I1w, I2w] = ApplyWindow(I1,I2,windowType);
end
[I1w,I2w] = CleanNaNBorders(I1w, I2w);

F = fftshift(fft2(I1w));
G = fftshift(fft2(I2w));

PS = G./F;
%PS = (conj(F) .* G);
%PS = PS ./(abs(PS));


R = 0.6 * min(size(F,1),size(F,2))/2;
N = size(I1w,1);
if (mod(N,2) == 0)
    freqsY = [-N/2:N/2-1];
else
    freqsY = [-(N-1)/2:(N-1)/2];
end
N = size(I1w,2);
if (mod(N,2) == 0)
    freqsX = [-N/2:N/2-1];
else
    freqsX = [-(N-1)/2:(N-1)/2];
end
% Mask out spectral compnents that lie outside a radius of R from the
% central peak.
freqsX = repmat(freqsX, size(I1w,1),1);
freqsY = repmat(freqsY', 1, size(I1w,2));
%freqsX = repmat(freqs,N,1);
%freqsY = repmat(freqs',1,N);
radius = sqrt(freqsX.^2 + freqsY.^2);
b = angle(PS);
freqsToSkip = false(size(b));
freqsToSkip(radius > floor(R)) = true;
magnitudesF = abs(F);
magnitudesG = abs(G);

%     [sorted, Idxs] = sort(magnitudesF(~freqsToSkip),'descend');
%     range = max(sorted) - min(sorted);
%     amountOfTests = 50;
%     step = range / amountOfTests;
%     for i=2:amountOfTests
%         valToTest = (i-1)*step + min(sorted);
%         freqsSkip = (magnitudesF < valToTest);
%         freqsSkip = freqsSkip | freqsToSkip;
%         freqsToKeep = ~freqsSkip;
%         freqsXToUse = freqsX(freqsToKeep);
%         freqsYToUse = freqsY(freqsToKeep);
%         bToUse = b(freqsToKeep);
%         A = [freqsXToUse freqsYToUse];
%         output = ((A'*A)\(A'*bToUse)) * size(I1w,1) / (2*pi)        
%     end

    pct95 = prctile(magnitudesF(~freqsToSkip), 60);
    freqsSkip = freqsToSkip;
    freqsSkip(magnitudesF < pct95) = true;
    pct95 = prctile(magnitudesG(~freqsSkip), 60);
    freqsSkip(magnitudesG < pct95) = true;
    freqsToKeep = ~freqsSkip;
    freqsXToUse = freqsX(freqsToKeep);
    freqsYToUse = freqsY(freqsToKeep);
    bToUse = b(freqsToKeep);
    A = [freqsXToUse/size(I1w,2) freqsYToUse/size(I1w,1)];
    output = ((A'*A)\(A'*bToUse)) / (2*pi);



siz1 = size(I1, 1); siz2 = size(I1, 2);
if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
    output = [-1;-1];
end


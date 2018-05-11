function [output] = CalculateTransitionBetweenFramesStone2(I1, I2, windowType)

if (strcmp(windowType,'extend'))
    [h, w] = size(I1);
    I1w = zeros(2*h-1, 2*w-1);
    I1w(1:h,1:w) = I1;
    I2w = zeros(2*h-1, 2*w-1);
    I2w(1:h,1:w) = I2;
else
    [I1w, I2w] = ApplyWindow(I1,I2,windowType);
end
%[I1w, I2w] = ApplyWindow(I1,I2, windowType);
[I1w, I2w] = CleanNaNBorders(I1w, I2w);

[h, w] = size(I1w);
F = fftshift(fft(fft(I1w, 1*h).', 1*w).');
G = fftshift(fft(fft(I2w, 1*h).', 1*w).');

% F = fftshift(fft2(I1w));
% G = fftshift(fft2(I2w));

%R = 0.6 * min(size(F,1),size(F,2))/2;
%PS = G./F;
PS = (conj(F) .* G);
PS = PS ./(abs(PS));

% [h, w] = size(I1w);
% a = fft(fft(I1w, 1*h).', 1*w).';
% b = fft(fft(I2w, 1*h).', 1*w).';
% s = abs( a .* conj(b) ); s( s == 0 ) = 1;
% c = (a .* conj(b)) ./ s;
% PS = fftshift(c);



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
%radius = sqrt(freqsX.^2 + freqsY.^2);
b = angle(PS);
magnitudesPS = abs(F);
%mags = unique(magnitudesPS(:));
%mags = sort(mags, 'ascend');
%err = zeros(length(mags),1);
%err95 = -1;
%prct95 = prctile(mags, 95);
%for i=1:length(mags)
    %th = mags(i);
    th = prctile(magnitudesPS(:), 95);
    freqsToSkip = false(size(b));
    freqsToSkip(magnitudesPS < th) = true;
    freqsToKeep = ~freqsToSkip;
    freqsXToUse = freqsX(freqsToKeep);
    freqsYToUse = freqsY(freqsToKeep);
    bToUse = b(freqsToKeep);
%     A = [freqsXToUse freqsYToUse];
%     output = ((A'*A)\(A'*bToUse)) * size(I1w,1) / (2*pi);
    A = [freqsXToUse/size(I1w,2) freqsYToUse/size(I1w,1)];
    output = ((A'*A)\(A'*bToUse)) / (2*pi);
    
%[minVal, posMin] = min(err);
%fprintf('minErr: %f, prctile95Err: %f, posMin: %d, percent: %f\n', minVal, err95, posMin, posMin/length(mags));


%%th = prctile(magnitudesPS(:), 95);
%%freqsToSkip(magnitudesPS < th) = true;
%%%freqsToSkip(radius > floor(R)) = true;
%%%magnitudesG = abs(G);
%%%magnitudesF = abs(F);
%%%[freqsF] = sort(magnitudesF(:),'descend');
%%%    alpha = freqsF(K);
%%freqsSkip = freqsToSkip;
%%%   freqsSkip(magnitudesF < alpha) = true;
%%%   freqsSkip(magnitudesG < alpha) = true;
%%freqsToKeep = ~freqsSkip;
%%freqsXToUse = freqsX(freqsToKeep);
%%freqsYToUse = freqsY(freqsToKeep);
%%bToUse = b(freqsToKeep);
%%A = [freqsXToUse freqsYToUse];
%%output = ((A'*A)\(A'*bToUse)) * size(I1,1) / (2*pi);
siz1 = size(I1, 1); siz2 = size(I1, 2);
if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
    output = [-1;-1];
end

end
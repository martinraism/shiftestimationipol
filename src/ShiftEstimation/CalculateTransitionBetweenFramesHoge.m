function [output] = CalculateTransitionBetweenFramesHoge(I1, I2, windowType)
displayFigures = false;
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

PS = (conj(F) .* G);
PS = PS ./(abs(PS));

% PDM = angle(PS);

% Version 1: Faster
[U,~,V] = svds(PS,1);
% Version 2: Slower, but more compatible
% [U2, ~, V2] = svd(PS);
% U = U2(:,1);
% V = V2(:,1);
% PDM2 = angle(U * S * V');
N = length(V);
r = 0:N-1;
R = [r' ones(N,1)];
% Compute the frequencies to use
% Horiz dimension
if (mod(N,2) == 0)
    freqs = [-N/2:N/2-1];
else
    freqs = [-(N-1)/2:(N-1)/2];
end

ro = 0.6*(N/2);
freqsToUse = true(length(freqs),1);
freqsToUse(abs(freqs) > ro) = false;
ri = 2;
freqsToUse(abs(freqs) < ri) = false;

v = unwrap(angle(V));
if(displayFigures)
    figure;
    p = plot(v, 'LineWidth', 2);
    title('Unwrapped phase of right dominant singular vector');
end
% res = (R'*R)\R'*v;
% output(1) = -res(1)*size(I1w,1)/(2*pi);

R2 = R(freqsToUse,:);
v2 = v(freqsToUse);
res2 = (R2'*R2)\R2'*v2;
output(1) = -res2(1)*size(I1w,2)/(2*pi);

% Vertical dimension
N = length(U);
r = 0:N-1;
R = [r' ones(N,1)];
if (mod(N,2) == 0)
    freqs = [-N/2:N/2-1];
else
    freqs = [-(N-1)/2:(N-1)/2];
end

ro = 0.6*(N/2);
freqsToUse = true(length(freqs),1);
freqsToUse(abs(freqs) > ro) = false;
ri = 2;
freqsToUse(abs(freqs) < ri) = false;

v = unwrap(angle(U));
% res = (R'*R)\R'*v;
% output(2) = res(1)*size(I1w,2)/(2*pi);
if(displayFigures)
    figure;
    plot(v, 'LineWidth', 2);
    title('Unwrapped phase of left dominant singular vector');
end

R2 = R(freqsToUse,:);
v2 = v(freqsToUse);
res2 = (R2'*R2)\R2'*v2;
output(2) = res2(1)*size(I1w,1)/(2*pi);

%fprintf('(%f,%f)\n', -output(2), -output(1));

siz1 = size(I1, 1); siz2 = size(I1, 2);
if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
    output = [-1;-1];
end


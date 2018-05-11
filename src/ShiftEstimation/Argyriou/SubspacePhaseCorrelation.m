function x0Est = SubspacePhaseCorrelation(I1, I2, window)

siz1 = size(I1, 1); siz2 = size(I1, 2);
%%%%%%%%% Compute PC
if (strcmp(window,'extend'))
    [h, w] = size(I1);
    I1w = zeros(2*h-1, 2*w-1);
    I1w(1:h,1:w) = I1;
    I2w = zeros(2*h-1, 2*w-1);
    I2w(1:h,1:w) = I2;
    siz1 = size(I1w, 1);
    siz2 = size(I1w, 2);

else
    [I1w, I2w] = ApplyWindow(I1,I2,window);
end
if (strcmp(window,'none'))
    [I1w, I2w] = ApplyWindow(I1,I2,'blackman');
end

% Compute the projections
I1x = sum(I1w,1);
I1y = sum(I1w,2);
I2x = sum(I2w,1);
I2y = sum(I2w,2);

% Compute the 1D phase correlation on X direction
a = fftshift(fft(I1x, 1*siz2));
b = fftshift(fft(I2x, 1*siz2));
s = abs( a .* conj(b));  s( s == 0 ) = 1;
CPS = (a .* conj(b)) ./ s;
%pcx = real((ifft2(CPS)));
phasesX = unwrap(angle(CPS));
vx = LeastSquares1DFit(phasesX, abs(a), abs(b));

a = fftshift(fft(I1y, 1*siz1));
b = fftshift(fft(I2y, 1*siz1));
s = abs( a .* conj(b));  s( s == 0 ) = 1;
CPS = (a .* conj(b)) ./ s;
%pcy = real(ifft2(CPS));
phasesY = unwrap(angle((CPS)));
vy = LeastSquares1DFit(phasesY', abs(a), abs(b));



siz1 = size(I1, 1); siz2 = size(I1, 2);

x0Est = [vy;vx];

if (abs(x0Est(1)) > siz1/3 || abs(x0Est(2)) > siz2/3)
    x0Est = [-1;-1];
end

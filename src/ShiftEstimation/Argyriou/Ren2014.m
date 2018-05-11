function x0Est = Ren2014(I1, I2, window, fitFlag)

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
% I1d = I1 / 4096;
% I2d = I2 / 4096;
% I1x = sum(I1d,1);
% I1y = sum(I1d,2);
% I2x = sum(I2d,1);
% I2y = sum(I2d,2);

I1x = sum(I1w,1);
I1y = sum(I1w,2);
I2x = sum(I2w,1);
I2y = sum(I2w,2);
% Compute the gradients
l = length(I1x);
I1xdx(1:l-1) = I1x(2:l) - I1x(1:l-1);
I2xdx(1:l-1) = I2x(2:l) - I2x(1:l-1);

l = length(I1y);
I1ydy(1:l-1) = I1y(2:l) - I1y(1:l-1);
I2ydy(1:l-1) = I2y(2:l) - I2y(1:l-1);

% Compute the 1D phase correlation on X direction
a = fft(I1xdx);
b = fft(I2xdx);
s = abs( a .* conj(b));  s( s == 0 ) = 1;
CPS = (a .* conj(b)) ./ s;
PCS = real(ifft2(CPS));
pcx = fftshift(PCS);

a = fft(I1ydy);
b = fft(I2ydy);
s = abs( a .* conj(b));  s( s == 0 ) = 1;
CPS = (a .* conj(b)) ./ s;
PCS = real(ifft2(CPS));
pcy = fftshift(PCS);

val1 = round(7/16 * length(PCS));
val2 = round(9/16 * length(PCS));
mask = zeros(1, length(PCS));
mask(val1:val2) = 1;
pcy = pcy .* mask;
pcx = pcx .* mask;

pc = pcy' * pcx;
siz1 = size(pc, 1);
siz2 = size(pc, 2);

peak = max(max(pc));
[mx my] = find((pc) == peak);
my = my(1); mx = mx(1);
if (mx > 1 && my > 1 && mx < size(pc,2) && my < size(pc,1))
    xxY =[my-1 my my+1]; yyY=[abs(pc(mx,my-1)) abs(pc(mx,my)) abs(pc(mx,my+1))];
    xxX =[mx-1 mx mx+1]; yyX=[abs(pc(mx-1,my)) abs(pc(mx,my)) abs(pc(mx+1,my))];
    if (fitFlag==1) %sinc
        mmx=SincFit(xxX, yyX, true);
        mmy=SincFit(xxY, yyY, true);  
        %clc
    elseif (fitFlag==2) %esinc
        mmx=eSincFit(xxX, yyX);
        mmy=eSincFit(xxY, yyY);  
        %clc  
    elseif (fitFlag==3) %sinc - no optim
        mmx = SincNoOptimFit(xxX, yyX);
        mmy = SincNoOptimFit(xxY, yyY);
    elseif (fitFlag==4) %sinc - optim without contrast compensation
        mmx = SincFit(xxX, yyX, false);
        mmy = SincFit(xxY, yyY, false);
    elseif (fitFlag ==5) % esinc - original article
        mmx=eSincFitOriginalArticle(xxX, yyX);
        mmy=eSincFitOriginalArticle(xxY, yyY);          
    elseif (fitFlag == 6) % Ren Diff
        mmx = RenDiffPeaks(xxX, yyX);
        mmy = RenDiffPeaks(xxY, yyY);
    elseif (fitFlag == 7) % Gaussian
        mmx = GaussianFit(xxX, yyX);
        mmy = GaussianFit(xxY, yyY);
    elseif (fitFlag == 8) % QuadFit
        mmx = QuadFit(xxX, yyX);
        mmy = QuadFit(xxY, yyY);
    end
    my = mmy(1) - 1; mx = mmx(1) - 1;
    x0Est = (floor([siz1 siz2]/2) - [mx my]);
else
    x0Est = [-1 -1];
end
if (abs(x0Est(1)) > siz1/3 || abs(x0Est(2)) > siz2/3)
    x0Est = [-1;-1];
end

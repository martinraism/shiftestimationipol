function x0Est = PhaseCorrelation(I1, I2, window, fitFlag)

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

a = fft(fft(I1w, 1*siz1).', 1*siz2).';
b = fft(fft(I2w, 1*siz1).', 1*siz2).';
s = abs( a .* conj(b) ); s( s == 0 ) = 1;
c = (a .* conj(b)) ./ s;

pc = real(ifft2(c));
pc = fftshift(pc);
peak = max(max(pc));
[my mx] = find((pc) == peak);
my = my(1); mx = mx(1);
if (mx > 1 && my > 1 && mx < size(pc,2) && my < size(pc,1))
    center = -1 * (floor([siz1 siz2]/2) - [my-1, mx-1]);
    xxY =[center(1)-1 center(1) center(1)+1];
    xxX =[center(2)-1 center(2) center(2)+1];
%     xxY =[my-1 my my+1]; 
%     xxX =[mx-1 mx mx+1]; 
    yyY=[pc(my-1,mx) pc(my,mx) pc(my+1,mx)];
    yyX=[pc(my,mx-1) pc(my,mx) pc(my,mx+1)];

    if (fitFlag==1) %sinc
        mmx= SincFit(xxX, yyX, true);
        mmy= SincFit(xxY, yyY, true);  
        %clc
    elseif (fitFlag==2) %esinc
        mmx = eSincFit(xxX, yyX);
        mmy = eSincFit(xxY, yyY);  
        %clc  
    elseif (fitFlag==3) %sinc - no optim
        mmx = SincNoOptimFit(xxX, yyX);
        mmy = SincNoOptimFit(xxY, yyY);
    elseif (fitFlag==4) %sinc - optim without contrast compensation
        mmx = SincFit(xxX, yyX, false);
        mmy = SincFit(xxY, yyY, false);
    elseif (fitFlag ==5) % esinc - original article
        mmx = eSincFitOriginalArticle(xxX, yyX);
        mmy = eSincFitOriginalArticle(xxY, yyY);          
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
     x0Est = [-mmy(1) -mmx(1)];
%     my = mmy(1) - 1; mx = mmx(1) - 1;
%     x0Est = (floor([siz1 siz2]/2) - [my mx]);
else
    x0Est = [-1 -1];
end
if (abs(x0Est(1)) > siz1/3 || abs(x0Est(2)) > siz2/3)
    x0Est = [-1;-1];
end

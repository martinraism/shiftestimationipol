function [dis peak gc] = GC(I1, I2, par, cutOff, flag2)

[h, w] = size(I1);

% Build the input images
[bx, by] = myEdge(I1, par); gI1 = (bx + 1i*by); 
[bx, by] = myEdge(I2, par); gI2 = (bx + 1i*by); 
%%%%%%%%% Apply Tukey window
win = window2(h,w,@tukeywin, cutOff);

gI1w = win .* gI1;
gI2w = win .* gI2;
siz1 = size(gI1w, 1);
siz2 = size(gI1w, 2);
FFTgI1 = fft(fft(gI1w, 1*siz1).', 1*siz2).';
FFTgI2 = fft(fft(gI2w, 1*siz1).', 1*siz2).';

% Now compute the correlation
gc = FFTgI1.*conj(FFTgI2); 
gc = real(ifft2(gc)); 

if flag2 == 1
    i1 = abs(gI1w); i2 = abs(gI2w);
        
    FFT_i1 = fft(fft(i1, siz1).', siz2).';
    FFT_i2 = fft(fft(i2, siz1).', siz2).';
    
    cor = FFT_i1.*conj(FFT_i2); 
    cor = real(ifft2(cor));
    cor( cor == 0 ) = 1;
    gc = gc./(cor);

end

gc = fftshift(gc);

if (flag2 == 1)
    % Remove edges
    len = 5;
    gc(1:len,:) = 0; gc(:,1:len) = 0; gc(end-len+1:end,:) = 0; gc(:,end-len+1:end) = 0;
end

peak = max(max(abs(gc)));
[my, mx] = find(abs(gc) == peak);

my = my(1); mx = mx(1);

if  my < siz1-1 && mx < siz2-1 && my > 1 && mx > 1
    sx = (1/2) * ( gc(my, mx+1) - gc(my, mx-1) )/( 2*gc(my, mx) - gc(my, mx-1) - gc(my, mx+1) );  
    sy = (1/2) * ( gc(my+1, mx) - gc(my-1, mx) )/( 2*gc(my, mx) - gc(my+1, mx) - gc(my-1, mx) );
    dx = sx; dy = sy;

    my = my + dy - 1; mx = mx + dx - 1;
    dis = (floor([siz1 siz2]/2) - [my mx]);
    
else
    dis = [];
end




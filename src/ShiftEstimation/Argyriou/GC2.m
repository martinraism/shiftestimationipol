function [dis] = GC2(I1, I2, par, cutOff, normalize)

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

% FFTgI1 = fft(fft(gI1w.', siz2).', siz1).';
% FFTgI2 = fft(fft(gI2w.', siz2).', siz1).';

% Pad both images in the frequency domain and FFT invert
FFTgI1 = ifftshift(padarray(fftshift(FFTgI1),floor([siz1/2 siz2/2])));
FFTgI2 = ifftshift(padarray(fftshift(FFTgI2),floor([siz1/2 siz2/2])));

% Now compute the correlation
gc = real(ifft2(FFTgI1.*conj(FFTgI2))); 

if normalize == 1    
    i1 = abs(gI1w); i2 = abs(gI2w);
    FFT_i1 = fft(fft(i1, siz1).', siz2).';
    FFT_i2 = fft(fft(i2, siz1).', siz2).';
    FFT_i1 = ifftshift(padarray(fftshift(FFT_i1),floor([siz1/2 siz2/2])));
    FFT_i2 = ifftshift(padarray(fftshift(FFT_i2),floor([siz1/2 siz2/2])));
    
    cor = FFT_i1.*conj(FFT_i2); 
    cor = real(ifft2(cor));
    cor( cor == 0 ) = 1;
    gc = gc./(cor);

end

gc = fftshift(gc);

if (normalize == 1)
    % Remove edges (I suppose the maximum is further away than 5 pixels
    len = 5;
    gc(1:len,:) = 0; gc(:,1:len) = 0; gc(end-len+1:end,:) = 0; gc(:,end-len+1:end) = 0;
end

% if s == 's'
%     figure; imagesc(abs(gc)); colorbar; %axis equal
% end

peak = max(max(abs(gc)));
[mx, my] = find(abs(gc) == peak);

my = my(1); mx = mx(1);

if  mx < siz1*2-1 && my < siz2*2-1 && mx > 1 && my > 1
    %sy = (1/2) * ( gc(mx, my+1) - gc(mx, my-1) )/( 2*gc(mx, my) - gc(mx, my-1) - gc(mx, my+1) );  
    %sx = (1/2) * ( gc(mx+1, my) - gc(mx-1, my) )/( 2*gc(mx, my) - gc(mx+1, my) - gc(mx-1, my) );
    sy = (1/2) * ( log(gc(mx, my+1)) - log(gc(mx, my-1)) )/( 2*log(gc(mx, my)) - log(gc(mx, my-1)) - log(gc(mx, my+1)) );  
    sx = (1/2) * ( log(gc(mx+1, my)) - log(gc(mx-1, my)) )/( 2*log(gc(mx, my)) - log(gc(mx+1, my)) - log(gc(mx-1, my)) );
    dx = sx; dy = sy;

    my = my + dy - 1; mx = mx + dx - 1;
    dis = (floor([siz1 siz2]/2) - ([mx my]/2));
else
    dis = [];
end




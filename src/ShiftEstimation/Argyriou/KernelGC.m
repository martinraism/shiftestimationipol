function x0Est = KernelGC(I1, I2, par, cutOff, pInit, R, flag, flag1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% I1, I2 : input images (equal size is assumed)
%%%%%%%%% par : selects method to estimate image gradients (see myEdge)
%%%%%%%%% cutOff : Tukey's window cut-off parameter
%%%%%%%%% pInit : initial values for Levenberg-Marquardt algorithm
%%%%%%%%% flag : switches to Normalized Gradient Correlation
%%%%%%%%% flag1 : selects implementation for Normalized Gradient Correlation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% x0Est : estimated shift with subpixel accuracy


siz1 = size(I1, 1); siz2 = size(I1, 2);

%%%%%%%%% Extract image gradients
[bx, by] = myEdge(I1, par); gI1 = (bx + 1i*by); 
[bx, by] = myEdge(I2, par); gI2 = (bx + 1i*by); 
%%%%%%%%% Apply Tukey window
win = window2(siz1,siz2,@tukeywin, cutOff);

gI1 = win.*gI1; gI1w = gI1;
gI2 = win.*gI2; gI2w = gI2;

%%%%%%%%% Compute Gradient Correlation
FFT_gI1 = fft(fft(gI1w, 1*siz1).', 1*siz2).';
FFT_gI2 = fft(fft(gI2w, 1*siz1).', 1*siz2).';
cp = FFT_gI1.*conj(FFT_gI2); 
gc = real(ifft2(cp));  gc = fftshift(gc);

%%%%%%%%% Impose Rank-1
if flag == 0 
    [U,S,V] = svds(gc, 1); 
    gc = U*S*V';
end
%%%%%%%%% Compute Normalized Gradient Correlation
if flag == 1
    FFT_gI1abs = fft(fft(abs(gI1w), 1*siz1).', 1*siz2).';
    FFT_gI2abs = fft(fft(abs(gI2w), 1*siz1).', 1*siz2).';
    cp = FFT_gI1abs.*conj(FFT_gI2abs); nor = real(ifft2(cp)); nor = fftshift(nor);
    if flag1 == 0
        [U,S,V] = svds(gc, 1); 
        gc = U*S*V';
        nor( nor == 0 ) = 1;
        gc = gc./nor;
        [U,S,V] = svds(gc, 1); 
        gc = U*S*V';
    else
        [U,S,V] = svds(gc, 1); 
        gc = U*S*V';
        [U,S,V] = svds(nor, 1); 
        nor = U*S*V';
        nor( nor == 0 ) = 1;
        gc = gc./nor;
        [U,S,V] = svds(gc, 1); 
        gc = U*S*V';
    end   
    len = 5;
    gc(1:len,:) = 0; gc(:,1:len) = 0; gc(end-len+1:end,:) = 0; gc(:,end-len+1:end) = 0;    
end


%%%%%%%%%% Get pixel accuracy
peak = max(max((gc)));
[mx, my] = find((gc) == peak);
my = my(1); mx = mx(1);

%%%%%%%%%% Polynomial Fitting
if  mx < siz1-1 && my < siz2-1 && mx > 1 && my > 1
    sy = (1/2) * ( gc(mx, my+1) - gc(mx, my-1) )/( 2*gc(mx, my) - gc(mx, my-1) - gc(mx, my+1) );  
    sx = (1/2) * ( gc(mx+1, my) - gc(mx-1, my) )/( 2*gc(mx, my) - gc(mx+1, my) - gc(mx-1, my) );
else
    sy = 0;
    sx = 0;
end
%%%%%%%%%% Kernel Fitting
if  mx < siz1-(R) && my < siz2-(R) && mx > (R) && my > (R)
    U = U./sign(U(mx));
    V = V./sign(V(my));
    
    ydataU = U(mx-R:mx+R)'; ydataV = V(my-R:my+R)';
    xdata = -R:R;
    
    options = optimoptions('lsqcurvefit', 'Display', 'none');
    x0 = [pInit(1)    sx   pInit(2)  pInit(3)];
    px = lsqcurvefit(@myKernel, x0, xdata, ydataU, [],[], options);
    dx = px(2); 

    y0 = [pInit(1)    sy   pInit(2)  pInit(3)];
    py = lsqcurvefit(@myKernel, y0, xdata, ydataV,[],[], options);
    dy = py(2); 
else 
    dx = sx; dy = sy;
end


%clc
my2 = my + dy - 1; mx2 = mx + dx - 1;
x0Est = (floor([siz1 siz2]/2) - [mx2 my2]);









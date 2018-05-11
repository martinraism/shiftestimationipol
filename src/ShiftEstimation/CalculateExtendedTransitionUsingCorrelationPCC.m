function [output] = CalculateExtendedTransitionUsingCorrelationPCC(u, v, tol, maxIt)
    % Use square images of a power of 2 size    
    ny = nextpow2(size(u,1));
    nx = nextpow2(size(u,2));
    if (2^ny ~= size(u,1))
        ny = ny - 1;
    end
    if (2^nx ~= size(u,2))
        nx = nx - 1;
    end
    
    n = min(ny,nx);
    center = floor(size(u) / 2);
    sz = 2^n;
    % Extract big subimage from the center (to make the initial images
    % power of 2)
    u = u(center(1)-(sz/2)+1:center(1)+(sz/2),center(2)-(sz/2)+1:center(2)+(sz/2));
    v = v(center(1)-(sz/2)+1:center(1)+(sz/2),center(2)-(sz/2)+1:center(2)+(sz/2));
        
    % Keep a copy of the original second image (that I will resample later)
    vOrig = v;
    vOrigFourier = fft2(vOrig);
    % Put a high value for initilizing the initial diference 
    dif = 100;
    resAcum = [0;0];
    qtyIt = 0;
    while (dif > tol && qtyIt < maxIt)
        % Now extract half of the image
        sideSpace = sz/2/2;
        us = u(sideSpace+1:end-sideSpace,sideSpace+1:end-sideSpace);
        vs = v(sideSpace+1:end-sideSpace,sideSpace+1:end-sideSpace);
        output = CalculateExtendedTransitionUsingCorrelationPoyneer(us, vs, 'none');
        resAcum = resAcum + output;
        dif = sqrt(output(1)^2 + output(2)^2);
        v = FourierShift(resAcum(1), resAcum(2), vOrig,vOrigFourier);
        qtyIt = qtyIt + 1;
    end
%     if (qtyIt ~= maxIt)
%         fprintf('PCC with tol:%f finished using %d iterations.\n', tol, qtyIt);
%     end
    output = resAcum;
    siz1 = size(u, 1); siz2 = size(u, 2);
    if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
        output = [-1;-1];
    end
end

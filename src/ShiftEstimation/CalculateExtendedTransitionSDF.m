function [output] = CalculateExtendedTransitionSDF(u, v,method, interpMethod, N)
%     I1g = imgaussfilt(u, 5);
%     u = u - I1g;
%     I2g = imgaussfilt(v, 5);
%     v = v - I2g;
    if (nargin <= 4)
        N = 3;
    end
    [h,w] = size(u);
    
    mask = ones(h-2*N,w-2*N);
    mask = padarray(mask,[N N],0,'both');
    
    ccorr = zeros(2*N+1,2*N+1);
    for it = 0:((2*N+1)^2-1)
        j = mod(it,2*N+1)+1;
        i = floor(it / (2*N+1)) + 1;
        ushift = circshift(u,[(i - N - 1) (j - N - 1)]);
        maskshift = circshift(mask, [(i - N - 1) (j - N - 1)]);
        switch (method)
            case 'SDF'
                dif = maskshift .* (ushift - v);
                %ccorr(i,j) = sum(dif(:).^2);
                ccorr(it+1) = sum(dif(:).^2);
            case 'ADF'
                dif = maskshift .* (ushift - v);
                ccorr(it+1) = sum(abs(dif(:)));
            case 'ADF2'
                dif = maskshift .* (ushift - v);
                ccorr(it+1) = sum(abs(dif(:)))^2;
            case 'CFI'
                u2 = (maskshift .* ushift);
                u2 = u2 - mean(u2(:));
                v2 = (maskshift .* v);
                v2 = v2 - mean(v2(:));
                dif = maskshift .* (u2 .* v2);
                ccorr(it+1) = -1 * sum(dif(:));
        end
    end
    % xcorr2 test
%     cc = xcorr2(u,v);
%     [~, Ix] = max(cc(:));
%     [yMax,xMax] = ind2sub(size(cc), Ix);
%     corr_offset = [(yMax-size(v,1)) (xMax - size(v,2))];
    
    [~, imax] = min((ccorr(:)));
    [yp, xp] = ind2sub(size(ccorr), imax(1));
    ypeak = yp - N - 1;
    xpeak = xp - N - 1;
    if (strcmp(interpMethod, 'NI'))
        output = [-ypeak -xpeak];
    else
        if (yp > 1 && yp + 1 <= size(ccorr,1) && xp > 1 && xp + 1 <= size(ccorr,2))
            switch (interpMethod)
                case {'2QI','1QI'}
                    a2 = (ccorr(yp,xp+1) - ccorr(yp,xp-1))/2;
                    a4 = (ccorr(yp+1,xp) - ccorr(yp-1,xp))/2;
                    a3 = (ccorr(yp,xp+1) - 2*ccorr(yp,xp) + ccorr(yp,xp-1))/2;
                    a5 = (ccorr(yp+1,xp) - 2*ccorr(yp,xp) + ccorr(yp-1,xp))/2;
                    a6 = (ccorr(yp+1,xp+1) - ccorr(yp+1,xp-1) - ccorr(yp-1,xp+1) + ccorr(yp-1,xp-1))/4;
                case {'2LS','1LS'}
                    s1j = (ccorr(yp,xp+1) + ccorr(yp+1,xp+1) + ccorr(yp-1,xp+1))/3;
                    sm1j = (ccorr(yp,xp-1) + ccorr(yp+1,xp-1) + ccorr(yp-1,xp-1))/3;
                    s0j = (ccorr(yp,xp) + ccorr(yp+1,xp) + ccorr(yp-1,xp))/3;
                    si1 = (ccorr(yp+1,xp) + ccorr(yp+1,xp+1) + ccorr(yp+1,xp-1))/3;
                    sim1 = (ccorr(yp-1,xp) + ccorr(yp-1,xp+1) + ccorr(yp-1,xp-1))/3;
                    si0 = (ccorr(yp,xp) + ccorr(yp,xp+1) + ccorr(yp,xp-1))/3;
                    a2 = (s1j - sm1j)/2;
                    a4 = (si1 - sim1)/2;
                    a3 = (s1j - 2*s0j + sm1j)/2;
                    a5 = (si1 - 2*si0 + sim1)/2;
                    a6 = (ccorr(yp+1,xp+1) - ccorr(yp+1,xp-1) - ccorr(yp-1,xp+1) + ccorr(yp-1,xp-1))/4;
            end
            switch (interpMethod)
                case {'1LS','1QI'}
                    x0 = xpeak - a2/(2*a3);
                    y0 = ypeak - a4/(2*a5);
                case {'2LS','2QI'}
                    den = (a6^2 - 4*a3*a5);
                    x0 = xpeak + (2*a2*a5 - a4*a6)/den;
                    y0 = ypeak + (2*a3*a4 - a2*a6)/den;
            end
            output = [-y0 -x0];
        else
            output = [-1 -1];
        end
    end
end
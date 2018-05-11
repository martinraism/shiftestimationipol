function [output] = CalculateTransitionBetweenFramesInterpolation(I1, I2, kernelSz)
    % First look for the kernel by L2 minimization
    kernelHSz= floor(kernelSz/2);
    from = -kernelHSz;
    to = kernelHSz;
    if (mod(kernelSz,2) == 0) 
        from = from + 1;
    end
    idxCorrector = (from*kernelSz+from)*(-1) + 1;
    A = zeros(kernelSz^2,kernelSz^2);
    
    % Generate shifted images
    I1shiftedMN = cell(kernelSz, kernelSz);
    for m=from:to
        for n=from:to
            I1shiftedMN{m-from+1,n-from+1} = imshift([m n],I1);
        end
    end
    for i=from:to % For 5x5 kernel
        for j=from:to % For 5x5 kernel
            I1shiftedIJ = imshift([i j],I1);
            idxIJ = i*kernelSz+j + idxCorrector; % For 5x5 kernel
            for m=from:to % For 5x5 kernel
                for n=from:to % For 5x5 kernel
                    idxMN = m*kernelSz+n + idxCorrector; % For 5x5 kernel
%                    acum = 0;
%                    for k=1+from:size(I1,1)+to
%                        for l=1+from:size(I1,2)+to
%                            if (k+m >= 1 && k+m <= size(I1,1) && k+i >= 1 && k+i <= size(I1,1) && l+n >= 1 && l+n <= size(I1,2) && l+j >= 1 && l+j <= size(I1,2))
%                                acum = acum + I1(k+m,l+n)*I1(k+i,l+j);
%                            end
%                        end
%                    end
                    
                    %A(idxIJ, idxMN) = acum;
                    otherRes = sum(sum(I1shiftedIJ .* I1shiftedMN{m-from+1,n-from+1}));
                    A(idxIJ, idxMN) = otherRes;
                    %fprintf('pos (%d,%d): %f vs %f\n', idxIJ,idxMN, acum,otherRes);
                    %A(idxIJ, idxMN) = sum(sum(I1shiftedIJ .* I1shiftedMN{m-from+1,n-from+1}));
                end
            end
        end
    end
    b = zeros(kernelSz^2,1);
    %tic;
%    for x=1:kernelSz
%        for y=1:kernelSz
%            idx = (x-1)*kernelSz+y;
%            b(idx) = sum(sum(I2(((-1)*from+1):end-to,((-1)*from+1):end-to) .* I1(x:end-(kernelSz-x),y:end-(kernelSz-y))));
%        end
%    end
    for x=from:to
        for y=from:to
            idx = (y-from)*kernelSz+1+(x-from);
            I1t = imshift([y x],I1);
            b(idx) = sum(sum(I1t .* I2));
        end
    end
    %elapsedTime2 = toc;
    %disp(elapsedTime2);
    %b2 = b;
%    tic;
%    for i=from:to
%        for j=from:to
%            idxIJ = i*kernelSz + j + idxCorrector; 
%            acum = 0;
%            for k=((-1)*from+1):size(I1,1)-to
%               for l=((-1)*from+1):size(I1,2)-to
%                    acum = acum + I2(k,l)*I1(k+i,l+j);
%                end
%            end
%            b(idxIJ) = acum;
%        end
%    end
%    elapsedTime = toc;
%    disp(elapsedTime);
    %b2 = conv2(I2,I1, 'valid');
    %b3 = imfilter(I2,I1);
    %b4 = corr(I1,I2);
    %I1r = fliplr(flipud(I1));
    %b6 = conv2(I2,I1r,'same');
    %b7 = xcorr2(I1,I2);
    %b5 = xcorr(I1,I2, [1 1]);

    % Solve the min squares problem by inverting matrix A
    h = A\b;
    h2 = reshape(h,kernelSz,kernelSz);
    sumX = 0;
    sumY = 0;
    sumTot = 0;
    idxCorrector = -from + 1;
    for m=from:to
        for n=from:to
            sumTot = sumTot + h2(m+idxCorrector,n+idxCorrector);
            sumX = sumX + n * h2(m+idxCorrector,n+idxCorrector);
            sumY = sumY + m * h2(m+idxCorrector,n+idxCorrector);
        end
    end
    output = [sumY/sumTot; sumX/sumTot];
    output = -output;
end

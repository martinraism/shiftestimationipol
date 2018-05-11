% Apply window in the pixel domain to eliminate image-boundary
% effects in the Fourier Domain
function [I1, I2] = ApplyWindow(I1,I2,windowType)
    w = CreateWindow(I1, windowType);
    if (strcmp(windowType,'none') == false)
        I1 = I1 .* w;
    end
    w = CreateWindow(I2, windowType);
    if (strcmp(windowType,'none') == false)
        I2 = I2 .* w;
    end
    

function [w] = CreateWindow(I1, windowType)
     switch windowType
        case 'blackman'
            w = window2(size(I1,1), size(I1,2), @blackman);
        case 'blackmanHarris'
            w = window2(size(I1,1), size(I1,2), @blackmanharris);
        case 'bartlett'
            w = window2(size(I1,1), size(I1,2), @bartlett);
        case 'barthannwin'
            w = window2(size(I1,1), size(I1,2), @barthannwin);
        case 'chebwin'
            w = window2(size(I1,1), size(I1,2), @chebwin);
        case 'gausswin'
            w = window2(size(I1,1), size(I1,2), @gausswin);
        case 'hamming'
            w = window2(size(I1,1), size(I1,2), @hamming);
        case 'tukeywin'
            w = window2(size(I1,1), size(I1,2), @tukeywin);
        case 'flattop'
            w = window2(size(I1,1), size(I1,2), @flattopwin);
         otherwise
             w = [];
    end

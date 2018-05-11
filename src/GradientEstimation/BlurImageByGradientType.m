function [res] = BlurImageByGradientType(image, gradientType)
    if (strcmp(gradientType,'CENTER3'))
        res = ApplyGaussian(image, 1);
    elseif (strcmp(gradientType,'CENTER2'))
        res = ApplyGaussian(image, 0.6);
        %res = imgaussfilt(image, 0.6);
    elseif (strcmp(gradientType,'CENTER1'))
        res = ApplyGaussian(image, 0.3);
    elseif (strcmp(gradientType,'BD'))
%         p2 = conv2(p, p');
%         res = conv2(image,p2, 'same');
        p = [.5, .5];
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType, 'SIMO3'))
        p = [0.22420981526374817  0.5515803694725037  0.22420981526374817];
        res = conv2(p, p, image, 'same');
    elseif (strcmp(gradientType,'SIMO5'))
        p = [0.035697564482688904 0.24887460470199585  0.4308556616306305  0.24887460470199585 0.035697564482688904];
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType, 'FARID3'))
        p = [0.229879  0.540242  0.229879];
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType, 'FARID5'))
        p = [0.037659  0.249153  0.426375  0.249153  0.037659];
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType, 'FARID7'))
        p  = [0.004711  0.069321  0.245410  0.361117  0.245410  0.069321  0.004711];
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType,  'HASTCUBIC'))
        p = hastKernel('Cubic');
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType,  'HASTCATMULLROM'))
        p = hastKernel('Catmull-Rom');
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType,  'HASTBEZIER'))
        p = hastKernel('Bezier');
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType,  'HASTBSPLINE'))
        p = hastKernel('B-Spline');
        res = conv2(p, p, image, 'same');
    elseif(strcmp(gradientType,  'HASTTRIGONOMETRIC'))
        p = hastKernel('Trigonometric');
        res = conv2(p, p, image, 'same');
    else
        res = image;
    end
end

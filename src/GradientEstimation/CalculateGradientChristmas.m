function [ dx, dy ] = CalculateGradientChristmas( im, order )
    if order == 1
        gx = [1 0 -1];
    elseif order == 2
        gx = [-1/12 2/3 0 -2/3 1/12];
    elseif order == 3
        gx = [1/60 -3/20 3/4 0 -3/4 3/20 -1/60];
    end
    dx = conv2(im,gx,'same');
    dy = conv2(im,gx','same');
end

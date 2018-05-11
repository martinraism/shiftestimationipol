function [output] = EstimateTranslationOpticalFlow(u,v,dx,dy)
    dif = v - u;
    filterMatrix = true(size(u));
    filterMatrix(isnan(dif)) = false;
    dx = dx(filterMatrix); dy = dy(filterMatrix); dif = dif(filterMatrix);
    b = [sum(dif.*dx); sum(dif.*dy)];
    sdx2 = sum(dx.^2);
    sdy2 = sum(dy.^2);
    sdxdy = sum(dx.*dy);
    Ahat = [sdx2 sdxdy; sdxdy sdy2];
    output = -(Ahat\b);
end
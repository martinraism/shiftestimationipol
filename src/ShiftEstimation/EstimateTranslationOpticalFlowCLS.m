function [output] = EstimateTranslationOpticalFlowCLS(u,v,dx,dy, variance)
    dif = v - u;
    filterMatrix = true(size(u));
    filterMatrix(isnan(dif)) = false;
    dx = dx(filterMatrix); dy = dy(filterMatrix); dif = dif(filterMatrix);
    b = [sum(dif.*dx); sum(dif.*dy)];
    N = length(dx);
    sdx2 = sum(dx.^2) - (variance * N);
    sdy2 = sum(dy.^2) - (variance * N);
    sdxdy = sum(dx.*dy);
    Ahat = [sdx2 sdxdy; sdxdy sdy2];
    output = -(Ahat\b);

end
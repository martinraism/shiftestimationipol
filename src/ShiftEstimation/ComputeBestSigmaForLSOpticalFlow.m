function [err] = ComputeBestSigmaForLSOpticalFlow(sigma, u, v, itQty, intType, shift)
    [res] = CalculateTransitionBetweenFramesBySmoothing(u, v, itQty, intType, false, 1, sigma);
    err = [shift(1) + res(2), shift(2) + res(1)];
    %err = EvaluateError(shift, res);
end
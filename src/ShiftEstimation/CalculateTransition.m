function [output] = CalculateTransition(u, v, itQty, interpType, gradientType, useTLS, step)
% Compute gradient
[dx, dy] = CalculateGradientByType(u, gradientType);
output = CalculateTransitionBetweenFramesTLS2(u, v, dx, dy, gradientType, itQty, interpType, useTLS, step);
end
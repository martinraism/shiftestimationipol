function [dx, dy] = CalculateGradient2(im)
% Compute gradient
grad = [1 -1];
dx = conv2(im,grad,'same');
grad = [1 ; -1];
dy = conv2(im,grad,'same');

end
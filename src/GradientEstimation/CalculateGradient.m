function [dx, dy] = CalculateGradient(im)
% Compute gradient
%d = [1 -1];
d = [0.5 -0.5; 0.5 -0.5];
dx = conv2(im, d, 'same');

% d2 = [1 -1];
% p2 = [0.5 0.5];
% dx2 = conv2(p2,d2,im, 'same');
% dx3 = conv2(conv2(im, p2', 'same'),d2, 'same');

d = [0.5 0.5; -0.5 -0.5];
dy = conv2(im, d, 'same');
% dy2 = conv2(d2,p2,im, 'same');
% dy3 = conv2(conv2(im, d2', 'same'),p2, 'same');
end
% DERIVATIVE3 - 3-Tap 1st discrete derivative
%
% This function computes 1st derivative of an image using the 3-tap
% coefficients given by Farid and Simoncelli.  
%
% Usage:  [gx, gy] = derivative3(im)
%
% Arguments:
%                       im - Image to compute derivatives from.
% Returns:
%  Function returns requested derivatives which can be:
%     gx, gy   - 1st derivative in x and y
%
%  Examples:
%    [gx, gy] = derivative3(im);  

% Reference: Hany Farid and Eero Simoncelli "Differentiation of Discrete
% Multi-Dimensional Signals" IEEE Trans. Image Processing. 13(4): 496-508 (2004)

% Copyright (c) 2016 Martin Rais
% CMLA - ENS CACHAN - FRANCE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
% June 2016

function [dx, dy] = derivative3(im)
    
    % 3 tap 1st derivative cofficients.  
    p = [0.229879  0.540242  0.229879];
    d1 =[0.425287  0.000000 -0.425287];

    % Compute derivatives.  
    dx = conv2(p, d1, im, 'same');    
    dy = conv2(d1, p, im, 'same');
end

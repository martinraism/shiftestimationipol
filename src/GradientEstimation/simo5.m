% SIMO5 - 5-Tap 1st discrete derivative
%
% This function computes 1st derivative of an image using the 5-tap
% coefficients given by Simoncelli.  
%
% Usage:  [gx, gy] = simo5(im)
%
% Arguments:
%                       im - Image to compute derivatives from.
% Returns:
%  Function returns requested derivatives which can be:
%     gx, gy   - 1st derivative in x and y
%
%  Examples:
%    [gx, gy] = simo5(im);  

% Reference: Eero Simoncelli "Design of Multi-Dimensional Derivative Filters"

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

function [dx, dy] = simo5(im)
    
    % 3 tap 1st derivative cofficients.  
    p = [0.035697564482688904 0.24887460470199585  0.4308556616306305  0.24887460470199585 0.035697564482688904];
    d1 =[0.1076628714799881 0.2826710343360901  0.000000 -0.2826710343360901 -0.1076628714799881];

    % Compute derivatives.  
    dx = conv2(p, d1, im, 'same');    
    dy = conv2(d1, p, im, 'same');
end


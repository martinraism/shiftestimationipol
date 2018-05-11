% HASTKERNEL - Computes the convolution kernel for a specific spline and its
% first and second order derivaitives.
%
% Usage:
%
% [k, d, d2] = hastKernel(spline)   
%
% Arguments:  
%       spline    - type of spline, i.e. 'Cubic','Catmull-Rom','Bezier','Trigonometric'
%
% Returns:
%       k         - interpolating kernel
%       d         - differentiating kernel
%       d2        - kernel for the second derivative
%
% Copyright (c) 2013 Anders Hast
% Uppsala University
% http://www.cb.uu.se/~aht
% 
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

function [k, d, d2] = hastKernel(spline)
    if strcmp(spline,'Cubic')
        %B  = [-1,1,-1,1;0,0,0,1;1,1,1,1;8,4,2,1];
        %M  = inv(B);
        M=[-1,3,-3,1;3,-6,3,0;-2,-3,6,-1;0,6,0,0]*1/6;
        u  = [0.125;0.25;0.5;1];
        up = [0.75;1;1;0];
        upp= [3;2;0;0];
    elseif strcmp(spline,'Catmull-Rom') 
        M=[-1,3,-3,1;2,-5,4,-1;-1,0,1,0;0,2,0,0]*0.5;
        u  = [0.125;0.25;0.5;1];
        up = [0.75;1;1;0];
        upp= [3;2;0;0];
    elseif strcmp(spline,'Bezier')
        M=[1,0,0,0;-3,3,0,0;3, -6,3,0; -1,3,-3,1]';
        u  = [0.125;0.25;0.5;1];
        up = [0.75;1;1;0];
        upp= [3;2;0;0];
    elseif strcmp(spline,'B-Spline')
        M=[-1,3,-3,1;3,-6,3,0;-3,0,3,0;1,4,1,0]*1/6;
        u  = [0.125;0.25;0.5;1];
        up = [0.75;1;1;0];
        upp= [3;2;0;0];
    elseif strcmp(spline,'Trigonometric')
        M  = [1,1,0,1; 1,sqrt(3/4),0.5,0.5; 1,0.5,sqrt(3/4),-0.5; 1,0,1,-1];
        M  = inv(M);
        u  = [1;sqrt(1/2);sqrt(1/2);0];
        up = [0;-sqrt(1/2);sqrt(1/2);-2];
        upp= [0;-sqrt(1/2);-sqrt(1/2);0];
    else
        error('Spline unknown!')    
    end
        
    k  = u'*M;
    d  = up'*M;
    d2  = upp'*M;
end


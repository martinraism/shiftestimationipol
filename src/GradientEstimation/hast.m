function [ dx, dy ] = hast( im , spline )
    [k, d, ~] = hastKernel(spline);
    dy=-conv2(conv(d,k),conv(k,k),im,'same');
    dx=-conv2(conv(k,k),conv(d,k),im,'same');
end

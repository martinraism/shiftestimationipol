function [res] = pyramid(im)
a = 0.375;
kernel = [1/4 - a/2, 1/4,a,1/4,1/4-a/2];
im2 = padarray(im,[2 2], 'replicate'); 
res = conv2( kernel, kernel, im2, 'valid');
res = res(1:2:end,1:2:end);
end

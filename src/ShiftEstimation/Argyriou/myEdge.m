function [bx, by] = myEdge(I, par)

if par == 1
    gx = [-1 0 1];
elseif par == 2
    gx = [1/12 -2/3 0 2/3 -1/12];
elseif par == 3
    gx = [-1/60 3/20 -3/4 0 3/4 -3/20 1/60];
elseif par == 4
    gx = [-1 1];
elseif par == 5
    gx = [1; 2; 1]*[1 0 -1];
elseif (par == 7 || par == 8 || par == 6)
    epsilon=1e-2;
    switch par
        case 6
            sigma = 0.3;
        case 7
            sigma = 0.6;
        case 8
            sigma = 1;
    end
    halfsize=ceil(sigma*sqrt(-2*log(sqrt(2*pi)*sigma*epsilon)));
    size=2*halfsize+1;
    %generate a 2-D Gaussian kernel along x direction
    for i=1:size
        for j=1:size
            u=[i-halfsize-1 j-halfsize-1];
            hx(i,j)=gauss(u(1),sigma)*dgauss(u(2),sigma);
        end
    end
    gx=(-1)*(hx/sqrt(sum(sum(abs(hx).*abs(hx)))));
    
end
    
% bx2 = crop2(conv2(extend2(I, length(gx), length(gx)), gx, 'same'), length(gx), length(gx));     
% by2 = crop2(conv2(extend2(I, length(gx), length(gx)), gx', 'same'), length(gx), length(gx));   

% bx = imfilter(I, gx, 'replicate');
% by = imfilter(I, gx', 'replicate');

bx = conv2(I,gx,'same');
by = conv2(I,gx','same');

function y = gauss(x,sigma)
%Gaussian
y = exp(-x^2/(2*sigma^2)) / (sigma*sqrt(2*pi));

function y = dgauss(x,sigma)
%first order derivative of Gaussian
y = -x * gauss(x,sigma) / sigma^2;
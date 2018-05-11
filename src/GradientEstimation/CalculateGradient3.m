function [gx,gy, halfsize] = CalculateGradient3(im, sigma)
%  GAUSSGRADIENT Gradient using first order derivative of Gaussian.
%  [gx,gy]=gaussgradient(IM,sigma) outputs the gradient image gx and gy of
%  image IM using a 2-D Gaussian kernel. Sigma is the standard deviation of
%  this kernel along both directions.
%
%  Contributed by Guanglei Xiong (xgl99@mails.tsinghua.edu.cn)
%  at Tsinghua University, Beijing, China.

%determine the appropriate size of kernel. The smaller epsilon, the larger
%size.
%sigma = 1;
if (sigma < 0.04) 
    sigma = 0.04;
end
epsilon=1e-2;
halfsize=ceil(sigma*sqrt(-2*log(sqrt(2*pi)*sigma*epsilon)));
size=2*halfsize+1;

%generate a 2-D Gaussian kernel along x direction
% for i=1:size
%     for j=1:size
%         u=[i-halfsize-1 j-halfsize-1];
%         hx(i,j)=gauss(u(1),sigma)*dgauss(u(2),sigma);
%     end
% end
% hx=hx/sqrt(sum(sum(abs(hx).*abs(hx))));
% %generate a 2-D Gaussian kernel along y direction
% hy=hx';
% %2-D filtering
% %gx=imfilter(im,hx,'replicate','conv');
% gx = conv2(im,hx, 'same');
% %gy=imfilter(im,hy,'replicate','conv');
% gy = conv2(im,hy, 'same');

    
for i=1:size
    u=[i-halfsize-1];
    h(i)=dgauss(u(1),sigma);
end
h=h/sqrt(sum((abs(h).*abs(h))));
for i=1:size
    u=[i-halfsize-1];
    p(i)=gauss(u(1),sigma);
end
p=p/sqrt(sum(abs(p).*abs(p)));
gx = conv2(p, h, im, 'same');    
gy = conv2(h, p, im, 'same');

function y = dgauss(x,sigma)
%first order derivative of Gaussian
y = -x * gauss(x,sigma) / sigma^2;
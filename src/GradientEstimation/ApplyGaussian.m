function [im] = ApplyGaussian(im, sigma)

%determine the appropriate size of kernel. The smaller epsilon, the larger
%size.
%sigma = 1;
epsilon=1e-2;
halfsize=ceil(sigma*sqrt(-2*log(sqrt(2*pi)*sigma*epsilon)));
size=2*halfsize+1;
%generate a 2-D Gaussian kernel along x direction
for i=1:size
    for j=1:size
        u=[i-halfsize-1 j-halfsize-1];
        hx(i,j)=gauss(u(1),sigma)*gauss(u(2),sigma);
    end
end
hx=hx/sqrt(sum(sum(abs(hx).*abs(hx))));

% for i=1:size
%     u=[i-halfsize-1];
%     h(i)=gauss(u(1),sigma);
% end
% h=h/sqrt(sum(abs(h).*abs(h)));


%2-D filtering
%gx=imfilter(im,hx,'replicate','conv');
im = conv2(im,hx, 'same');


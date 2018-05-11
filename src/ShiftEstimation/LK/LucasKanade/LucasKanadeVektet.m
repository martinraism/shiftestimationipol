function [u, v, w] = LucasKanadeVektet(im1, im2, windowSize, img);
%LucasKanade  lucas kanade algorithm, without pyramids (only 1 level);

%REVISION: NaN vals are replaced by zeros

[fx, fy, ft] = ComputeDerivatives(im1, im2);

u = zeros(size(im1));
v = zeros(size(im2));

halfWindow = floor(windowSize/2);
for i = halfWindow+1:size(fx,1)-halfWindow
   for j = halfWindow+1:size(fx,2)-halfWindow
      curFx = fx(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      curFy = fy(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      curFt = ft(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
      
      curFx = (curFx');
      curFy = (curFy');
      curFt = (curFt');

      curFx = curFx(:);
      curFy = curFy(:);
      curFt = -curFt(:);
      A = [curFx curFy];
      H = A'*A;
      [V,D]=eig(H);
      % V = eigenvector; D = eigenvalues
      U = pinv(H)*A'*curFt;         
      u(i,j)=U(1);
      v(i,j)=U(2);
      
      w(i,j)=det(H)-9.968*((trace(H))/(2))^2;
%       w(i,j)=det(H)-9.968*((trace(H))/(2))^2;
   end;
end;
w = padarray(w,[size(u,1)-size(w,1) size(u,2)-size(w,2)],'post');

%w01 = w/min(w(:));

u(isnan(u))=0;
v(isnan(v))=0;
%u=u(2:size(u,1), 2:size(u,2));
%v=v(2:size(v,1), 2:size(v,2));
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fx, fy, ft] = ComputeDerivatives(im1, im2);
%ComputeDerivatives	Compute horizontal, vertical and time derivative
%							between two gray-level images.

if (size(im1,1) ~= size(im2,1)) | (size(im1,2) ~= size(im2,2))
   error('input images are not the same size');
end;

if (size(im1,3)~=1) | (size(im2,3)~=1)
   error('method only works for gray-level images');
end;
% % Enkelt Derivat
fx = conv2(im1, [-1 1]) + conv2(im2, [-1 1]);
fy = conv2(im1, [-1 1]') + conv2(im2, [-1 1]');
ft = conv2(im1, [1 1]) + conv2(im2, -[1 1]);
% MAKE SAME SIZE AS INPUT, 3X3 DERIVAT
fx=fx(1:size(fx,1), 1:size(fx,2)-1);
fy=fy(1:size(fy,1)-1, 1:size(fy,2));
ft=ft(1:size(ft,1), 1:size(ft,2)-1);

% % SYMMETRISK DERIVAT
% fx = conv2(im1, (1/2)*[-1 0 1]) + conv2(im2, (1/2)*[-1 0 1]);
% fy = conv2(im1, (1/2)*[-1 0 1]') + conv2(im2, (1/2)*[-1 0 1]');
% ft = conv2(im1, (1/2)*[1 1 1]) + conv2(im2, -(1/2)*[1 1 1]);
% % MAKE SAME SIZE AS INPUT, 1X3 DERIVAT
% fx=fx(1:size(fx,1), 1:size(fx,2)-2);
% fy=fy(3:size(fy,1), 1:size(fy,2));
% ft=ft(1:size(ft,1), 1:size(ft,2)-2);

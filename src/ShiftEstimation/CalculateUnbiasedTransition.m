function [output] = CalculateUnbiasedTransition(u, v, variance)

% Compute gradient
[dx, dy] = CalculateGradient(u);
filterMatrix = true(size(u));
filterMatrix(1:end,size(filterMatrix,2):end) = false;
filterMatrix(size(filterMatrix,1):end,1:end) = false;
filterMatrix(isnan(dx)) = false;
filterMatrix(isnan(dy)) = false;
v(1:end-1,1:end-1) = (v(1:end-1,1:end-1) + v(1:end-1, 2:end) + v(2:end, 1:end-1) + v(2:end,2:end)) / 4;
u(1:end-1,1:end-1) = (u(1:end-1,1:end-1) + u(1:end-1, 2:end) + u(2:end, 1:end-1) + u(2:end,2:end)) / 4;
filterMatrix(isnan(v)) = false;
dif = v - u;
dx = dx(filterMatrix);
dy = dy(filterMatrix);
dif = dif(filterMatrix);
dx = dx(:);
dy = dy(:);
dif = dif(:);
N = size(dx,1);
sIx2 = sum(dx.^2) - 2 * variance * N;
sIy2 = sum(dy.^2) - 2 * variance * N;
sIxIt = sum(dx.* dif) - variance * N;
sIyIt = sum(dy.* dif) - variance * N;
sIxIy = sum(dx.*dy) - variance * N;
Det = sIx2 * sIy2 - sIxIy;
output = zeros(2,1);
output(1) = (sIxIt*sIy2 - sIyIt * sIxIy) / Det;
output(2) = (sIyIt*sIx2 - sIxIt * sIxIy) / Det;

%A = [dx dy];
%output = (A'*A)\(A'*dif);

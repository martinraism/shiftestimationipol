function [res1] = CalculateCompensatedTransitionBetweenFrames(u, v, varargin)

if (length(varargin) ~= 7)
    error ('Not enough parameters on method CalculateCompensatedTransitionBetweenFrames.');
end
dx = varargin{1};
dy = varargin{2};
gradientType = varargin{3};
itQty = varargin{4};
interpType = varargin{5};
step = varargin{6};
sigma2 = varargin{7};
[filterMatrixOrig] = GetFilterMatrixFromGradientType(gradientType, u);
filterMatrixOrig(isnan(dx)) = false;
filterMatrixOrig(isnan(dy)) = false;
vAligned = v;
% if (strcmp(gradientType,'BD'))
%     u(1:end-1,1:end-1) = (u(1:end-1,1:end-1) + u(1:end-1, 2:end) + u(2:end, 1:end-1) + u(2:end,2:end)) / 4;
% end
res1 = [0;0];
for i = 1:itQty
%     if (strcmp(gradientType,'BD'))
%         vAligned(1:end-1,1:end-1) = (vAligned(1:end-1,1:end-1) + vAligned(1:end-1, 2:end) + vAligned(2:end, 1:end-1) + vAligned(2:end,2:end)) / 4;
%     end
    filterMatrix = filterMatrixOrig;
    dif = vAligned - u;
    dif = BlurImageByGradientType(dif, gradientType);
    filterMatrix(isnan(dif)) = false;
    dx2 = dx(filterMatrix);
    dy2 = dy(filterMatrix);
    dif = dif(filterMatrix);
    A = [dx2(:) dy2(:)];
    A = A(1:step:end,:);
    dif = dif(:);
    dif = dif(1:step:end);

    % Only do the bias compensation on the first iteration (since the
    % variance of the noise changes in the second image)
    if (i == 1)
        res1 = res1 + (A'*A - length(dif) * sigma2 * eye(2))\(A'*dif);
    else
        res1 = res1 + (A'*A)\(A'*dif);
    end    
    
    if (abs(res1(1)) > 5 || abs(res1(2)) > 5)
        res1 = [-1;-1];
    end
    
    if (i < itQty && (res1(1) ~= -1 || res1(2) ~= -1))
        try
            [vAligned] = ResampleImage(v, res1(1), res1(2), interpType);
        catch
            res1 = [-1;-1];
        end
    end
end



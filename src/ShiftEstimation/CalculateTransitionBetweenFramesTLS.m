function [res1] = CalculateTransitionBetweenFramesTLS(u, v, varargin)

if (length(varargin) ~= 7)
    error ('Not enough parameters on method CalculateTransitionBetweenFramesTLS.');
end
dx = varargin{1};
dy = varargin{2};
gradientType = varargin{3};
itQty = varargin{4};
interpType = varargin{5};
useTLS = varargin{6};
step = varargin{7};
[filterMatrixOrig] = GetFilterMatrixFromGradientType(gradientType, u);
if (strcmp(gradientType,'BD'))
%    u(1:end-1,1:end-1) = (u(1:end-1,1:end-1) + u(1:end-1, 2:end) + u(2:end, 1:end-1) + u(2:end,2:end)) / 4;
    u = conv2(u,[.25 .25;.25 .25], 'same');
end
filterMatrixOrig(isnan(dx)) = false;
filterMatrixOrig(isnan(dy)) = false;
vAligned = v;
res1 = [0;0];
for i = 1:itQty
    if (res1(1) ~= -1 || res1(2) ~= -1)
        if (strcmp(gradientType,'BD'))
            %vAligned(1:end-1,1:end-1) = (vAligned(1:end-1,1:end-1) + vAligned(1:end-1, 2:end) + vAligned(2:end, 1:end-1) + vAligned(2:end,2:end)) / 4;
            vAligned = conv2(vAligned,[.25 .25;.25 .25], 'same');
        end
        filterMatrix = filterMatrixOrig;
        dif = vAligned - u;
        filterMatrix(isnan(dif)) = false;
        dx2 = dx(filterMatrix);
        dy2 = dy(filterMatrix);
        dif = dif(filterMatrix);
        A = [dx2(:) dy2(:)];
        A = A(1:step:end,:);
        dif = dif(:);
        dif = dif(1:step:end);
        if (~useTLS)
            % Linear Least Squares Minimization
            res1 = res1 + (A'*A)\(A'*dif);
        else
            % Total Least Squares Minimization
            Z = [A dif];              % Z is X augmented with Y.
            [~, S, ~] = svd(Z,0);           % find the SVD of Z.
            AtA = A'*A;
            if (size(S,1) >= 3 && size(S,2) >= 3)
                res1 = res1 + (AtA - S(3,3)*S(3,3)*eye(size(AtA)))\(A'*dif);
            else
                res1 = [-1;-1];
            end
        end
        if (abs(res1(1)) > 2 || abs(res1(2)) > 2)
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
end
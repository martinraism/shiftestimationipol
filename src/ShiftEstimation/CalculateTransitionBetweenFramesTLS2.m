function [res1] = CalculateTransitionBetweenFramesTLS2(u, v, varargin)
warning('off','MATLAB:nearlySingularMatrix');
warning('off','MATLAB:singularMatrix');
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
filterMatrixOrig(isnan(dx)) = false;
filterMatrixOrig(isnan(dy)) = false;
vAligned = v;
res1 = [0;0];
%h = figure;
for i = 1:itQty
    if (res1(1) ~= -1 || res1(2) ~= -1)
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
        if (~useTLS)
            % Linear Least Squares Minimization
            res1 = res1 + (A'*A)\(A'*dif);
        else
            % Total Least Squares Minimization
            Z = [A dif];              % Z is X augmented with Y.
            [U, S, V] = svd(Z,0);           % find the SVD of Z.
            if (size(S,1) >= 3 && size(S,2) >= 3)
                ratio = S(3,3) / S(2,2);
                if (ratio > 0.8) % if ratio is poor, use LS
                    lsRes = res1 + (A'*A)\(A'*dif);
                    res1 = lsRes;
                    %fprintf('ratio: %f. sigma3: %f. res: (%f, %f)\n', ratio, S(3,3), res1(1), res1(2));
                else
                    n = 2;
                    VXY     = V(1:n,1+n:end);     % Take the block of V consisting of the first n rows and the n+1 to last column
                    VYY     = V(1+n:end,1+n:end); % Take the bottom-right block of V.
                    B       = -VXY/VYY;
                    TLSRes = res1 + B;
    %                 AtA = A'*A;
    %                 B2      = (AtA - S(3,3)*S(3,3)*eye(size(AtA)))\(A'*dif);
                    res1 = TLSRes;
%                     if (abs(res1(1)) > 2 || abs(res1(2)) > 2)
%                         fprintf('VYY: %f. ratio: %f. sigma3: %f. res: (%f, %f)\n', VYY, S(3,3) / S(2,2), S(3,3), res1(1), res1(2));
%                     end
                end
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
                %imRes = u - vAligned;
%                 dir = '/Volumes/PhD/manuscript/7161464bfnkgcxwwkpj/img/';
%                 ShowImage(vAligned); saveas(h, [dir 'im2ForGBSEIt' num2str(i+1) '.png']);
%                 ShowImage(imRes.^2); saveas(h, [dir 'difForGBSEIt' num2str(i+1) '.png']);

                
%                 if (1 == 2)
%                     close all;
%                     %res1 = [-1.5;-1.04];
%                     [vAlignedSpline] = ResampleImage(v, res1(1), res1(2), 'spline');
%                     %[vAlignedFFT] = ResampleImage(v, res1(1), res1(2), 'FFT');
%                     [vAlignedDCT] = ResampleImage(v, res1(1), res1(2), 'DCT');
%                     figure;
%                     ShowImage(vAlignedSpline);
%                     %figure;
%                     %ShowImage(vAlignedFFT);
%                     figure;
%                     ShowImage(vAlignedDCT);
%                 end
                
            catch
                res1 = [-1;-1];
            end
        end
    end
end
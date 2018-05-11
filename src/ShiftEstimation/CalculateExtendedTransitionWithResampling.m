function [output] = CalculateExtendedTransitionWithResampling(u, v, varargin)

if length(varargin) ~= 8
    error('Missing parameters on CalculateExtendedTransitionWithResampling function');
end
dx = varargin{1};
dy = varargin{2};
gradientType = varargin{3};
itQty = varargin{4};
interpType = varargin{5};
useTLS = varargin{6};
step = varargin{7};
scalesQty = varargin{8};

% Determine amount of scales
[h, w] = size(u);
sz = min(h,w);
gsz = GetGradientSupport( gradientType );
for i=1:scalesQty
    if (sz - gsz < 2)
        scalesQty = i - 1;
        break;
    end
    sz = ceil(sz / 2);
end
% Build pyramid
uCell = cell(1,scalesQty);
uCell{1} = u;
for i=1:(scalesQty-1)
    uCell{i+1} = pyramid(uCell{i});
%     if i == 1
%         sigma = sqrt(1.4^2-0.7^2);
%     else
%        sigma = sqrt(1.4^2-0.8^2);
%     end
%     kernel = Generate1DGaussianKernel(sigma);
%     hs = ceil(length(kernel) / 2) - 1;
%     im2 = padarray(uCell{i},[hs hs], 'replicate'); 
%     im= conv2( conv2( im2, kernel', 'valid'), kernel, 'valid');
%     %im = imgaussfilt(uCell{i},sigma);
%     uCell{i+1} = im(1:2:end,1:2:end);
end

vCell = cell(1,scalesQty);
vCell{1} = v;
for i=1:(scalesQty-1)
    vCell{i+1} = pyramid(vCell{i});
%     if i == 1
%         sigma = sqrt(1.6^2-0.7^2);
%     else
%         sigma = sqrt(1.6^2-0.8^2);
%     end
%     kernel = Generate1DGaussianKernel(sigma);
%     hs = ceil(length(kernel) / 2) - 1;
%     im2 = padarray(vCell{i},[hs hs], 'replicate'); 
%     im= conv2( conv2( im2, kernel', 'valid'), kernel, 'valid');
%     %im = imgaussfilt(vCell{i},sigma);
%     vCell{i+1} = im(1:2:end,1:2:end);
end

acumShift = [0;0];

failed = false;
for i=scalesQty:-1:2
    % First compute the gradient for the current scale
    [dxScale, dyScale] = CalculateGradientByType(uCell{i}, gradientType);
    % Now estimate the shift
    shift = CalculateTransitionBetweenFramesTLS2(uCell{i}, vCell{i}, dxScale, dyScale, gradientType, itQty, interpType, useTLS, step);
    if (shift(1) == -1 && shift(2) == -1)
        % Try next scale
        acumShift = acumShift .* 2;
    else        
        try
            acumShift = acumShift .* 2 + shift .* 2;
            [vCell{i-1}] = ResampleImage(vCell{i-1}, acumShift(1), acumShift(2), interpType);
        catch
            failed = true;
            break;
        end
    end
end
if (~failed)
    output = acumShift + CalculateTransitionBetweenFramesTLS2(uCell{1}, vCell{1}, dx, dy, gradientType, itQty, interpType, useTLS, step);
else
    output = [-1;-1];
end

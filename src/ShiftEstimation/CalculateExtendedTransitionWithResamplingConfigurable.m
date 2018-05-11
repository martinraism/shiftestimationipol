function [output] = CalculateExtendedTransitionWithResamplingConfigurable(u, v, varargin)
if length(varargin) ~= 8
    error('Missing parameters on CalculateExtendedTransitionWithResamplingConfigurable function');
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
        useTLS = useTLS(1:scalesQty);
        itQty = itQty(1:scalesQty);
        interpType = interpType(1:scalesQty);
        break;
    end
    sz = ceil(sz / 2);
end

% Compute 4 scales of Gaussian pyramid (up to 8 pixels)
assert(numel(useTLS)==scalesQty);
assert(numel(itQty)==scalesQty);
assert(numel(interpType)==scalesQty);

uCell = cell(1,scalesQty);
uCell{1} = u;
for i=1:(scalesQty-1)
    uCell{i+1} = pyramid(uCell{i});
end

vCell = cell(1,scalesQty);
vCell{1} = v;
for i=1:(scalesQty-1)
    vCell{i+1} = pyramid(vCell{i});
end

acumShift = [0;0];

failed = false;
output = zeros(scalesQty,2);
for i=scalesQty:-1:2
    % First compute the gradient for the current scale
    [dxScale, dyScale] = CalculateGradientByType(uCell{i}, gradientType);
    % Now estimate the shift
    shift = CalculateTransitionBetweenFramesTLS2(uCell{i}, vCell{i}, dxScale, dyScale, gradientType, itQty(i), interpType{i}, useTLS(i), step);
    if (shift(1) == -1 && shift(2) == -1)
        % Try next scale
        output(i,:) = [-1;-1];
        acumShift = acumShift .* 2;
    else        
        try
            acumShift = acumShift .* 2 + shift .* 2;
            output(i,:) = acumShift;
            [vCell{i-1}] = ResampleImage(vCell{i-1}, acumShift(1), acumShift(2), interpType{i-1});
        catch
            failed = true;
            break;
        end
    end
end
if (~failed)
    output(1,:) = acumShift + CalculateTransitionBetweenFramesTLS2(uCell{1}, vCell{1}, dx, dy, gradientType, itQty(1), interpType{1}, useTLS(1), step);
else
    output = [-1;-1];
end

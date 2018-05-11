function [output] = CalculateExtendedTransition(u, v, varargin)

if length(varargin) ~= 8
    error('Missing parameters on CalculateExtendedTransition function');
end
dx = varargin{1};
dy = varargin{2};
itQty = varargin{3};
interpType = varargin{4};
useTLS = varargin{5};
step = varargin{6};
gradientType = varargin{7};
scalesQty = varargin{8};
% Compute 4 scales of Gaussian pyramid (up to 8 pixels)
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
for i=scalesQty:-1:2
    shift = CalculateTransition(uCell{i}, vCell{i}, itQty, 'bicubic', gradientType, useTLS, step);
    if(abs(shift(1)) > size(uCell{i},1)/2 || abs(shift(2)) > size(vCell{i},2)/2)
        failed = true;
        break;
    end
    if (sum(isnan(shift)) == 0)
        acumShift = acumShift .* 2 + shift .* 2;
        [vCell{i-1}, x, y] = IntegerShift(vCell{i-1}, acumShift(1), acumShift(2));
        if (i-1 == 1)
            acumShift = [x;y];
        end
    else
        break;
    end
end
if (~failed)
    useTLS = varargin{5};
    step = varargin{6};
    gradientType = varargin{7};
    output = acumShift + CalculateTransitionBetweenFramesTLS2(uCell{1}, vCell{1}, dx, dy, gradientType, itQty, interpType, useTLS, step);
else
    output = [0;0];
end

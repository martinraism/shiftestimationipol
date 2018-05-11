function [output] = CalculateExtendedTransitionMultiscaleSDF(u, v, N, scalesQty)

% Build pyramid
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
    % Estimate the shift using SDF
%    shift = CalculateExtendedTransitionSDF(uCell{i}, vCell{i}, 'SDF', 'NI', N);
    cc = normxcorr2(uCell{i},vCell{i});
    [ypeak, xpeak] = find(cc==max(cc(:)));
    yoffSet = ypeak-size(uCell{i},1);
    xoffSet = xpeak-size(uCell{i},2);
    shift = [xoffSet yoffSet];
    [~, Ix] = max(cc(:));
    [yMax,xMax] = ind2sub(size(cc), Ix);
    %shift = [(xMax - size(vCell{i},2)) (yMax-size(vCell{i},1))];
    
    if (shift(1) == -1 && shift(2) == -1)
        % Try next scale
        acumShift = acumShift .* 2;
    else        
        try
            acumShift = acumShift .* 2 + shift' .* 2;
            [vCell{i-1}] = ResampleImage(vCell{i-1}, acumShift(1), acumShift(2), 'bicubic');
        catch
            failed = true;
            break;
        end
    end
end
if (~failed)
    finalShift = CalculateExtendedTransitionSDF(uCell{1}, vCell{1}, 'SDF', '2LS', N);
    if (size(acumShift) == size(finalShift))
        output = acumShift + finalShift;
    else
        output = acumShift' + finalShift;
    end
else
    output = [-1;-1];
end

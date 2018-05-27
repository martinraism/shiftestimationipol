function [output] = CalculateExtendedTransitionBetweenFramesGC2004(I1, I2, par, method)
% if (exist('../ShiftEstimation/Argyriou','dir')) 
%     addpath('../ShiftEstimation/Argyriou');
% elseif exist('./ShiftEstimation/Argyriou','dir')
%     addpath('./ShiftEstimation/Argyriou');
% end

defaultCutoffFreq = 0.25;

switch method
    case 1
        [output,~, ~] = GC(I1, I2, par, defaultCutoffFreq, 0);
    case 2
        [output, ~, ~] = GC(I1, I2, par, defaultCutoffFreq, 1);
    case 3
        [output] = GC2(I1, I2, par, defaultCutoffFreq, 0);
    case 4
        [output] = GC2(I1, I2, par, defaultCutoffFreq, 1);
end
if (~isempty(output))
    output = -output;
    temp = output(1);
    output(1) = output(2);
    output(2) = temp;
    output = output';
    siz1 = size(I1, 1); siz2 = size(I1, 2);
    if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
        output = [];
    end
end
end
function [output] = CalculateExtendedTransitionBetweenFramesPC2006(I1, I2, method, window)
if (exist('../ShiftEstimation/Argyriou','dir')) 
    addpath('../ShiftEstimation/Argyriou');
elseif exist('./ShiftEstimation/Argyriou','dir')
    addpath('./ShiftEstimation/Argyriou');
end

output = PhaseCorrelation(I1, I2, window, method);

output = -output;
temp = output(1);
output(1) = output(2);
output(2) = temp;
output = output';
end
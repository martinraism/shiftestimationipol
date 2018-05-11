function [output] = CalculateExtendedTransitionBetweenFramesSubspace(I1, I2, window)
if (exist('../ShiftEstimation/Argyriou','dir')) 
    addpath('../ShiftEstimation/Argyriou');
elseif exist('./ShiftEstimation/Argyriou','dir')
    addpath('./ShiftEstimation/Argyriou');
end

output = SubspacePhaseCorrelation(I1, I2, window);

output = -output;
temp = output(1);
output(1) = output(2);
output(2) = temp;
output = output';
end
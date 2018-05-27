function [output] = CalculateExtendedTransitionBetweenFramesGC2011(I1, I2, par, method)

% if (exist('../ShiftEstimation/Argyriou','dir')) 
%     addpath('../ShiftEstimation/Argyriou');
% else
%     if exist('./ShiftEstimation/Argyriou','dir')
%         addpath('./ShiftEstimation/Argyriou');
%     end
% end
R = 10; %2R+1 points for non-linear least squares
%p = [1 1 1];
p = [1 1 1];
switch method
    case 1
        output = KernelGC(I1, I2, par, 0.25, p, R, 0, []);
    case 2
        output = KernelGC(I1, I2, par, 0.25, p, R, 1, 0);
    otherwise
        output = KernelGC(I1, I2, par, 0.25, p, R, 1, 1);
end
output = -output;
temp = output(1);
output(1) = output(2);
output(2) = temp;
output = output';
siz1 = size(I1, 1); siz2 = size(I1, 2);
if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
    output = [-1;-1];
end


end
function [output] = CalculateExtendedTransitionBetweenFramesGuizar(I1, I2, precision)

% if (exist('../ShiftEstimation/Guizar','dir')) 
%     addpath('../ShiftEstimation/Guizar');
% else
%     if exist('./ShiftEstimation/Guizar','dir')
%         addpath('./ShiftEstimation/Guizar');
%     end
% end
[res, ~] = dftregistration(fft2(I1),fft2(I2),precision);
output = res(3:4);

temp = output(1);
output(1) = output(2);
output(2) = temp;
output = output';
siz1 = size(I1, 1); siz2 = size(I1, 2);
if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
    output = [-1;-1];
end


end
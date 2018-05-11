function [output] = CalculateExtendedTransitionUsingCorrelationKnutsson(I1, I2, windowType, version)
%function [output] = CalculateTransitionBetweenFramesStone(I1, I2, K, windowType)
[I1w,I2w] = ApplyWindow(I1, I2, windowType);
[I1w,I2w] = CleanNaNBorders(I1w, I2w);

%F = fftshift(fft2(I1w));
%G = fftshift(fft2(I2w));

%PS = (conj(F) .* G);
%PS = PS ./(abs(PS));
%PC = angle(PS);

% Take frequencies 1,1
% Get center frequency position

%posX = floor(size(PS,1) / 2) + 1; 
%posY = floor(size(PS,2) / 2) + 1; 

if (version == 1)
    output = CalculateExtendedTransitionUsingCorrelationConfigurable(I1w,I2w, [1 0; 0 1]);
    %A = [1 0;0 1];
    %b = [PC(posY, posX+1); PC(posY+1,posX)];
elseif (version == 2)
    output = CalculateExtendedTransitionUsingCorrelationConfigurable(I1w,I2w, [1 -1; 1 0; 1 1; 0 1]);
    %A = [1 -1;1 0;1 1;0 1];
    %b = [PC(posY-1, posX+1); PC(posY, posX+1); PC(posY+1,posX+1); PC(posY+1,posX)];
end
%output2 = ((A'*A)\(A'*b)) * size(I1,1) / (2*pi);
%fprintf('Dif: %f,%f\n', output(1)-output2(1), output(2) - output2(2));


siz1 = size(I1, 1); siz2 = size(I1, 2);
if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
    output = [-1;-1];
end

end
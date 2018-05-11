function [image] = ResampleImage(image, resX, resY, interpType)
    switch interpType
        case 'FFT'
            [image, removed] = CleanNaNBordersFromSingleImage(image);
            [image] = FourierShift(resX, resY, image, []);
            % Put NaNs where it should
            if (resX > 0)
                image(:,1:ceil(resX)) = nan;
            elseif (resX < 0)
                image(:,end+ceil(resX):end) = nan;
            end
            if (resY > 0)
                image(1:ceil(resY),:) = nan;
            elseif (resY < 0)
                image((end+ceil(resY)):end,:) = nan;
            end
            image = AddNaNBordersBack(image, removed, true);
            
        case 'DCT'
            [image, removed] = CleanNaNBordersFromSingleImage(image);
            % Mirror image to make it periodic
            bigImg =[flip(image,2) image; flip(flip(image,1),2) flip(image,1)];
            % Now shift it using Fourier shift 
            shiftedImg = FourierShift(resX , resY , bigImg, []);
            % Now extract the image from the big image
            image = shiftedImg(1:size(image,1),size(image,2)+1:end);
            % Put NaNs where it should
            if (resX > 0)
                image(:,1:ceil(resX)) = nan;
            elseif (resX < 0)
                image(:,end+ceil(resX):end) = nan;
            end
            if (resY > 0)
                image(1:ceil(resY),:) = nan;
            elseif (resY < 0)
                image((end+ceil(resY)):end,:) = nan;
            end
            image = AddNaNBordersBack(image, removed, true);
                        
        otherwise
            Xi = repmat(1:size(image,2), size(image,1),1) - resX;
            Yi = repmat((1:size(image,1))', 1,size(image,2)) - resY;
            % This is because of a Matlab BUG for spline interpolation.
            % left, right, top, bottom
            [image, removed] = CleanNaNBordersFromSingleImage(image);
            image = interp2(1:size(image,2), 1:size(image,1), image, Xi, Yi, interpType);
            image = AddNaNBordersBack(image, removed, false);
            if (strcmp(interpType,'spline'))
                image(Xi < 1) = nan;
                image(Xi > size(image,2) - removed(2)) = nan;
                image(Yi < 1) = nan;
                image(Yi > size(image,1) - removed(4)) = nan;
            end           
    end
end
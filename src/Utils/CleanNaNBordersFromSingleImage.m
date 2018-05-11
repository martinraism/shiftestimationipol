function [image, removed] = CleanNaNBordersFromSingleImage(image)
    % 1: Left
    % 2: Right
    % 3: Top
    % 4: Bottom
    removed = zeros(4,1);
    midY = round(size(image,1)/2);
    midX = round(size(image,2)/2);
    while (isnan(image(midY,1)) || isnan(image(1,midX)) || isnan(image(midY,end)) || isnan(image(end,midX)))
        midY = round(size(image,1)/2);
        while (isnan(image(midY,1)))
            image = image(:,2:end);
            removed(1) = removed(1) + 1;
        end
        midX = round(size(image,2)/2);
        while (isnan(image(1,midX)))
            image = image(2:end,:);
            removed(3) = removed(3) + 1;
        end
        while (isnan(image(end,midX)))
            image = image(1:end-1,:);
            removed(4) = removed(4) + 1;
        end
        midY = round(size(image,1)/2);
        while (isnan(image(midY,end)))
            image = image(:,1:end-1);
            removed(2) = removed(2) + 1;
        end
    end
end

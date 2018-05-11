function [image, im2] = CleanNaNBorders(image, im2)
    midY = round(size(image,1)/2);
    midX = round(size(image,2)/2);
    while (~isempty(image) && (isnan(image(midY,1)) || isnan(image(1,midX)) || isnan(image(midY,end)) || isnan(image(end,midX))))
        % From left to right
        midY = round(size(image,1)/2);
        while (~isempty(image) && isnan(image(midY,1)))
            image = image(:,2:end);
            im2 = im2(:,2:end);
        end
        % From top to bottom
        midX = round(size(image,2)/2);
        while (~isempty(image) && isnan(image(1,midX)))
            image = image(2:end,:);
            im2 = im2(2:end,:);
        end
        % From bottom to top
        while (~isempty(image) && isnan(image(end,midX)))
            image = image(1:end-1,:);
            im2 = im2(1:end-1,:);
        end
        % From right to left
        midY = round(size(image,1)/2);
        while (~isempty(image) && isnan(image(midY,end)))
            image = image(:,1:end-1);
            im2 = im2(:,1:end-1);
        end
    end

end

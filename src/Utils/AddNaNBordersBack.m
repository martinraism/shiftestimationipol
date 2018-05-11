function image = AddNaNBordersBack(image, removed, expandSize)
    if (expandSize)
    % 1: Left
    % 2: Right
    % 3: Top
    % 4: Bottom
        image = [image zeros(size(image,1),removed(1))];
        image = [image zeros(size(image,1),removed(2))];
        image = [image; zeros(size(image,2),removed(3))'];
        image = [image; zeros(size(image,2),removed(4))'];
    end
    image(removed(3)+1:end,:) = image(1:end-removed(3),:);
    image(1:removed(3),:) = nan;
    image(:, removed(1)+1:end) = image(:, 1:end-removed(1));
    image(:,1:removed(1)) = nan;
    image((end-removed(4)+1):end,:) = nan;
    image(:,(end-removed(2)+1):end) = nan;
end
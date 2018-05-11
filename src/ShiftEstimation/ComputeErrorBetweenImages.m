function res = ComputeErrorBetweenImages(shift,u, v, intType)
    
    %Xi = repmat(1:size(u,2), size(u,1),1) - shift(1);
    %Yi = repmat((1:size(u,1))', 1,size(u,2)) - shift(2);
    %res = interp2(1:size(u,2), 1:size(u,1), u, Xi, Yi, intType);
    [res] = ResampleImage(u, shift(1), shift(2), intType);

    err = (res - v).^2;
    err = err(2:end-1,2:end-1);
    res = sum(err(:));
end

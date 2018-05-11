function res = ComputeErrorBetweenImagesSymmetric(shift,u, v, intType)
    %Xi = repmat(1:size(u,2), size(u,1),1) - shift(1);
    %Yi = repmat((1:size(u,1))', 1,size(u,2)) - shift(2);
    %res1 = interp2(1:size(u,2), 1:size(u,1), u, Xi, Yi, intType);
    [res1] = ResampleImage(u, shift(1), shift(2), intType);
    %Xi = repmat(1:size(u,2), size(u,1),1) + shift(1);
    %Yi = repmat((1:size(u,1))', 1,size(u,2)) + shift(2);
    %res2 = interp2(1:size(u,2), 1:size(u,1), v, Xi, Yi, intType);
    [res2] = ResampleImage(v, -shift(1), -shift(2), intType);
    
    err = (res1 - v).^2 + (res2 - u).^2;
    err = err(2:end-1,2:end-1);
    res = sum(err(:));
end
function [filterMatrix] = GetFilterMatrixFromGradientType( gradientType, u )

if (strcmp(gradientType,'BD'))
    filterMatrix = true(size(u));
    filterMatrix(1:end,size(filterMatrix,2):end) = false;
    filterMatrix(size(filterMatrix,1):end,1:end) = false;
elseif (strcmp(gradientType,'CENTER3') || strcmp(gradientType,'FARID7') || strcmp(gradientType,'CHRISTMAS3'))
    filterMatrix = true(size(u));
    filterMatrix(1:end,end-2:end) = false;
    filterMatrix(end-2:end,1:end) = false;
    filterMatrix(1:end,1:3) = false;
    filterMatrix(1:3,1:end) = false;
elseif (strcmp(gradientType,'CENTER2')  || strcmp(gradientType,'SIMO5') ...
        || strcmp(gradientType,'FARID5') || strcmp(gradientType,'CHRISTMAS2') ...
        || strcmp(gradientType,'HASTCUBIC') || strcmp(gradientType,'HASTCATMULLROM') ...
        || strcmp(gradientType,'HASTBEZIER') || strcmp(gradientType,'HASTBSPLINE') ...
        || strcmp(gradientType,'HASTTRIGONOMETRIC'))
    filterMatrix = true(size(u));
    filterMatrix(1:end,end-1:end) = false;
    filterMatrix(end-1:end,1:end) = false;
    filterMatrix(1:end,1:2) = false;
    filterMatrix(1:2,1:end) = false;
elseif (strcmp(gradientType,'CENTER1') || strcmp(gradientType,'SIMO3') || strcmp(gradientType,'FARID3') || strcmp(gradientType,'CHRISTMAS1'))
    filterMatrix = true(size(u));
    filterMatrix(1:end,end) = false;
    filterMatrix(end,1:end) = false;
    filterMatrix(1:end,1) = false;
    filterMatrix(1,1:end) = false;
else
    filterMatrix = true(size(u)); 
end

end


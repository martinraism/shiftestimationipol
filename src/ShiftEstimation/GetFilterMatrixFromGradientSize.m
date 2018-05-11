function [filterMatrix] = GetFilterMatrixFromGradientSize( sz, u )
    filterMatrix = true(size(u));
    
    filterMatrix(1:end,end-(sz-1):end) = false;
    filterMatrix(end-(sz-1):end,1:end) = false;
    filterMatrix(1:end,1:sz) = false;
    filterMatrix(1:sz,1:end) = false;
end


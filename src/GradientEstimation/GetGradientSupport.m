function [ res ] = GetGradientSupport( gradientType )
    switch (gradientType)
        case {'BD', 'BD2'}
            res = 2;
        case {'CENTER1', 'CHRISTMAS1', 'FARID3', 'SIMO3'}
            res = 3;
        case {'FARID5', 'SIMO5', 'CHRISTMAS2', 'CENTER2'}
            res = 5;
        case {'CHRISTMAS3','FARID7','CENTER3'}
            res = 7;
        case {'HASTCUBIC','HASTCATMULLROM','HASTBEZIER','HASTBSPLINE', 'HASTTRIGONOMETRIC'}
            res = 4;
        otherwise
            res = -1;
    end
end


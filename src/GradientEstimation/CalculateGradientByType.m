function [dx, dy] = CalculateGradientByType(u, gradientType)
    switch (gradientType)
        case 'BD'
            [dx, dy] = CalculateGradient(u);
        case 'BD2'
            [dx, dy] = CalculateGradient2(u);
        case 'CENTER3'
            [dx, dy] = CalculateGradient3(u,1);
        case 'CENTER2'
            [dx, dy] = CalculateGradient3(u,0.6);
        case 'CENTER1'
            [dx, dy] = CalculateGradient3(u,0.3);
        case 'CHRISTMAS1'
            [dx, dy] = CalculateGradientChristmas(u, 1);
        case 'CHRISTMAS2'
            [dx, dy] = CalculateGradientChristmas(u, 2);
        case 'CHRISTMAS3'
            [dx, dy] = CalculateGradientChristmas(u, 3);
        case 'FARID3'
            [dx, dy] = derivative3(u);
        case 'FARID5'
            [dx, dy] = derivative5(u, 'x', 'y');
        case 'FARID7'
            [dx, dy] = derivative7(u, 'x', 'y');
        case 'SIMO3'
            [dx, dy] = simo3(u);
        case 'SIMO5'
            [dx, dy] = simo5(u);
        case 'HASTCUBIC'
            [dx, dy] = hast(u, 'Cubic');
        case 'HASTCATMULLROM'
            [dx, dy] = hast(u, 'Catmull-Rom');
        case 'HASTBEZIER'
            [dx, dy] = hast(u, 'Bezier');
        case 'HASTBSPLINE'
            [dx, dy] = hast(u, 'B-Spline');
        case 'HASTTRIGONOMETRIC'
            [dx, dy] = hast(u, 'Trigonometric');
    end
end
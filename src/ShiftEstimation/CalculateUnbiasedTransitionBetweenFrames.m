function [output] = CalculateUnbiasedTransitionBetweenFrames(u, v, dx, dy, gradientType)

% First estimate the initial shift in the usual LS way
[ support ] = GetGradientSupport( gradientType );
if (support == 2)
    u1 = u; v1 = v;
    u1(1:end-1,1:end-1) = (u(1:end-1,1:end-1) + u(1:end-1, 2:end) + u(2:end, 1:end-1) + u(2:end,2:end)) / 4;
    u1 = u1(1:end-1,1:end-1); dx = dx(1:end-1,1:end-1); dy = dy(1:end-1,1:end-1);
    v1(1:end-1,1:end-1) = (v1(1:end-1,1:end-1) + v1(1:end-1, 2:end) + v1(2:end, 1:end-1) + v1(2:end,2:end)) / 4;
    v1 = v1(1:end-1,1:end-1); 
elseif (support == 7)
    u1 = u; v1 = v;
    u1 = u1(4:end-3,4:end-3); dx = dx(4:end-3,4:end-3); dy = dy(4:end-3,4:end-3);
    v1 = v1(4:end-3,4:end-3); 
elseif (support == 5 || support == 4)
    u1 = u; v1 = v;
    u1 = u1(3:end-2,3:end-2); dx = dx(3:end-2,3:end-2); dy = dy(3:end-2,3:end-2);
    v1 = v1(3:end-2,3:end-2); 
elseif (support == 3)
    u1 = u; v1 = v;
    u1 = u1(2:end-1,2:end-1); dx = dx(2:end-1,2:end-1); dy = dy(2:end-1,2:end-1);
    v1 = v1(2:end-1,2:end-1); 
end
dif = v1 - u1;
filterMatrix = true(size(u1));
filterMatrix(isnan(dif)) = false;
dif = dif(filterMatrix);
dx2 = dx(filterMatrix);
dy2 = dy(filterMatrix);
sdx2 = sum(dx2.^2);
sdy2 = sum(dy2.^2);
sdxdy = sum(dx2.*dy2);
Ahat = [sdx2 sdxdy; sdxdy sdy2];
bOrig = [sum(dif.*dx2); sum(dif.*dy2)];
shift = -(Ahat\bOrig);
shouldInvert = false;
% Based on this initial shift, check which of the four possibilities should be
% applied
if (shift(2) > 0)
    if (shift(1) > 0)
        v11 = shift;
        % Move one up and left
        v00 = EstimateTranslationOpticalFlow(u1(1:end-1,1:end-1),v1(2:end,2:end),dx(1:end-1,1:end-1),dy(1:end-1,1:end-1));
        % Move one up
        v01 = EstimateTranslationOpticalFlow(u1(1:end-1,1:end),v1(2:end,1:end),dx(1:end-1,1:end),dy(1:end-1,1:end));
        % Move one left
        v10 = EstimateTranslationOpticalFlow(u1(1:end,1:end-1),v1(1:end,2:end),dx(1:end,1:end-1),dy(1:end,1:end-1));
        
        res = Ahat * (v00 - v11);
        p1 = res(1);
        q1 = res(2);
        res = Ahat * (v01 - v11);
        p2 = res(1);
        q2 = res(2);
        res = Ahat * (v10 - v11);
        p3 = res(1);
        q3 = res(2);
        w1 = norm(abs(v00) + abs(v11))^(-2);
        w2 = norm(abs(v01) + abs(v11))^(-2);
        w3 = norm(abs(v10) + abs(v11))^(-2);
        A = [-w1-w2 -w1 0; -w1 -2*w1-w2-w3 -w1; 0 -w1 -w1-w3];
        b = [w1*p1 + w2*p2;w1*(p1+q1) + w2*q2 + w3*p3 ; w1*q1+w3*q3];
        shouldInvert = true;
    else
        
        v01 = shift;
        % Move one up
        v00 = EstimateTranslationOpticalFlow(u1(1:end-1,1:end),v1(2:end,1:end),dx(1:end-1,1:end),dy(1:end-1,1:end));
        % Move one right
        v11 = EstimateTranslationOpticalFlow(u1(1:end,2:end),v1(1:end,1:end-1),dx(1:end,2:end),dy(1:end,2:end));
        % Move one up and right
        v10 = EstimateTranslationOpticalFlow(u1(1:end-1,2:end),v1(2:end,1:end-1),dx(1:end-1,2:end),dy(1:end-1,2:end));
       
        res = Ahat * (v00 - v01);
        p1 = res(1);
        q1 = res(2);
        res = Ahat * (v10 - v01);
        p2 = res(1);
        q2 = res(2);
        res = Ahat * (v11 - v01);
        p3 = res(1);
        q3 = res(2);
        w1 = norm(abs(v00) + abs(v01))^(-2);
        w2 = norm(abs(v10) + abs(v01))^(-2);
        w3 = norm(abs(v11) + abs(v01))^(-2);
        A = [w2+w3 -w2 0; -w2 w1+2*w2+w3 -w2; 0 w2 -w1-w2];
        b = [w2*p2 + w3*p3;-w1*p1 + w2*(q2-p2)+w3*q3;w1*q1+w2*q2];
       
    end
else
    if (shift(1) > 0)
        v10 = shift;
        % Move one left
        v00 = EstimateTranslationOpticalFlow(u1(1:end,1:end-1),v1(1:end,2:end),dx(1:end,1:end-1),dy(1:end,1:end-1));
        % Move one down
        v11 = EstimateTranslationOpticalFlow(u1(2:end,1:end),v1(1:end-1,1:end),dx(2:end,1:end),dy(2:end,1:end));
        % Move one left down
        v01 = EstimateTranslationOpticalFlow(u1(2:end,1:end-1),v1(1:end-1,2:end),dx(2:end,1:end-1),dy(2:end,1:end-1));

        res = Ahat * (v00 - v10);
        p1 = res(1);
        q1 = res(2);
        res = Ahat * (v01 - v10);
        p2 = res(1);
        q2 = res(2);
        res = Ahat * (v11 - v10);
        p3 = res(1);
        q3 = res(2);
        w1 = norm(abs(v00) + abs(v10))^(-2);
        w2 = norm(abs(v01) + abs(v10))^(-2);
        w3 = norm(abs(v11) + abs(v10))^(-2);
        A = [-w1-w2 w2 0; -w2 w1+2*w2+w3 -w2; 0 -w2 w2+w3];
        b = [w1*p1 + w2*p2; -w1*q1+w2*(p2-q2)+w3*p3; w2*q2+w3*q3];
        
    else
        v00 = shift;
        % Move one down
        v01 = EstimateTranslationOpticalFlow(u1(2:end,1:end),v1(1:end-1,1:end),dx(2:end,1:end),dy(2:end,1:end));
        % Move one right
        v10 = EstimateTranslationOpticalFlow(u1(1:end,2:end),v1(1:end,1:end-1),dx(1:end,2:end),dy(1:end,2:end));
        % Move one right down
        v11 = EstimateTranslationOpticalFlow(u1(2:end,2:end),v1(1:end-1,1:end-1),dx(2:end,2:end),dy(2:end,2:end));
        
        res = Ahat * (v10 - v00);
        p1 = res(1);
        q1 = res(2);
        res = Ahat * (v01 - v00);
        p2 = res(1);
        q2 = res(2);
        res = Ahat * (v11 - v00);
        p3 = res(1);
        q3 = res(2);
        w1 = norm(abs(v10) + abs(v00))^(-2);
        w2 = norm(abs(v01) + abs(v00))^(-2);
        w3 = norm(abs(v11) + abs(v00))^(-2);
        A = [w1 + w3 w3 0; w3 w1+w2+2*w3 w3; 0 w3 w2+w3];
        b = [w1*p1 + w3*p3;w1*q1 + w2*p2+w3*(p3+q3);w2*q2+w3*q3];
        
    end
end 
% Solve the 3 by 3 system to obtain a noiseless estimation of matrix A^T A
% (its three values)
sol = A\b;
Anoiseless = [sol(1) sol(2);sol(2) sol(3)];
% Now that I have a noiseless estimation, solve the optical flow equation
% by inverting the noiseless matrix A
output = Anoiseless\bOrig;
if (shouldInvert)
    aux = output(1);
    output(1) = output(2);
    output(2) = aux;
end






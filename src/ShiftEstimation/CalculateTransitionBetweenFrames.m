function [output] = CalculateTransitionBetweenFrames(u, v, dx, dy, itQty, interpType)
step = 1;
% Compute gradient
filterMatrix = true(size(u));
filterMatrix(:,end) = false;
filterMatrix(end,:) = false;
u(1:end-1,1:end-1) = (u(1:end-1,1:end-1) + u(1:end-1, 2:end) + u(2:end, 1:end-1) + u(2:end,2:end)) / 4;
filterMatrix(isnan(dx)) = false;
filterMatrix(isnan(dy)) = false;
%G2 = (dx.^2).*(dy.^2);
%G2Aux = G2(1:end-1,1:end-1);
%filterMatrix(G2 < prctile(G2Aux(:),90)) = false;

vAligned = v;
output = [0;0];
for i = 1:itQty
    vAligned(1:end-1,1:end-1) = (vAligned(1:end-1,1:end-1) + vAligned(1:end-1, 2:end) + vAligned(2:end, 1:end-1) + vAligned(2:end,2:end)) / 4;
    filterMatrix(isnan(vAligned)) = false;
    %filterMatrix(1:2:end,1:1:end) = false;
    dif = vAligned - u;
    dx2 = dx(filterMatrix);
    dy2 = dy(filterMatrix);
    dif = dif(filterMatrix);
    A = [dx2(:) dy2(:)];
    A = A(1:step:end,:);
    dif = dif(:);
    dif = dif(1:step:end);
    output = output + (A'*A)\(A'*dif);
    if (i < itQty)
        try
            [vAligned] = ResampleImage(v, output(1), output(2), interpType);
        catch e
            output = [-1;-1];
            rethrow(e);
        end
    end
end
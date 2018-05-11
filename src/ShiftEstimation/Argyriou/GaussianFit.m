function out=GaussianFit(xx, yy)
    negVals = find(yy < 0);
    if ~isempty(negVals)
        valToAdd = abs(yy(negVals(1))) + 1;
        yy = yy + valToAdd;
    end
    num = log(yy(3)) - log(yy(1));
    denum = 2*log(yy(2)) - log(yy(1)) - log(yy(3));
    if (abs(denum) > 0.001)
        res = (1/2) * num / denum;
        out = xx(2) + res;
    else
        out = (siz1/2 - xx(2));
    end
    
%     num = log(yy(3)) - log(yy(1));
%     denum = 2*log(yy(2)) - log(yy(3)) - log(yy(1));
%     
%     if (abs(denum) > 0.001)
%         out1 = xx(2) + num/denum;
%     else
%         out1 = (siz1/2 - xx(2));
%     end


%     num = log(abs(yy(3) / yy(1)));
%     denom = log(abs(yy(2)^2 / (yy(3)*yy(1))));
%     if (abs(denom) > 0.001)
%         out = xx(2) + num/denom;
%     else
%         out = (xx(2));
%     end
end
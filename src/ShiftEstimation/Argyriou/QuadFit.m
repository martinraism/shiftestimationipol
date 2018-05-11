function out=QuadFit(xx, yy)
    denum = 2 * yy(2) - yy(3) - yy(1);
    num = yy(3) - yy(1);
    if (abs(denum) > 0.001) 
        res = (1/2) * num / denum;
        out = xx(2) + res;
%         out= xx(2) + (yy(3) - yy(1))/val;
    else
        out = xx(2);
    end
end
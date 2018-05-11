function [RMSE, result] = EvaluateError(shift, res)
    if (~isempty(shift) && ~isempty(res) && length(res) == 2 && (res(1) ~= -1 || res(2) ~= -1))
            RMSE = sqrt(((shift(1) + res(2) )^2 +  (shift(2) + res(1))^2)/2);
            result = res;
    else
        RMSE = Inf;
        if (~isempty(res) && length(res) == 2 && (res(1) ~= -1 || res(2) ~= -1))
            result = res;
        else
            result = [-1;-1];
        end
    end
end
function out=CalculateTransitionBetweenFramesDirectNLO(u, v, intType)

x0=[0 0];

options = optimset('LargeScale','off');
%options = optimoptions('fminsearch', 'Display', 'none');
func = @(x) ComputeErrorBetweenImages(x,u,v,intType);
out = fminsearch(func,x0,options);
%out = fminunc(func,x0,options);
out = -out;
end
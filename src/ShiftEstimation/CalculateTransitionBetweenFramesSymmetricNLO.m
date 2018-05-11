function out=CalculateTransitionBetweenFramesSymmetricNLO(u, v, intType)

x0=[0 0];

options = optimset('LargeScale','off');
%options = optimoptions('fminsearch', 'Display', 'none');
func = @(x) ComputeErrorBetweenImagesSymmetric(x,u,v,intType);
out = fminsearch(func,x0,options);
out = -out;
end
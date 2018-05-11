function F =  myKernel(x, xdata)

F = 1*x(1).*(1/(sqrt(2*pi)*(x(4).^1))).*(1 - ((x(3)*(xdata-x(2))).^2)).*exp(-((1*(xdata-x(2))).^2)./(2*x(4).^2));


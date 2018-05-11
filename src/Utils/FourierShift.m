function [v, shift] = FourierShift(a, b, u, f)

if (isempty(f))
    f = fft2(u);
end

[m, n] = size(u);

ashift = exp((-2i * pi / n) * (0:n-1)) .^ a;
bshift = exp((-2i * pi / m) * (0:m-1)) .^ (-b);
if (mod(n,2) == 0)
    ashift(n/2 + 1) = 0;
end
if (mod(m,2) == 0)
    bshift(m/2 + 1) = 0;
end
shift = bshift' * ashift;

v = ifft2(f .* shift, 'symmetric');

end

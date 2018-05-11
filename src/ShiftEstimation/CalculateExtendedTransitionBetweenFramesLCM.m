function output = CalculateExtendedTransitionBetweenFramesLCM( I1, I2, cutOff, windowSize, dim )

siz1 = size(I1, 1); siz2 = size(I1, 2);
%%%%%%%%% Apply Tukey window
w = window2(siz1,siz2,@tukeywin, cutOff);


I1 = w.*I1;
I2 = w.*I2;

a = fft(fft(I1, 1*siz1).', 1*siz2).';
b = fft(fft(I2, 1*siz1).', 1*siz2).';
s = abs( a .* conj(b) ); s( s == 0 ) = 1;
c = (a .* conj(b)) ./ s;
pc = fftshift(real(ifft2(c)));
% [U,S,V] = svds(pc, 1);
% pc = U*S*V';

peak = max(max((pc)));
[my, mx] = find((pc) == peak);
my = my(1); mx = mx(1);

center = (-1)*(floor([siz1 siz2]/2) - [my - 1, mx - 1]);

if (mx-windowSize > 1 && my-windowSize > 1 && mx+windowSize <= size(pc,2) && my+windowSize <= size(pc,1))
    switch dim
        case 1
            mmy = sum([center(1)-windowSize:center(1)+windowSize]' .* pc(my-windowSize:my+windowSize,mx))/sum(pc(my-windowSize:my+windowSize,mx));
            mmx = sum([center(2)-windowSize:center(2)+windowSize] .* pc(my,mx-windowSize:mx+windowSize))/sum(pc(my,mx-windowSize:mx+windowSize));
            output = [mmx mmy];
        case 2
            mmx = sum(sum(repmat([center(2)-windowSize:center(2)+windowSize],2*windowSize+1,1) .* pc(my-windowSize:my+windowSize,mx-windowSize:mx+windowSize)))/sum(sum(pc(my-windowSize:my+windowSize,mx-windowSize:mx+windowSize)));
            mmy = sum(sum(repmat([center(1)-windowSize:center(1)+windowSize],2*windowSize+1,1)' .* pc(my-windowSize:my+windowSize,mx-windowSize:mx+windowSize)))/sum(sum(pc(my-windowSize:my+windowSize,mx-windowSize:mx+windowSize)));
            output = [mmx mmy];
    end
else
    output = [-1 -1];
end
if (abs(output(1)) > siz1/3 || abs(output(2)) > siz2/3)
    output = [-1;-1];
end


end


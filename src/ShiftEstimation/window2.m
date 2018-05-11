% This function creates a 2 dimentional window for a sample image, it takes
% the dimension of the window and applies the 1D window function
% This is does NOT using a rotational symmetric method to generate a 2 window
%
% Disi A ---- May,16, 2013
%     [N,M]=size(imgage);
% ---------------------------------------------------------------------
%     w_type is defined by the following 
%     @bartlett       - Bartlett window.
%     @barthannwin    - Modified Bartlett-Hanning window. 
%     @blackman       - Blackman window.
%     @blackmanharris - Minimum 4-term Blackman-Harris window.
%     @bohmanwin      - Bohman window.
%     @chebwin        - Chebyshev window.
%     @flattopwin     - Flat Top window.
%     @gausswin       - Gaussian window.
%     @hamming        - Hamming window.
%     @hann           - Hann window.
%     @kaiser         - Kaiser window.
%     @nuttallwin     - Nuttall defined minimum 4-term Blackman-Harris window.
%     @parzenwin      - Parzen (de la Valle-Poussin) window.
%     @rectwin        - Rectangular window.
%     @taylorwin      - Taylor window.
%     @tukeywin       - Tukey window.
%     @triang         - Triangular window.
%
%   Example: 
%   To compute windowed 2D fFT
%   [r,c]=size(img);
%   w=window2(r,c,@hamming);
% 	fft2(img.*w);

function w=window2(N,M,w_func, cutOff)

if N == M
    if nargin < 4 || isempty(cutOff)
        w1 = window(w_func, N);
    else
        w1 = window(w_func, N, cutOff);
    end
    w = w1*w1';
else
    if nargin < 4 || isempty(cutOff)
        wc=window(w_func,N);
        wr=window(w_func,M);
    else    
        wc=window(w_func,N, cutOff);
        wr=window(w_func,M, cutOff);
    end
    [maskr,maskc]=meshgrid(wr,wc);
    w=maskr.*maskc;
end

end


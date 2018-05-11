function B = vektet_median(A,w,windowSize)
% Input
%   A       Input matrix
%   w01     Matrix of weighted functions
%   Window  Size of window
%
% Output
%   B       Weighted result


halfWindow = floor(windowSize/2);

% INITIALIZING SIGMOID FUNCTION FOR WEIGHTS
b = 0.01;
x = 0:b:1;
% Sigmoid function
y = sigmf(x,[400 0.25]);
% % Step function
% y = sigmf(x,[400 0.05]);

figure, plot(x,y), title('weight function');

% ADD ROBUSTNESS BY INCREASING W, MAKING ITS SIZE EQUAL TO B
w_padded = padarray(w,[size(A,1)-size(w,1) size(A,2)-size(w,2)]); 

% PREALLOCATION OF B
B = zeros(size(A));

for i = halfWindow+1:size(A,1)-halfWindow
    % i PRINTS ROW NUMBER
    for j = halfWindow+1:size(A,2)-halfWindow
        w_window = w_padded(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);    % Henter ut vindu fra w
        
        % ALL NUMBERS ARE CHANGED TO POSITIVE 
        if min(w_window(:)) < 0 && max(w_window(:)) <= 0
            w_window = (w_window+abs(min(w_window(:))));
            % LINEAR NORMALIZATION BETWEEN 0 AND 1
            w01_window = w_window/max(w_window(:));
        elseif min(w_window(:)) < 0 && max(w_window(:)) > 0
            w_window = (w_window+min(w_window(:)))/max(w_window(:));
            % LINEAR NORMALIZATION BETWEEN 0 og 1
            w01_window = w_window/max(w_window(:));
        elseif min(w_window(:)) == 0 && max(w_window(:)) == 0
            % NO NORMALIZATION. THE WINDOWVALUES ARE 0
            w01_window = w_window; 
        end
        % S-FUNCTION
        w01_window = y(floor(w01_window*1/b)+1);

        % THE WEIGHTFUNCTION
        window = w01_window.*double(A(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow));
        
        % THE MEDIAN OF THE WEIGHTED WINDOW
        B(i,j) = median(window(:)); 
    end
end
end

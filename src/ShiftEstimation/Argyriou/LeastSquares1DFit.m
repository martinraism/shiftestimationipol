function [output] = LeastSquares1DFit(b, magnitudesF, magnitudesG)
    R = 0.6 * length(magnitudesF) /2;
    N = length(magnitudesF);
    if (mod(N,2) == 0)
        freqs = [-N/2:N/2-1];
    else
        freqs = [-(N-1)/2:(N-1)/2];
    end
    % Mask out spectral compnents that lie outside a radius of R from the
    % central peak.
    freqsToSkip = false(size(b));
    freqsToSkip(abs(freqs) > floor(R)) = true;
    freqsToSkip(abs(freqs) <= 2) = true;
    freqsSkip = freqsToSkip;

%     pct = prctile(magnitudesF(~freqsToSkip), 60);
%     freqsSkip(magnitudesF < pct) = true;
%     pct = prctile(magnitudesG(~freqsSkip), 60);
%     freqsSkip(magnitudesG < pct) = true;
    freqsToKeep = ~freqsSkip;
    freqsToUse = freqs(freqsToKeep);
    bToUse = b(freqsToKeep);
    A = [freqsToUse'];
    output = sum(A.*bToUse')/sum(A.^2) * length(magnitudesF) / (2*pi);
end
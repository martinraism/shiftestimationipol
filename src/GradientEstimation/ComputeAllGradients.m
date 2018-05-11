function [ gradientsX, gradientsY, durations] = ComputeAllGradients( u )
    durations = [];
    tic; [dxFDVST, dyFDVST] = CalculateGradientByType(u, 'BD'); durations(end+1) = toc;
    %tic; [dxFDVST2, dyFDVST2] = CalculateGradientByType(u, 'BD2'); durations(end+1) = toc;
    tic; [dxFDVST3, dyFDVST3] = CalculateGradientByType(u, 'CENTER3'); durations(end+1) = toc;
    tic; [dxFDVST4, dyFDVST4] = CalculateGradientByType(u, 'CENTER2'); durations(end+1) = toc;
    tic; [dxFDVST5, dyFDVST5] = CalculateGradientByType(u, 'CENTER1'); durations(end+1) = toc;
    tic; [dxCH1, dyCH1] = CalculateGradientByType(u, 'CHRISTMAS1'); durations(end+1) = toc;
    tic; [dxCH2, dyCH2] = CalculateGradientByType(u, 'CHRISTMAS2'); durations(end+1) = toc;
    tic; [dxCH3, dyCH3] = CalculateGradientByType(u, 'CHRISTMAS3'); durations(end+1) = toc;
    tic; [dxFAR3, dyFAR3] = CalculateGradientByType(u, 'FARID3'); durations(end+1) = toc;
    tic; [dxFAR5, dyFAR5] = CalculateGradientByType(u, 'FARID5'); durations(end+1) = toc;
    tic; [dxFAR7, dyFAR7] = CalculateGradientByType(u, 'FARID7'); durations(end+1) = toc;
    tic; [dxSIMO3, dySIMO3] = CalculateGradientByType(u, 'SIMO3'); durations(end+1) = toc;
    tic; [dxSIMO5, dySIMO5] = CalculateGradientByType(u, 'SIMO5'); durations(end+1) = toc;
    tic; [dxHASTCUBIC, dyHASTCUBIC] = CalculateGradientByType(u, 'HASTCUBIC'); durations(end+1) = toc;
    tic; [dxHASTCR, dyHASTCR] = CalculateGradientByType(u, 'HASTCATMULLROM'); durations(end+1) = toc;
    tic; [dxHASTBEZ, dyHASTBEZ] = CalculateGradientByType(u, 'HASTBEZIER'); durations(end+1) = toc;
    tic; [dxHASTBSPLINE, dyHASTBSPLINE] = CalculateGradientByType(u, 'HASTBSPLINE'); durations(end+1) = toc;
    tic; [dxHASTTRIG, dyHASTTRIG] = CalculateGradientByType(u, 'HASTTRIGONOMETRIC'); durations(end+1) = toc;

    gradientsX = {dxFDVST,dxFDVST3,dxFDVST4,dxFDVST5,dxCH1,dxCH2,dxCH3,dxFAR3,...
        dxFAR5,dxFAR7,dxSIMO3,dxSIMO5,dxHASTCUBIC,dxHASTCR,dxHASTBEZ, ...
        dxHASTBSPLINE,dxHASTTRIG};
    gradientsY = {dyFDVST,dyFDVST3,dyFDVST4,dyFDVST5,dyCH1,dyCH2,dyCH3,dyFAR3,...
        dyFAR5,dyFAR7,dySIMO3,dySIMO5,dyHASTCUBIC,dyHASTCR,dyHASTBEZ, ...
        dyHASTBSPLINE,dyHASTTRIG};
end


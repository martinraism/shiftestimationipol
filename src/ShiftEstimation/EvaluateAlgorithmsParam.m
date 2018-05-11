function [qtyMethods, methods, RMSE, results, durations] = EvaluateAlgorithmsParam(u, v, uClean, vClean, shift, sigma2, a, methodsToUse)
    scalesQtys = [2,3,4];
    scalesQtysSDF = [5,6,7];
    N_for_SDF = [2,3,4];
    itQtys = [1,2,3,4];
    intMethods = {'bilinear', 'bicubic', 'spline', 'FFT', 'DCT'};
    intMethodsShort = {'l', 'c', 's', 'f', 'd'};
    gradientTypes = {'BD', 'CENTER3', 'CENTER2', 'CENTER1', 'CHRISTMAS1', ...
        'CHRISTMAS2', 'CHRISTMAS3', 'FARID3', 'FARID5', 'FARID7', ...   
        'SIMO3', 'SIMO5', 'HASTCUBIC', 'HASTCATMULLROM', 'HASTBEZIER', ...
        'HASTBSPLINE', 'HASTTRIGONOMETRIC'};
    gradientTypesShort = {'h', 'g1', 'g0.6', 'g0.3', 'ch1', 'ch2', 'ch3', ...
        'fa3', 'fa5', 'fa7', 'sim3', 'sim5', 'spC', 'spCR', 'spBez', 'spBSp', 'spTrig'};
    
    gradientTypesArgyriou = {'ch1', 'ch2', 'ch3', 'bd', 'sobel', 'g0.3', 'g0.6', 'g1'};
    
    windowsShort = {'nw', 'ex', 'bm', 'bh', 'bl', 'bw', 'cw', 'gw', 'hw', 'tw', 'ft'};
    windows = {'none','extend', 'blackman', 'blackmanHarris', 'bartlett', 'barthannwin', 'chebwin', 'gausswin','hamming', 'tukeywin','flattop'};
    methods = cell(0);
    for scalesIt = scalesQtysSDF
        for i=N_for_SDF
            name = sprintf('MSSDF-S%dN%d', scalesIt, i);
            methods{end+1} = name;
        end
    end
    methods{end+1} = 'SDF-2QI';
    methods{end+1} = 'ADF-2QI';
    methods{end+1} = 'ADF2-2QI';
    methods{end+1} = 'CFI-2QI';
    methods{end+1} = 'SDF-1QI';
    methods{end+1} = 'ADF-1QI';
    methods{end+1} = 'ADF2-1QI';
    methods{end+1} = 'CFI-1QI';
    methods{end+1} = 'SDF-2LS';
    methods{end+1} = 'ADF-2LS';
    methods{end+1} = 'ADF2-2LS';
    methods{end+1} = 'CFI-2LS';
    methods{end+1} = 'SDF-1LS';
    methods{end+1} = 'ADF-1LS';
    methods{end+1} = 'ADF2-1LS';
    methods{end+1} = 'CFI-1LS';
    methods{end+1} = 'MICHAU-1';
    methods{end+1} = 'MICHAU-2';
    methods{end+1} = 'MICHAU-3';
    methods{end+1} = 'MICHAU-ALL';
    methods{end+1} = 'POYNEER';
    methods{end+1} = 'POYNEER-W1';
    methods{end+1} = 'POYNEER-W2';
    methods{end+1} = 'POYNEER-W3';
    methods{end+1} = 'POYNEER-W4';
    methods{end+1} = 'POYNEER-W5';
    methods{end+1} = 'KNUTSSON1';
    methods{end+1} = 'KNUTSSON2';
    methods{end+1} = 'KNUTSSON1-W1';
    methods{end+1} = 'KNUTSSON1-W2';
    methods{end+1} = 'KNUTSSON1-W3';
    methods{end+1} = 'KNUTSSON1-W4';
    methods{end+1} = 'KNUTSSON1-W5';
    methods{end+1} = 'KNUTSSON2-W1';
    methods{end+1} = 'KNUTSSON2-W2';
    methods{end+1} = 'KNUTSSON2-W3';
    methods{end+1} = 'KNUTSSON2-W4';
    methods{end+1} = 'KNUTSSON2-W5';
    
    methods{end+1} = 'ACC-0.0001';
    methods{end+1} = 'ACC-0.001';
    methods{end+1} = 'ACC-0.01';
    methods{end+1} = 'ACC-3It';
    methods{end+1} = 'ACC-2It';
    methods{end+1} = 'ACC-1It';

    methods{end+1} = 'APC-0.0001';
    methods{end+1} = 'APC-0.001';
    methods{end+1} = 'APC-0.01';
    methods{end+1} = 'APC-3It';
    methods{end+1} = 'APC-2It';
    methods{end+1} = 'APC-1It';

    for itIterator = itQtys
        for intIterator = 1:length(intMethods)
            for gradIterator = 1:length(gradientTypes)
                if (itIterator == 1 && intIterator ~= 1)
                    continue;
                end
                gradientMethod = gradientTypesShort{gradIterator};
                intMethod = intMethodsShort{intIterator};
                name = sprintf('LS-%d-I%sG%s', itIterator, intMethod, gradientMethod);
                methods{end+1} = name;
                name = sprintf('TLS-%d-I%sG%s', itIterator, intMethod, gradientMethod);
                methods{end+1} = name;
                name = sprintf('LS-%d-I%sG%sORIGRAD', itIterator, intMethod, gradientMethod);
                methods{end+1} = name;
                name = sprintf('LS-%d-I%sG%sORIIMAGE', itIterator, intMethod, gradientMethod);
                methods{end+1} = name;
                name = sprintf('CLS-%d-I%sG%s', itIterator, intMethod, gradientMethod);
                methods{end+1} = name;
                name = sprintf('CLS-%d-I%sG%sORISIGMA', itIterator, intMethod, gradientMethod);
                methods{end+1} = name;
                
            end
        end
    end


    for gradIterator = 1:length(gradientTypes)
        gradientMethod = gradientTypesShort{gradIterator};
%         name = sprintf('ULS1G%s', gradientMethod);
%         methods{end+1} = name;
        name = sprintf('ULS-G%s', gradientMethod);
        methods{end+1} = name;
    end
    
    for itScale = scalesQtys
        for itIterator = itQtys
            for intIterator = 1:length(intMethods)
                for gradIterator = 1:length(gradientTypes)
                    if (itIterator == 1 && intIterator ~= 1)
                        continue;
                    end
                    gradientMethod = gradientTypesShort{gradIterator};
                    intMethod = intMethodsShort{intIterator};
                    name = sprintf('MS-%d-LS%d-I%sG%s', itScale, itIterator, intMethod, gradientMethod);
                    methods{end+1} = name;
                end
            end
        end
    end
    
    for itIterator = 2:3
        for intIterator = 3:5
            for gradIterator = 1:length(gradientTypes)
                gradientMethod = gradientTypesShort{gradIterator};
                intMethod = intMethodsShort{intIterator};
                name = sprintf('MS-2,%d1-I%scG%s', itIterator, intMethod, gradientMethod);
                methods{end+1} = name;
            end
        end
    end

    for intIterator = 3:5
        for gradIterator = 1:length(gradientTypes)
            gradientMethod = gradientTypesShort{gradIterator};
            intMethod = intMethodsShort{intIterator};
            name = sprintf('MS-3,321-I%sssG%s', intMethod, gradientMethod);
            methods{end+1} = name;
        end
    end
    
    for intIterator = 3:5
        for gradIterator = 1:length(gradientTypes)
            gradientMethod = gradientTypesShort{gradIterator};
            intMethod = intMethodsShort{intIterator};
            name = sprintf('MS-4,4321-I%sssssG%s', intMethod, gradientMethod);
            methods{end+1} = name;
        end
    end

    for intIterator = 3:5
        for gradIterator = 1:length(gradientTypes)
            gradientMethod = gradientTypesShort{gradIterator};
            intMethod = intMethodsShort{intIterator};
            name = sprintf('MS-5,54321-I%sssssG%s', intMethod, gradientMethod);
            methods{end+1} = name;
        end
    end

    for i=1:length(windowsShort)
        name = sprintf('PCSTONE-W%s', windowsShort{i});
        methods{end+1} = name;
        name = sprintf('PCSTONE-2-W%s', windowsShort{i});
        methods{end+1} = name;
        name = sprintf('PC-SINC-W%s', windowsShort{i});
        methods{end+1} = name;
        name = sprintf('PC-ESINC-W%s', windowsShort{i});
        methods{end+1} = name;
        name = sprintf('PC-REN2010-W%s', windowsShort{i});
        methods{end+1} = name;
        name = sprintf('SS-HOGE-W%s', windowsShort{i});
        methods{end+1} = name;
        name = sprintf('SS-REN2014-W%s', windowsShort{i});
        methods{end+1} = name;
        name = sprintf('SS-ROBINSON-W%s', windowsShort{i});
        methods{end+1} = name;
    end

    methods{end+1} = 'INT-2';
    methods{end+1} = 'INT-3';
    methods{end+1} = 'INT-4';
    methods{end+1} = 'INT-5';
    
    
    for i = 1:length(gradientTypesArgyriou)
        name = sprintf('GC11-G%s', gradientTypesArgyriou{i});
        methods{end+1} = name;
        name = sprintf('NGC11-G%s', gradientTypesArgyriou{i});
        methods{end+1} = name;
        name = sprintf('GC04-G%s', gradientTypesArgyriou{i});
        methods{end+1} = name;
        name = sprintf('NGC04-G%s', gradientTypesArgyriou{i});
        methods{end+1} = name;
        name = sprintf('GC04v2-G%s', gradientTypesArgyriou{i});
        methods{end+1} = name;
        name = sprintf('NGC04v2-G%s', gradientTypesArgyriou{i});
        methods{end+1} = name;
    end

    
    methods{end+1} = 'PCFOO';
    methods{end+1} = 'PC-SINC-NOINVARIANCE';
    methods{end+1} = 'PC-ESINC-ORIGINAL';
    

    methods{end+1} = 'PC-LCM-1D1';
    methods{end+1} = 'PC-LCM-1D2';
    methods{end+1} = 'PC-LCM-2D1';
    methods{end+1} = 'PC-LCM-2D2';
    methods{end+1} = 'PC-QUADFIT';
    methods{end+1} = 'PC-GAUSSFIT';
    methods{end+1} = 'PC-GUIZAR-10';
    methods{end+1} = 'PC-GUIZAR-100';
    methods{end+1} = 'PC-GUIZAR-1000';
    methods{end+1} = 'PC-GUIZAR-2000';
    
    methods{end+1} = 'DIRNLOL';
    methods{end+1} = 'DIRNLOC';
    methods{end+1} = 'DIRNLOS';
    methods{end+1} = 'SYMNLOL';
    methods{end+1} = 'SYMNLOC';
    methods{end+1} = 'SYMNLOS';
    
    
    qtyMethods = numel(methods);
    if (isempty(u))
        RMSE = [];
        results = [];
        durations = [];
        return;
    elseif (~isempty(methodsToUse))
        methods = methods(methodsToUse);
    end
    
    RMSE = zeros(0,1);
    durations = zeros(0,1);
    results = zeros(0,2);
    step = 1;
    if (~isempty(uClean))
        [dxFDNoNoise, dyFDNoNoise] = CalculateGradientByType(uClean, 'BD');
        [ gradientsXClean, gradientsYClean] = ComputeAllGradients( uClean );
    end
    
%gradientTypesShort = {'h', 'g1', 'g0.6', 'g0.3', 'ch1', 'ch2', 'ch3', 'fa3', 'fa5', 'fa7', 'sim3', 'sim5', 'spC', 'spCR', 'spBez', 'spBSp', 'spTrig'};

    [ gradientsX, gradientsY, durGrads] = ComputeAllGradients( u );
%     for i=1:length(durGrads)
%         fprintf('grad: %s (%.5fs)\n', gradientTypes{i}, durGrads(i));
%     end
    counter = 0;


    for scalesIt = scalesQtysSDF
        for i=N_for_SDF
            counter = counter + 1;
            if (methodsToUse(counter))
                tic;
                [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionMultiscaleSDF(u, v, i, scalesIt));
                durations(end+1) = toc;
            end
        end
    end

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v,'SDF','2QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF','2QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF2','2QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'CFI','2QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1; 
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v,'SDF','1QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF','1QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF2','1QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'CFI','1QI'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v,'SDF','2LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF','2LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF2','2LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'CFI','2LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1; 
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v,'SDF','1LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF','1LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'ADF2','1LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionSDF(u, v, 'CFI','1LS'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter) || methodsToUse(counter+1) || methodsToUse(counter+2) || methodsToUse(counter+3))
        ccorr = xcorr2(u,v);
    end
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationMichaud(u, v, 1,false, ccorr));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationMichaud(u, v, 2, false, ccorr));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationMichaud(u, v, 3, false, ccorr));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationMichaud(u, v, 1, true, ccorr));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPoyneer(u, v, 'none'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPoyneer(u, v, 'blackman'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPoyneer(u, v, 'blackmanHarris'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPoyneer(u, v, 'flattop'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPoyneer(u, v, 'hamming'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPoyneer(u, v, 'tukeywin'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'none', 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'none', 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'blackman', 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'blackmanHarris', 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'flattop', 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'hamming', 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'tukeywin', 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'blackman', 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'blackmanHarris', 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'flattop', 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'hamming', 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationKnutsson(u, v, 'tukeywin', 2));
        durations(end+1) = toc;
    end

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationACC(u, v,0.0001, 30));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationACC(u, v,0.001, 15));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationACC(u, v,0.01, 10));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationACC(u, v,0.0001, 3));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationACC(u, v,0.0001, 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationACC(u, v,0.0001, 1));
        durations(end+1) = toc;
    end
    

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPCC(u, v,0.0001, 30));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPCC(u, v,0.001, 15));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPCC(u, v,0.01, 10));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPCC(u, v,0.0001, 3));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPCC(u, v,0.0001, 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionUsingCorrelationPCC(u, v,0.0001, 1));
        durations(end+1) = toc;
    end
    dx = gradientsX{1}; dy = gradientsY{1};
    [res] = CalculateTransitionBetweenFramesTLS2(u, v, dx, dy, 'BD', 1, 'bilinear', false, step);
    
    for itIterator = itQtys
        for intIterator = 1:length(intMethods)
            for gradIterator = 1:length(gradientTypes)
                if (itIterator == 1 && intIterator ~= 1)
                    continue;
                end
                dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
                gradientMethod = gradientTypes{gradIterator};
                intMethod = intMethods{intIterator};
                if (~isempty(uClean) && ~isempty(gradientsXClean))
                    dxClean = gradientsXClean{gradIterator}; dyClean = gradientsYClean{gradIterator};
                end
                counter = counter + 1;
                if (methodsToUse(counter))
                    tic;
                    [res] = CalculateTransitionBetweenFramesTLS2(u, v, dx, dy, gradientMethod, itIterator, intMethod, false, step);
                    [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
                    durations(end+1) = toc;
                end
                counter = counter + 1;
                if (methodsToUse(counter))
                    tic;
                    [res] = CalculateTransitionBetweenFramesTLS2(u, v, dx, dy, gradientMethod, itIterator, intMethod, true, step);
                    [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
                    durations(end+1) = toc;
                end
                counter = counter + 1;
                if (methodsToUse(counter))
                    if (~isempty(dxClean) && ~isempty(dyClean))
                        tic;
                        [res] = CalculateTransitionBetweenFramesTLS2(u, v, dxClean, dyClean, gradientMethod, itIterator, intMethod, false, step);
                        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
                        durations(end+1) = toc;
                    else
                        RMSE(end+1) = Inf;
                        results(end+1,:) = [-1;-1];
                        durations(end+1) = Inf;
                    end
                end
                counter = counter + 1;
                if (methodsToUse(counter))
                    if (~isempty(uClean) && ~isempty(vClean))
                        tic;
                        [res] = CalculateTransitionBetweenFramesTLS2(uClean, vClean, dxClean, dyClean, gradientMethod, itIterator, intMethod, false, step);
                        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
                        durations(end+1) = toc;
                    else
                        RMSE(end+1) = Inf;
                        results(end+1,:) = [-1;-1];
                        durations(end+1) = Inf;
                    end
                end
                counter = counter + 1;
                if (methodsToUse(counter))
                    tic;
                    [res] = CalculateCompensatedTransitionBetweenFrames(u, v, dx, dy, gradientMethod, itIterator, intMethod, step, sigma2);
                    [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
                    durations(end+1) = toc;
                end                
                counter = counter + 1;
                if (methodsToUse(counter))
                    tic;
                    [res] = CalculateCompensatedTransitionBetweenFrames(u, v, dx, dy, gradientMethod, itIterator, intMethod, step, a^2);
                    [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
                    durations(end+1) = toc;
                end                
            end
        end
    end


    for gradIterator = 1:length(gradientTypes)
        dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
        gradientMethod = gradientTypes{gradIterator};
%         counter = counter + 1;
%         if (methodsToUse(counter))
%             tic;
%             [res] = CalculateUnbiasedTransitionBetweenFrames(u, v, dx, dy, gradientMethod);
%             [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
%             durations(end+1) = toc;
%         end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [res] = CalculateUnbiasedTransitionBetweenFrames2(u, v, dx, dy, gradientMethod);
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
            durations(end+1) = toc;
        end
    end
%     for gradIterator = 1:length(gradientTypes)
%         counter = counter + 1;
%         if (methodsToUse(counter))
%             dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
%             gradientMethod = gradientTypes{gradIterator};
%             tic;
%             [res] = CalculateSmartUnbiasedTransitionBetweenFrames(u, v, dx, dy, gradientMethod);
%             [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
%             durations(end+1) = toc;
%         end
%     end

    for itScale = scalesQtys
        for itIterator = itQtys
            for intIterator = 1:length(intMethods)
                for gradIterator = 1:length(gradientTypes)
                    if (itIterator == 1 && intIterator ~= 1)
                        continue;
                    end
                    counter = counter + 1;
                    if (methodsToUse(counter))
                        dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
                        gradientMethod = gradientTypes{gradIterator};
                        intMethod = intMethods{intIterator};
                        tic;
                        res = CalculateExtendedTransitionWithResampling(u, v, dx, dy, gradientMethod, itIterator, intMethod, false, 1, itScale);
                        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
                        durations(end+1) = toc;
                    end
                end
            end
        end
    end

    for itIterator = 2:3
        for intIterator = 3:5
            for gradIterator = 1:length(gradientTypes)
                counter = counter + 1;
                if (methodsToUse(counter))
                    dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
                    gradientMethod = gradientTypes{gradIterator};
                    intMethod = intMethods{intIterator};
                    tic;
                    res = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dx, dy, gradientMethod, [itIterator,1], {intMethod,'bicubic'}, [false,false], 1, 2);
                    [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res(1,:));
                    durations(end+1) = toc;
                end
            end
        end
    end
    
    for intIterator = 3:5
        for gradIterator = 1:length(gradientTypes)
            counter = counter + 1;
            if (methodsToUse(counter))
                dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
                gradientMethod = gradientTypes{gradIterator};
                intMethod = intMethods{intIterator};
                tic;
                res = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dx, dy, gradientMethod, [3,2,1], {intMethod,'spline','spline'}, [false,false, false], 1, 3);
                [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res(1,:));
                durations(end+1) = toc;
            end
        end
    end
    for intIterator = 3:5
        for gradIterator = 1:length(gradientTypes)
            counter = counter + 1;
            if (methodsToUse(counter))
                dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
                gradientMethod = gradientTypes{gradIterator};
                intMethod = intMethods{intIterator};
                tic;
                res = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dx, dy, gradientMethod, [4,3,2,1], {intMethod,'spline','spline','spline'}, [false, false, false,false], 1, 4);
                [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res(1,:));
                durations(end+1) = toc;
            end
        end
    end
    for intIterator = 3:5
        for gradIterator = 1:length(gradientTypes)
            counter = counter + 1;
            if (methodsToUse(counter))
                dx = gradientsX{gradIterator}; dy = gradientsY{gradIterator};
                gradientMethod = gradientTypes{gradIterator};
                intMethod = intMethods{intIterator};
                tic;
                res = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dx, dy, gradientMethod, [5,4,3,2,1], {intMethod,'spline','spline','spline','spline'}, [false, false, false,false, false], 1, 5);
                [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res(1,:));
                durations(end+1) = toc;
            end
        end
    end
    
% 
%     counter = counter + 1;
%     if (methodsToUse(counter))
%         tic;    
%         output = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dxFDVST, dyFDVST, 'BD', [4,3,2,1], {'spline','spline', 'spline','spline'}, [false,false,false,false], 1, 4);
%         [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, output(1,:));
%         durations(end+1) = toc;
%     end
%     counter = counter + 1;
%     if (methodsToUse(counter))
%         tic;    
%         output = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dxFDVST, dyFDVST, 'BD', [4,3,2,1], {'FFT','FFT', 'FFT','FFT'}, [false,false,false,false], 1, 4);
%         [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, output(1,:));
%         durations(end+1) = toc;
%     end
%     counter = counter + 1;
%     if (methodsToUse(counter))
%         tic;    
%         output = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dxFDVST, dyFDVST, 'BD', [4,3,2,1], {'DCT','DCT', 'DCT','DCT'}, [false,false,false,false], 1, 4);
%         [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, output(1,:));
%         durations(end+1) = toc;
%     end
%     counter = counter + 1;
%     if (methodsToUse(counter))
%         tic;    
%         output = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dxFDVST, dyFDVST, 'BD', [5,4,3,2,1], {'spline', 'spline','spline', 'spline','spline'}, [false,false,false,false, false], 1, 5);
%         [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, output(1,:));
%         durations(end+1) = toc;
%     end
%     counter = counter + 1;
%     if (methodsToUse(counter))
%         tic;    
%         output = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dxFDVST, dyFDVST, 'BD', [5,4,3,2,1], {'DCT', 'DCT','DCT', 'DCT','DCT'}, [false,false,false,false, false], 1, 5);
%         [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, output(1,:));
%         durations(end+1) = toc;
%     end
%     counter = counter + 1;
%     if (methodsToUse(counter))
%         tic;    
%         output = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dxFDVST4, dyFDVST4, 'CENTER2', [5,4,3,2,1], {'spline', 'spline','spline', 'spline','spline'}, [false,false,false,false, false], 1, 5);
%         [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, output(1,:));
%         durations(end+1) = toc;
%     end
%     counter = counter + 1;
%     if (methodsToUse(counter))
%         tic;    
%         output = CalculateExtendedTransitionWithResamplingConfigurable(u, v, dxFDVST4, dyFDVST4, 'CENTER2', [5,4,3,2,1], {'DCT', 'DCT','DCT', 'DCT','DCT'}, [false,false,false,false, false], 1, 5);
%         [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, output(1,:));
%         durations(end+1) = toc;
%     end    

    for i=1:length(windowsShort)
        window = windows{i};
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [res] = CalculateTransitionBetweenFramesStone(u, v, window);
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [res] = CalculateTransitionBetweenFramesStone2(u, v, window);
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 1, window));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 2, window));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 6, window));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateTransitionBetweenFramesHoge(u, v, window));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesREN2014(u, v, 7, window));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesSubspace(u, v, window));
            durations(end+1) = toc;
        end
    end

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [res] = CalculateTransitionBetweenFramesInterpolation(u, v, 2);
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [res] = CalculateTransitionBetweenFramesInterpolation(u, v, 3);
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [res] = CalculateTransitionBetweenFramesInterpolation(u, v, 4);
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [res] = CalculateTransitionBetweenFramesInterpolation(u, v, 5);
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, res);
        durations(end+1) = toc;
    end
    
    for gradType = 1:length(gradientTypesArgyriou)
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGC2011(u, v, gradType, 1));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGC2011(u, v, gradType, 3));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGC2004(u, v, gradType, 1));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGC2004(u, v, gradType, 2));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGC2004(u, v, gradType, 3));
            durations(end+1) = toc;
        end
        counter = counter + 1;
        if (methodsToUse(counter))
            tic;
            [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGC2004(u, v, gradType, 4));
            durations(end+1) = toc;
        end
    end

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 3, 'blackmanHarris'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 4, 'blackmanHarris'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 5, 'blackmanHarris'));
        durations(end+1) = toc;
    end
    
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesLCM(u, v, [], 1, 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesLCM(u, v, [], 2, 1));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesLCM(u, v, [], 1, 2));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesLCM(u, v, [], 2, 2));
        durations(end+1) = toc;
    end

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 8, 'blackmanHarris'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesPC2006(u, v, 7, 'blackmanHarris'));
        durations(end+1) = toc;
    end
    
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGuizar(u, v, 10));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGuizar(u, v, 100));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGuizar(u, v, 1000));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateExtendedTransitionBetweenFramesGuizar(u, v, 2000));
        durations(end+1) = toc;
    end

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateTransitionBetweenFramesDirectNLO( u, v, 'bilinear'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateTransitionBetweenFramesDirectNLO( u, v, 'bicubic'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateTransitionBetweenFramesDirectNLO( u, v, 'spline'));
        durations(end+1) = toc;
    end

    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateTransitionBetweenFramesSymmetricNLO( u, v, 'bilinear'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateTransitionBetweenFramesSymmetricNLO( u, v, 'bicubic'));
        durations(end+1) = toc;
    end
    counter = counter + 1;
    if (methodsToUse(counter))
        tic;
        [RMSE(end+1), results(end+1,:)] = EvaluateError(shift, CalculateTransitionBetweenFramesSymmetricNLO( u, v, 'spline'));
        durations(end+1) = toc;
    end

end

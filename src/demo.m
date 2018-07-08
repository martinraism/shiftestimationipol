%warning('off', 'images:initSize:adjustingMag');
function [] = demo(im1File, im2File, outputPath, additionalFilesPath)
im1 = imread(im1File); im2 = imread(im2File);
if (size(im1,3) == 3)
    im1 = double(rgb2gray(im1));
else
    im1 = double(im1);
end
if (size(im2,3) == 3)
    im2 = double(rgb2gray(im2));
else
    im2 = double(im2);
end
%ShowTwoImagesSuperposed(im1, im2);

% Registration
[~, methods] = EvaluateAlgorithmsParam([], [], [], [], [], [], [], []);
%methodsToUse = true(1, length(methods));
% All methods involving ground truth values (obtained by simulation) are
% removed
%methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'ORIGRAD'));
%methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'ORIIMAGE'));
%methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'ORISIGMA'));

methodsToUse = false(1, length(methods));
methodsToUse = methodsToUse | strcmp(methods,'LS-1-IlGfa7');
methodsToUse = methodsToUse | strcmp(methods,'ULS-Gsim3');
methodsToUse = methodsToUse | strcmp(methods,'MS-2-LS4-IsGg0.6');
methodsToUse = methodsToUse | strcmp(methods,'MS-2,31-IfcGsim3');
methodsToUse = methodsToUse | strcmp(methods,'MS-3,321-IsssGfa3');
methodsToUse = methodsToUse | strcmp(methods,'MS-3,321-IfssGg0.6');
methodsToUse = methodsToUse | strcmp(methods,'MS-4,4321-IsssssGch1');
methodsToUse = methodsToUse | strcmp(methods,'MS-5,54321-IdssssGch1');
methodsToUse = methodsToUse | strcmp(methods,'PC-SINC-Wnw');
methodsToUse = methodsToUse | strcmp(methods,'PC-SINC-Wex');
methodsToUse = methodsToUse | strcmp(methods,'PCSTONE-Wtw');
methodsToUse = methodsToUse | strcmp(methods,'PC-SINC-Wtw');
methodsToUse = methodsToUse | strcmp(methods,'PC-ESINC-Wtw');
methodsToUse = methodsToUse | strcmp(methods,'PC-REN2010-Wtw');
methodsToUse = methodsToUse | strcmp(methods,'SS-HOGE-Wtw');
methodsToUse = methodsToUse | strcmp(methods,'INT-3');
methodsToUse = methodsToUse | strcmp(methods,'GC11-Gg0.3');
methodsToUse = methodsToUse | strcmp(methods,'GC04-Gg0.6');
methodsToUse = methodsToUse | strcmp(methods,'GC04v2-Gg0.6');
methodsToUse = methodsToUse | strcmp(methods,'GC11-Gg1');
methodsToUse = methodsToUse | strcmp(methods,'PC-QUADFIT');
methodsToUse = methodsToUse | strcmp(methods,'PC-GAUSSFIT');
methodsToUse = methodsToUse | strcmp(methods,'PC-GUIZAR-1000');

methodsToUse = methodsToUse | strcmp(methods,'LS-4-IsGg0.6');
methodsToUse = methodsToUse | strcmp(methods,'TLS-1-IlGh');
methodsToUse = methodsToUse | strcmp(methods,'LS-2-IdGfa5');
methodsToUse = methodsToUse | strcmp(methods,'SDF-2QI');
methodsToUse = methodsToUse | strcmp(methods,'TLS-4-IlGg0.6');
methods = methods(methodsToUse);

failedIm = imread([additionalFilesPath '/failed.png']);
failedIm = imresize(failedIm, [size(im2,1), size(im2,2)]);

[~, ~, ~, results, durations] = EvaluateAlgorithmsParam(im1, im2, [], [], [], [], [], methodsToUse);
[h, w] = size(im1);
fileID = fopen([outputPath, 'results.txt'], 'w');

% Check largest method name
largestSize = -1;
for i=1:size(results,1)
    sz = length(methods{i}); 
    if (sz > largestSize)
        largestSize = sz;
    end
end
fprintf(fileID, 'Method%s Estimated Shift (Dx, Dy)\tTime (seconds)\n', [repmat(' ', 1, largestSize - length('Method'))]);
fprintf('Method%s Estimated Shift (Dx, Dy)\tTime (seconds)\n', [repmat(' ', 1, largestSize - length('Method'))]);
for i=1:size(results,1)
    % Approximate GT
    if (~isnan(results(i, 1)) && ~isnan(results(i, 2)) && ~(results(i, 1) == -1 && results(i, 2) == -1) && results(i, 1) < w/2 && results(i,2) < h/2)
        im1R = ResampleImage(im1, -results(i, 1), -results(i, 2), 'spline');
        imdif = abs(im2 - im1R);
        imdif2 = uint8(round(imdif) * 5);
        imwrite(imdif2, [outputPath 'dif_' methods{i} '.png']);
        imwrite(uint8(round(im1R)), [outputPath methods{i} '.png']);
        fprintf('%s (%f,%f) \t%.3f\n', [methods{i} repmat(' ', 1, largestSize - length(methods{i}))] , results(i, 1), results(i, 2), durations(i));
        fprintf(fileID, '%s (%f,%f) \t%.3f\n', [methods{i} repmat(' ', 1, largestSize - length(methods{i}))], results(i, 1), results(i, 2), durations(i));
    else
        imwrite(failedIm, [outputPath 'dif_' methods{i} '.png']);
        imwrite(failedIm, [outputPath methods{i} '.png']);
        fprintf('%s Estimation failed.\n', [methods{i} repmat(' ', 1, largestSize - length(methods{i}))]);
        fprintf(fileID, '%s Estimation failed.\n', [methods{i} repmat(' ', 1, largestSize - length(methods{i}))]);
    end
end
end
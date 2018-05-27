%clearvars;
%close all;
%addpath(genpath('/home/rais/Dropbox/CNES/Code/Utils'))
%addpath(genpath('/home/rais/Dropbox/CNES/Code/ShiftEstimation'))
%addpath(genpath('/home/rais/Dropbox/CNES/Code/GradientEstimation'))
%addpath(genpath('/home/rais/PhD/aransac/vl'))
%warning('off', 'images:initSize:adjustingMag');
function [] = demo(im1File, im2File)
% addpath(genpath('./ShiftEstimation'));
% addpath(genpath('./GradientEstimation'));
% addpath(genpath('./Utils'));
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
% For this demo, the compensated/corrected least squares method is commented 
% out since we do not have (nor want to do) noise estimation 
%methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'CLS'));
% Optimization based methods are also not used because they are expensive
% and not accurate enough
%methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'SYMN'));
%methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'DIRN'));

% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'KNUTSSON'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'MICHAU'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'CLS'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'REN2014'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'SYMN'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'DIRN'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'LS-'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'MS-'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'ACC-'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'APC-'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'PCSTONE'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'POYNEER'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'SDF'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'SS-'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'PC-SINC'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'PC-ESINC'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'PC-REN2010'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'ADF'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'CFI'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'INT'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'PC-GUIZAR'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'PC-LCM'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'PCFOO'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'GC11'));
% methodsToUse = methodsToUse & cellfun(@isempty,strfind(methods,'NGC04'));
% methodsToUse = methodsToUse | strcmp(methods,'PC-ESINC-Wex');
% methodsToUse = methodsToUse | strcmp(methods,'PC-SINC-Wex');
% methodsToUse = methodsToUse | strcmp(methods,'PC-REN2010-Wex');

methodsToUse = false(1, length(methods));
methodsToUse = methodsToUse | strcmp(methods,'PC-SINC-Wex');
methodsToUse = methodsToUse | strcmp(methods,'GC04v2-Gg0.6');
    
methods = methods(methodsToUse);

[~, ~, ~, results, durations] = EvaluateAlgorithmsParam(im1, im2, [], [], [], [], [], methodsToUse);
%resultGT = ResampleImage(imToSearch, 35, -69, 'bicubic'); figure(1); ShowImage(resultGT);
fprintf('\nShift estimation results:\n');
for i=1:size(results,1)
    % Approximate GT
    if (~isnan(results(i, 1)) && ~isnan(results(i, 2)) && ~(results(i, 1) == -1 && results(i, 2) == -1))
        %if (norm(results(i,:) + [35,  -69]) < 4)
%             result = ResampleImage(imToSearch, -results(i, 1), -results(i, 2), 'bicubic');
%             figure(2); ShowImage(result);
            fprintf('Method: %s. [Dx, Dy]: (%f,%f)\n', methods{i}, results(i, 1), results(i, 2));
        %end
    end
end
%methodID = 2;
%H2 = H_GT;
%H2 = H2 / H2(3,3);
%H2(1,3) = H2(1,3) - results(methodID, 1);
%H2(2,3) = H2(2,3) - results(methodID, 2);
%imRes2 = ResampleImageH(imOpt, size(imOptResampled), H2, 1);
%imRes = ResampleImageH(imOptResampled, size(imOptResampled), [1,0,-results(methodID, 1); 0,1,-results(methodID, 2); 0, 0, 1], 1);
%close all;
%figure; ShowImage(imRes); figure; ShowImage(imRes2);

%figure(2); ShowTwoImagesSuperposed(imResampled, imRef, 'superpose');
%[imOptResampled] = ResampleImageH(imToSearch, size(imToSearch), [1,0,-results(methodID, 1); 0,1,-results(methodID, 2); 0, 0, 1], 1);
%result = ResampleImage(imToSearch, -results(1, 1), -results(1, 2), 'bicubic'); 
%figure(2); 
%ShowTwoImagesSuperposed(imRes, imRef, 'superpose');
end
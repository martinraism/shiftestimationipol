tic
clear all
close all
addpath('LucasKanade');
H = fspecial('gaussian',9,2);
%% IMPORTING THE IMAGES AND GROUND TRUTH
% % % % Dimetron
% im01         = rgb2gray(imread('Dimetronframe10.png'));
% im02         = rgb2gray(imread('Dimetronframe11.png'));
% img         = readFlowFile('Dimetrodonflow10.flo');
% load('uv_Dimetron_HiericalLK.mat');
% load('W__Dimetron_HiericalLK.mat');

% % % % % % % Hydrangea
% im01         = rgb2gray(imread('Hydrangeaframe10.png'));
% im02         = rgb2gray(imread('Hydrangeaframe11.png'));
% img = readFlowFile('Hydrangeaflow10.flo');
% load('uv_Hydrangea_HiericalLK.mat');
% load('W__Hydrangea_HiericalLK.mat');

% % % RubberWhale
im01         = rgb2gray(imread('RubberWhaleframe10.png'));
im02         = rgb2gray(imread('RubberWhaleframe11.png'));
img = readFlowFile('RubberWhaleflow10.flo');
load('uv_RW_HiericalLK.mat');
load('W__RW_HiericalLK.mat');

%% STARTING THE PROCESS

% SMOOTH WITH A GAUSSIAN PREFILTER, TO MINIMIZE ERROR
im1=imfilter(im2double(im01),H);
im2=imfilter(im2double(im02),H);

% FIX UNKNOWN FLOW
gtu=img(:,:,1);
gtv=img(:,:,2);
UNKNOWN_FLOW_THRESH = 1e9;
idxUnknown = (abs(gtu)> UNKNOWN_FLOW_THRESH) | (abs(gtv)> UNKNOWN_FLOW_THRESH) ;
gtu(idxUnknown) = 0;
gtv(idxUnknown) = 0;
% figure, imshow(idxUnknown)
img(:,:,1) = gtu;
img(:,:,2) = gtv;

% CALCULATING THE VELOCITIES WITH WEIGHTS ON THE IMAGES WITH WINDOWSIZE (IMAGE1,IMAGE2,WINSWSIZE)
[u, v, w]       = LucasKanadeVektet(im1,im2,15,img);
% [u,v,cert] = HierarchicalLK(im1, im2, 3, 4, 1, 1)
Hu(idxUnknown) = 0;
Hv(idxUnknown) = 0;
u(idxUnknown) = 0;
v(idxUnknown) = 0;

% % DEFINES THE LK-RESULTS 
f(:,:,1)    = u;
f(:,:,2)    = v;

% % % IMPLEMENTING WEIGHTS ON V, BUT NOT U
T(:,:,1)    = u;
T(:,:,2)    = vektet_median(v,w,20);
% % % % % % IMPLEMENTING WEIGHTS ON U, BUT NOT V
% T(:,:,1)    = vektet_median(u,w,15);
% T(:,:,2)    = v;
% % IMPLEMENTING WEIGHTS ON U AND V
% T(:,:,1)    = vektet_median(u,w,15);
% T(:,:,2)    = vektet_median(v,w,20);



HLK(:,:,1) = Hu;
HLK(:,:,2) = Hv;

% % WEIGHTS ON X-DIR
% HLKvektet(:,:,1) = vektet_median(Hu,w,20);
% HLKvektet(:,:,2) = Hv;
% WEIGHTS ON Y-DIR
HLKvektet(:,:,1) = Hu;
HLKvektet(:,:,2) = vektet_median(Hv,w,20);

figure, subplot(1,2,1);plotflow(f); title('The Iterative LK');
subplot(1,2,2);plotflow(T); title('The Weighted Iterative LK');

figure, subplot(1,2,2);plotflow(HLKvektet); title('The Weighted Hierical LK');
subplot(1,2,1);plotflow(HLK); title('The Hierical LK');
%% Pytagoras to calculate length and angle from velocities
% CALCULATING LENGTH AND ANGLE FROM THE VELOCITIES
% Length=sqrt((u).^2+(v).^2); % pytagoras
% Vinkel =(atan(v./u)); % (radianer*180)/pi 
% 
% Median filterer lengden til vektoren med vektingsfunksjonen w
% LengthMedian    = vektet_median(Length,w,15);
% VinkelMedian = Vinkel;


% T(:,:,1)=sqrt(((LengthMedian.^2))./((tan(VinkelMedian)).^2+1));
% T(:,:,2)=sqrt((LengthMedian.^2)-T(:,:,1));
% 
% T(:,:,1)=sqrt((LengthMedian.^2)./(1+(tan(VinkelMedian)).^2));
% T(:,:,2)=T(:,:,1).*tan((VinkelMedian)); 

%% Calculating Endpoint Error and Angular Error
 
% % AVERAGE ANGULAR ERROR
% aaeT = flow_aae(T, img)
aaef = flow_aae(f, img);
aaeHLK=flow_aae(HLK, img);
aaeHLKvektet=flow_aae(HLKvektet, img);
% % AVERAGE ENDPOINT ERROR
% aeeT=sqrt((T(:,:,1)-img(:,:,1)).^2+(T(:,:,2)-img(:,:,2)).^2);
aeef=sqrt((f(:,:,1)-img(:,:,1)).^2+(f(:,:,2)-img(:,:,2)).^2);
aeeHLK=sqrt((HLK(:,:,1)-img(:,:,1)).^2+(HLK(:,:,2)-img(:,:,2)).^2);
aeeHLKvektet=sqrt((HLKvektet(:,:,1)-img(:,:,1)).^2+(HLKvektet(:,:,2)-img(:,:,2)).^2);
% % MEAN ENDPOINT ERROR
% MeanAeeT=mean(real(aeeT(:)));
MeanAeeF=mean(real(aeef(:)));
MeanAeeHLK=mean(real(aeeHLK(:)));
MeanAeeHLKvektet=mean(real(aeeHLKvektet(:)));
% % MEAN ANGULAR ERROR
% MeanAaeT=mean(real(aaeT(:))) * (180 / pi);
MeanAaeF=mean(real(aaef(:))) * (180 / pi);
MeanAaeHLK=mean(real(aaeHLK(:))) * (180 / pi);
MeanAaeHLKvektet=mean(real(aaeHLKvektet(:))) * (180 / pi);

%%
% % COMPARE GROUND TRUTH, ITERATIVE LK-METHOD AND THE WEIGHTED MEDIAN FILTER
figure,
subplot(1,3,1); imshow(flowToColor(img)); title('GroundTruth');
subplot(1,3,2); imshow(flowToColor(HLK)); title('LucasKanade');
subplot(1,3,3); imshow(flowToColor(HLKvektet)); title('Egen vekting');

% % COMPARE THE ERROR OF ITERATIVE LK AND THE WEIGHTED MEDIAN
% figure,
% subplot(2,2,1); imshow(aeef); title('AEE LucasKanade Iterative');
% subplot(2,2,3); imshow(aeeT); title('AEE Iterative 5x5 median');
% subplot(2,2,2); imshow(aaef); title('AAE LucasKanade Iterative');
% subplot(2,2,4); imshow(aaeT); title('AAE Iterative 5x5 median');

% MAKE HISTOGRAM OF THE ERROR
figure,
subplot(2,2,1); hist(aaeHLK); title('AAE LucasKanade Hierical');
subplot(2,2,3); hist(aaeHLKvektet); title('AAE LucasKanade Hierical vektet');
subplot(2,2,2); hist(aeeHLK); title('AEE LucasKanade Hierical');
subplot(2,2,4); hist(aeeHLKvektet); title('AEE LucasKanade Hierical vektet');
% COMPARE THE ERROR OF HIERICAL LK AND THE WEIGHTED MEDIAN
figure,
subplot(2,2,1); imshow(aaeHLK); title('AAE LucasKanade Hierical');
subplot(2,2,3); imshow(aaeHLKvektet); title('AAE LucasKanade Hierical vektet');
subplot(2,2,2); imshow(aeeHLK); title('AEE LucasKanade Hierical');
subplot(2,2,4); imshow(aeeHLKvektet); title('AEE LucasKanade Hierical vektet');

% % PLOT THE ITERATIVE LK METHOD
% figure, subplot(1,2,1); plotflow(f);
% subplot(1,2,2); plotflow(T);

% % PLOT THE WEIGHTED MEDIAN FILTER ON ITERATIVE LK
% figure,
% subplot(1,2,1); imshow(flowToColor(T)); title('Color Coding- LK medfilt Dimetrodon');
% subplot(1,2,2); plotflow(T); title('Vector Plot- LK medfilt Dimetrodon');
toc
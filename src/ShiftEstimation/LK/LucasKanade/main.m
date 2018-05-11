tic
clear all


close all
addpath('LucasKanade');
H = fspecial('gaussian',3,3);

% % % % %Dimetron
% im01         = rgb2gray(imread('Dimetronframe10.png'));
% im02         = rgb2gray(imread('Dimetronframe11.png'));
% img         = readFlowFile('Dimetrodonflow10.flo');

% % % % % % Hydrangea
% im01         = rgb2gray(imread('Hydrangeaframe10.png'));
% im02         = rgb2gray(imread('Hydrangeaframe11.png'));
% img = readFlowFile('Hydrangeaflow10.flo');

% % % % % % RubberWhale
im01         = rgb2gray(imread('RubberWhaleframe10.png'));
im02         = rgb2gray(imread('RubberWhaleframe11.png'));
img = readFlowFile('RubberWhaleflow10.flo');


im1=imfilter(im01,H);
im2=imfilter(im02,H);

% FIX UNKNOWN FLOW
gtu=img(:,:,1);
gtv=img(:,:,2);
UNKNOWN_FLOW_THRESH = 1e9;

idxUnknown = (abs(gtu)> UNKNOWN_FLOW_THRESH) | (abs(gtv)> UNKNOWN_FLOW_THRESH) ;
count=sum(idxUnknown(:));
density=100-(count/(size(im1,1)*size(im1,2))*100);
img(:,:,1) = gtu;
img(:,:,2) = gtv;

% [u,v,w01]       = LucasKanade(im2double(im1),im2double(im2),7);
[u,v,cert] = HierarchicalLK(im2double(im1), im2double(im2), 3, 4, 1, 1);
u(idxUnknown) = 0;
v(idxUnknown) = 0;
% figure, imshow(idxUnknown)
f(:,:,1)    = u;
f(:,:,2)    = v;


figure,hist(u);title('Velocities in x-direction')
figure,hist(v);title('Velocities in y-direction')

       
       %%
% AVERAGE ANGULAR ERROR
aaef = flow_aae(f, img);
% AVERAGE ENDPOINT ERROR
aeef=sqrt((f(:,:,1)-img(:,:,1)).^2+(f(:,:,2)-img(:,:,2)).^2);
% AVERAGE ENDPOINT ERROR
MeanAeeF=mean(real(aeef(:)));
% AVERAGE ANGULAR ERROR
MeanAaeF=mean(real(aaef(:))) * (180 / pi);


%%
% % COMPARE GROUND TRUTH AND LK-METHOD
% figure,
% subplot(2,2,1); imshow(flowToColor(img)); title('GroundTruth');
% subplot(2,2,2); imshow(flowToColor(f)); title('LucasKanade');

% % COMPARE THE ERROR
% figure,
% subplot(1,2,1); imshow(aeef); title('AEE LucasKanade'); title('Endpoint Error');
% subplot(1,2,2); imshow(aaef); title('AAE LucasKanade'); title('Angular Error');

toc
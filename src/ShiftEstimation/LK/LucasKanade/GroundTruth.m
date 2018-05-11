% img = readFlowFile('Dimetrodonflow10')
% img = readFlowFile('Grove2flow10.flo')
% img = readFlowFile('Grove3flow10.flo')
% img = readFlowFile('Hydrangeaflow10.flo')
% img = readFlowFile('RubberWhaleflow10.flo')
% img = readFlowFile('Urban2flow10.flo')
img = readFlowFile('Urban3flow10.flo')

figure
subplot(1,2,1); imshow(flowToColor(img)); title('Color Coding');
subplot(1,2,2); plotflow(img); title('Vector Plot');

figure
plotflow(img);
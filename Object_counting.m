clc;
clear;
close all;


% Load image
img = imread('coins.png');
imshow(img)
title('Original Image')

figure;
imshow(img);
title('Original Image');

% Convert to grayscale
if size(img, 3) == 3
    gray = rgb2gray(img);
else
    gray = img;
end

% Apply median filter to remove noise
filtered = medfilt2(gray, [3 3]);

% Thresholding using Otsu's method
level = graythresh(filtered);
bw = imbinarize(filtered, level);

% Remove small noise
bw = bwareaopen(bw, 200);  


% Fill holes
bw_filled = imfill(bw, 'holes');

% Label connected components
[labeled, numObjects] = bwlabel(bw_filled);

% Outline and display results
stats = regionprops(labeled, 'Centroid', 'BoundingBox');

% Display image with labels
imshow(img);
title(['Detected Objects: ', num2str(numObjects)]);
hold on;

for k = 1:numObjects
    box = stats(k).BoundingBox;
    centroid = stats(k).Centroid;
    rectangle('Position', box, 'EdgeColor', 'r', 'LineWidth', 2);
    text(centroid(1), centroid(2), num2str(k), 'Color', 'b', 'FontSize', 12);
end

hold off;

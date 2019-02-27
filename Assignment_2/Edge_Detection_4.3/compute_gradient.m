%% Function for computing gradient using Sobel kernels

% image-path: "../Part-1: Image Enhancement/images/image2.jpg"

% Output: (All matrices with height and width of original image)
% Gx : Gradient in x-direction
% Gy : Gradient in y-direction
% im_mag : Gradient magnitude 
% im_dir : Gradient directions 

% Input: The image from which to calculate gradients
function [Gx, Gy, im_mag, im_dir] = compute_gradient(image)

% 0. Define sobel kernels
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
sobel_y = [1 2 1; 0 0 0; -1 -2 -1];
                
% 1. Read image
img = imread(image);
img = im2double(img);

% 2. Compute (approximate) gradients using sobel kernels
Gx = imfilter(img, sobel_x, "conv", "replicate");
Gy = imfilter(img, sobel_y, "conv", "replicate");

% 3. Compute gradient magnitude
im_mag = sqrt(Gx .^ 2 + Gy .^ 2);

% 4. Compute gradient direction
im_dir = atan2(Gy, Gx);


subplot(2, 2, 1), imshow(Gx);
subplot(2, 2, 2), imshow(Gy);
subplot(2, 2, 3), imshow(im_mag);
subplot(2, 2, 4), imshow(im_dir);

%% Using Imgradient to check answers (commented)

% 5. Compute (approximate) gradients using sobel kernels
% [GxIMG, GyIMG] = imgradientxy(img);
% 
% 6. Compute gradient magnitude and direction
% [im_magIMG, im_dirIMG] = imgradient(img);
% 
% subplot(2, 2, 1), imshow(GxIMG);
% subplot(2, 2, 2), imshow(GyIMG);
% subplot(2, 2, 3), imshow(im_magIMG);
% subplot(2, 2, 4), imshow(im_dirIMG);


end
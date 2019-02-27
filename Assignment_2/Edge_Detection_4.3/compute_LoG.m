function imOut = compute_LoG ( image , LOG_type )

img = imread(image);
img = im2double(img);

switch LOG_type
    case "method1"
    % 1. Smooth image with Gaussian Kernel
    G_kernel = fspecial('gaussian', [5 5], 0.5);
    img = imfilter(img, G_kernel, "conv", "replicate");
    
    % 2. Find 2nd-derivative using Laplacian Kernel
    L_kernel = fspecial('laplacian');
    imOut = imfilter(img, L_kernel, "conv", "replicate");
        
    case "method2"
    % Convolve image with Laplacian of Gaussian kernel (LoG)
    LoG_kernel = fspecial('log', [5 5], 0.5);

    imOut = imfilter(img, LoG_kernel, "conv", "replicate");
        
    case "method3"
    
    %Decide upon proper sigma values 
    sigma1 = 0.1;
    sigma2 = 1.0;
    G_kernel_1 = fspecial('gaussian', [5, 5], sigma1);
    G_kernel_2 = fspecial('gaussian', [5, 5], sigma2);
    
    % Convolve image with Gaussian (sigma_1) --Sharp
    img1 = imfilter(img, G_kernel_1, "conv", "replicate", "same");
    
    % Convolve image with Gaussian (sigma_2) --Wide
    img2 = imfilter(img, G_kernel_2, "conv", "replicate", "same"); 
    
    % Take difference of above output images
    imOut = img1 - img2;
        
end


end
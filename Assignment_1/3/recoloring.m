function recoloring(shading_img_path, orig_path)
shading_img = imread(shading_img_path);
orig_img = imread(orig_path);
green_img = cat(3, zeros(length(shading_img(:,1,:)), length(shading_img(1,:,:)), 'uint8'), 255*ones(length(shading_img(:,1,:)), length(shading_img(1,:,:)), 'uint8'), zeros(length(shading_img(:,1,:)), length(shading_img(1,:,:)), 'uint8'));
reconstructed_img = im2double(shading_img) .* im2double(green_img);
subplot(1,2,1), imshow(orig_img), title("Original Image");
subplot(1,2,2), imshow(reconstructed_img), title("Reconstructed Image")

end
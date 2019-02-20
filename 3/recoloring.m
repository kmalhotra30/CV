function recoloring(org_img_path)
org_img = imread(org_img_path);
green_img = cat(3, zeros(length(org_img(:,1,:)), length(org_img(1,:,:)), 'uint8'), 255*ones(length(org_img(:,1,:)), length(org_img(1,:,:)), 'uint8'), zeros(length(org_img(:,1,:)), length(org_img(1,:,:)), 'uint8'));
reconstructed_img = im2double(org_img) .* im2double(green_img);
subplot(1,2,1), imshow(org_img), title("Original Image");
subplot(1,2,2), imshow(reconstructed_img), title("Reconstructed Image")

end
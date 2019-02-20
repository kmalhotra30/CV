function iid_image_formation(org_img_path, albedo_img_path, shading_img_path)
org_img = imread(org_img_path);
albedo_img = imread(albedo_img_path);
shading_img = imread(shading_img_path);
reconstructed_img = im2double(albedo_img) .* im2double(shading_img);
subplot(2,2,1), imshow(org_img), title("Original Image");
subplot(2,2,2), imshow(albedo_img), title("Albedo Image");
subplot(2,2,3), imshow(shading_img), title("Shaded Image");
subplot(2,2,4), imshow(reconstructed_img), title("Reconstructed Image");
end
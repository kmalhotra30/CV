function true_colour = get_true_colour(albedo_img_path)
albedo_img = imread(albedo_img_path);
true_colour = reshape(albedo_img, [length(albedo_img(1,:,:)) * length(albedo_img(:,1,:)), 3]);
true_colour = mean(true_colour(true_colour(:,1) ~= 0,:));
end
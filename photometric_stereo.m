%%
close all
clear all
clc
%% 

% 1. Doc: This segment of the code is used for exercises without colors 
% nor faces. 

disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')

% 2. To load different images we change the folder name to the 
% desired image folder
image_dir = './photometrics_images/SphereGray5/';  
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
% 3. To choose how many images to use, for example in question 4 of 
% photometric stereo, we change the arguments in estimate_alb_nrm() to 
% image_stack(:, :, low:upper) and scriptV(lower:upper, :)
disp('Computing surface albedo and normal map...')
% The last argument is a flag which decided wether or not to use the 
% shadow trick when estimating normals and albedos
[albedo, normals] = estimate_alb_nrm(image_stack(:, :, :), scriptV(:, :), true);


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

% 4. As a threshold we arbitrarily chose 0.005 as our epsilon
threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
% 5. This function takes as last argument either "row", "column" or
% "average"
height_map = construct_surface( p, q ,'column');

%% Display

% 6. The following three lines have been commented out/in as necessary 
% to obtain the desired plots
show_results(albedo, normals, SE);
show_model(albedo, height_map);

% This call is useful to see just the albedo image
%imshow(albedo)









%% Face

% 7. The first three segments up until %%Sphere Color work analogously as 
% the code above

[image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV,false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q , 'row');

show_results(albedo, normals, SE);
show_model(albedo, height_map);









%% Sphere/Monkey in color
% 8. Using the load_syn_images function with the provided color channel 
% argument, we load the image stack and scriptV matrix for each color
% channel
[image_stackRed, scriptV] = load_syn_images('./photometrics_images/MonkeyColor/', 1);
[image_stackGreen, scriptV] = load_syn_images('./photometrics_images/MonkeyColor/', 2);
[image_stackBlue, scriptV] = load_syn_images('./photometrics_images/MonkeyColor/', 3);

% 9. We use the red channel to extract the dimensions
[h, w, n] = size(image_stackRed);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedoR, normalsR] = estimate_alb_nrm(image_stackRed, scriptV,true);
[albedoG, normalsG] = estimate_alb_nrm(image_stackGreen, scriptV,true);
[albedoB, normalsB] = estimate_alb_nrm(image_stackBlue, scriptV,true);


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
% 10. These values pR, qR --> pB, qB are strictly speaking not used 
% in our reconstructions but we at some point found it interesting to 
% investigate the amount of integral errors per color channel
% [pR, qR, SER] = check_integrability(normalsR);
% [pG, qG, SEG] = check_integrability(normalsG);
% [pB, qB, SEB] = check_integrability(normalsB);


%% Combine normals and reconstruct (Naive Solution)
%% Run this matlab cell to combine normals from color channels the naive way

% 11. Combine normals the naive way by simply adding them up, followed 
% by converting them into unit vectors, NOTE: that for the naive solution
% we may not combine the green channel using the monkey images as this 
% will result in normals made entirely of NaN's. This is not an issue for 
% our improved version in the next cell.

normals = normalsR + normalsB;% + normalsG;

for row=1:h
    for col=1:w
        norms = squeeze(normals(row, col, :));
        normals(row, col, :) = norms / norm(norms);
    end
end
         
% Note: that for plotting the colored Monkey we may not add the green 
% albedo as it will contain undefined values NaNs
albedo = zeros(size(albedoR,1),size(albedoR,2),3);
albedo(:,:,1) = albedoR;
% albedo(:,:,2) = albedoG;
albedo(:,:,3) = albedoB;
imshow(albedo);


% 12. In the following three lines we calculate the derivatives using 
% our naive normals. The user may comment out either of these lines 
% depending on which results should be displayed
[pNaive, qNaive, SE] = check_integrability(normals);

% Naive Normals:
height_mapNaive = construct_surface( pNaive, qNaive , 'average');

show_results(albedo, normals, SE);
show_model(albedo, height_mapNaive);




%% Combine normals and reconstruct (Non Naive solution)

% 13. This matlab segment is our non-naive solution to combining normals 
% from different color channels. We desire to retain the NaNs, should they 
% appear, rather than simply setting them to 0, as such we initialize a new
% tensor named normals of dimensions image height, image width and 
% depth = 3. We then place into normalComb all the combined normals for
% which at least one normal was not NaN (as caused by 0 albedos), followed 
% by converting the summed normal into a unit vector on lines 160-161

normals = zeros(size(normalsR));
[h,w,d] = size(normals);

% Combining normals and normalizing (ensuring unit length)

for i=1:h
    for j = 1:w
        for k = 1:d
            % Are all normals from each channel equal to NaN?
            if isnan(normalsR(i,j,k)) && isnan(normalsG(i,j,k)) && isnan(normalsB(i,j,k))
                normals(i,j,k) = NaN;
            end
            if ~isnan(normalsR(i,j,k)) %<-- what about normals from red?
                normals(i,j,k) = normals(i,j,k) + normalsR(i,j,k);
            end
            if ~isnan(normalsG(i,j,k)) %..normals from green?
                normals(i,j,k) = normals(i,j,k) + normalsG(i,j,k);
            end
            if ~isnan(normalsB(i,j,k)) %..normals from blue?
                normals(i,j,k) = normals(i,j,k) + normalsB(i,j,k);
            end
        end
        % Normalize normal-vector (turn into unit vector)
        norms = squeeze(normals(i,j,:));
        normals(i, j, :) = norms / norm(norms);
    end
end

% 14. The variables pComb and qComb will be our derivatives resulting from 
% using our improved normals in normalComb
[pComb, qComb, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

% Note: that for plotting the colored Monkey we may not add the green 
% albedo as it will contain undefined values NaNs
albedo = zeros(size(albedoR,1),size(albedoR,2),3);
albedo(:,:,1) = albedoR;
% albedo(:,:,2) = albedoG;
albedo(:,:,3) = albedoB;
imshow(albedo);

height_mapCombined = construct_surface( pComb, qComb , 'average');
show_results(albedo, normals, SE);
show_model(albedo, height_mapCombined);




%% 15. Plot only normal-map as a single image

% The following code snippet has been taken from the show_results() 
% function to simplify the extraction of clear images of normal maps 
% rather than plotting them as subfigures

% PLOT NORMALS:
minN = min(min(normals, [], 1), [], 2);
maxN = max(max(normals, [], 1), [], 2);
normal_img = (normals - minN) ./ (maxN - minN);
% NOTE: all 3 operations(-, /, -) are done in in broadcasting manner
% before MATLAB2016B, must use BSXFUN(@minus, normals, minN), ...
imshow(normal_img);
title('Normal map');






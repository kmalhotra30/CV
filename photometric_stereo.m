%%
close all
clear all
clc
%% 

disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './photometrics_images/MonkeyGray/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack(:, :, 1:50), scriptV(1:50, :), true);

% Code for printing the normals
%[h,w,d] = size(normals);
%figure(1)
%for i=1:h
%    for j=1:w
%        quiver3(i,j,0,normals(i,j,1),normals(i,j,2),normals(i,j,3))
%    end
%end

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q ,'average');

%% Display

% show_results(albedo, normals, SE);
% show_model(albedo, height_map);
imshow(albedo)









%% Face
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









%% Sphere Color
[image_stackRed, scriptV] = load_syn_images('./photometrics_images/MonkeyColor/', 1);
[image_stackGreen, scriptV] = load_syn_images('./photometrics_images/MonkeyColor/', 2);
[image_stackBlue, scriptV] = load_syn_images('./photometrics_images/MonkeyColor/', 3);
% imshow(image_stackRed(:, :, 1))
% imshow(image_stackGreen(:, :, 1))
% imshow(image_stackBlue(:, :, 1))


size(image_stackRed)
[h, w, n] = size(image_stackRed);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedoR, normalsR] = estimate_alb_nrm(image_stackRed, scriptV,true);
[albedoG, normalsG] = estimate_alb_nrm(image_stackGreen, scriptV,true);
[albedoB, normalsB] = estimate_alb_nrm(image_stackBlue, scriptV,true);




%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[pR, qR, SER] = check_integrability(normalsR);
[pG, qG, SEG] = check_integrability(normalsG);
[pB, qB, SEB] = check_integrability(normalsB);

%% Combine normals

normalComb = zeros(size(normalsR));
[h,w,d] = size(normalComb);

% Combining normals and normalizing (ensuring unit length)

for i=1:h
    for j = 1:w
%         dummy = [0, 0, 0];
        for k = 1:d
            
            if isnan(normalsR(i,j,k)) && isnan(normalsG(i,j,k)) && isnan(normalsB(i,j,k))
                normalComb(i,j,k) = NaN;
            end
            if ~isnan(normalsR(i,j,k))
                normalComb(i,j,k) = normalComb(i,j,k) + normalsR(i,j,k);
            end
            if ~isnan(normalsG(i,j,k))
                normalComb(i,j,k) = normalComb(i,j,k) + normalsG(i,j,k);
            end
            if ~isnan(normalsB(i,j,k))
                normalComb(i,j,k) = normalComb(i,j,k) + normalsB(i,j,k);
            end
        end
        % Normalize normal-vector (turn into unit vector)
        norms = squeeze(normalComb(i,j,:));
        normalComb(i, j, :) = norms / norm(norms);
    end
end

%%

[pComb, qComb, SE] = check_integrability(normalComb);


threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height

% Combine normals the naive way
normals = normalsR + normalsB;% + normalsB;

for row=1:h
    for col=1:w
        norms = squeeze(normals(row, col, :));
        normals(row, col, :) = norms / norm(norms);
    end
end
         

albedo = albedoR + albedoB;% + albedoG;
normals = normalComb;

% [pNaive, qNaive, SE] = check_integrability(normals);
% height_mapNaive = construct_surface( pNaive, qNaive , 'average');
height_mapCombined = construct_surface( pComb, qComb , 'average');

% show_results(albedo, normals, SE);
% show_model(albedo, height_mapNaive);
show_model(albedo, height_mapCombined);

% PLOT NORMALS:
minN = min(min(normals, [], 1), [], 2);
maxN = max(max(normals, [], 1), [], 2);
normal_img = (normals - minN) ./ (maxN - minN);
% NOTE: all 3 operations(-, /, -) are done in in broadcasting manner
% before MATLAB2016B, must use BSXFUN(@minus, normals, minN), ...
imshow(normal_img);
title('Normal map');






close all
clear all
clc
 
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
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV,false);

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
height_map = construct_surface( p, q ,'column');

%% Display

show_results(albedo, normals, SE);
show_model(albedo, height_map);







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
[image_stackRed, scriptV] = load_syn_images('./photometrics_images/SphereColor/', 1);
[image_stackGreen, scriptV] = load_syn_images('./photometrics_images/SphereColor/', 2);
[image_stackBlue, scriptV] = load_syn_images('./photometrics_images/SphereColor/', 3);
% imshow(image_stackRed(:, :, 1))
% imshow(image_stackGreen(:, :, 1))
% imshow(image_stackBlue(:, :, 1))


size(image_stackRed)
[h, w, n] = size(image_stackRed);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedoR, normalsR] = estimate_alb_nrm(image_stackRed, scriptV,false);
[albedoG, normalsG] = estimate_alb_nrm(image_stackGreen, scriptV,false);
[albedoB, normalsB] = estimate_alb_nrm(image_stackBlue, scriptV,false);




%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[pR, qR, SER] = check_integrability(normalsR);
[pG, qG, SEG] = check_integrability(normalsG);
[pB, qB, SEB] = check_integrability(normalsB);

%% Combine normals

normalComb = zeros(size(normalsR));
[h,w,d] = size(normalComb);


for i=1:h
    for j = 1:w
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
    end
end


%%

[pComb, qComb, SE] = check_integrability(normalComb);


threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
% height_mapR = construct_surface( pR, qR , 'average');
% height_mapG = construct_surface( pG, qG , 'average');
% height_mapB = construct_surface( pB, qB , 'average');

height_mapCombined = construct_surface( pComb, qComb , 'average');


% normals = normalsR + normalsG + normalsB;
albedo = albedoR + albedoG + albedoB;
% height_map = (height_mapR + height_mapG + height_mapB);

% show_results(albedoR, normalsR , SE);
% show_results(albedoB, normalsB , SE);
% show_results(albedoR + albedoB, normalsB + normalsR , SE);



show_results(albedo, normalComb , SE);
show_model(albedo, height_mapCombined);
% show_model(albedo, height_map);


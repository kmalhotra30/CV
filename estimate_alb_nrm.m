function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal


[h, w, ~] = size(image_stack);
if nargin == 2
    shadow_trick = true;
end

% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w, 1);
normal = zeros(h, w, 3);

% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image array
%   stack image values into a vector i
%   construct the diagonal matrix scriptI
%   solve scriptI * scriptV * g = scriptI * i to obtain g for this point
%   albedo at this point is |g|
%   normal at this point is g / |g|

if shadow_trick == true
    %With Shadow Trick
    for row=1:h
        for col=1:w
           i = image_stack(row,col,:); % This is a vector
           i = squeeze(i);
           scriptI = diag(i,0); %I for shadow trick
           A = scriptI * scriptV; % AX = B
           B = scriptI * i;
           [g,r] = linsolve(A,B); % Least square solution
           albedo(row,col,1) = norm(g);
           normal(row,col,:) = g ./ albedo(row,col,1);
        end
    end
else
  % Without Shadow Trick
  for row=1:h
        for col=1:w
           i = image_stack(row,col,:);
           i = squeeze(i);
           A = scriptV;
           B = i;
           [g,r] = linsolve(A,B);
           albedo(row,col,1) = norm(g);
           normal(row,col,:) = g ./ albedo(row,col,1);
        end
    end  
end




% =========================================================================

end


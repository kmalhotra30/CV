function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
p = zeros(size(normals)); % Why is it 3d?
q = zeros(size(normals)); % Why is it 3d?
SE = zeros(size(normals)); % Why is it 3d?

%Reinitializing the sizes - Need to check with TA

[h,w,d] = size(normals);
p = zeros(h,w);
q = zeros(h,w);
SE = zeros(h,w);


% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy
p = normals(:,:,1) ./ normals(:,:,3); % Maybe it should be negative
q = normals(:,:,2) ./ normals(:,:,3); % Maybe it should be negative


% ========================================================================



p(isnan(p)) = 0;
q(isnan(q)) = 0;



% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE

[~,dpdy] = gradient(p);
[dqdx,~] = gradient(q);
SE = (dpdy - dqdx) .* (dpdy - dqdx);


% ========================================================================




end


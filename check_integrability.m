function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

%Initializing Matrices

[h,w,d] = size(normals);
p = zeros(h,w);
q = zeros(h,w);
SE = zeros(h,w);


% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy
p = normals(:,:,1) ./ normals(:,:,3); 
q = normals(:,:,2) ./ normals(:,:,3); 

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


function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


if nargin == 2
    path_type = 'column';
end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        height_map(1,1) = q(1,1);
        for row = 2:h
            height_map(row,1) = height_map(row-1,1) + q(row,1);
        end
        
            
            
            
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        
        for row = 1:h
            for col = 2:w
                height_map(row,col) = height_map(row,col-1) + p(row,col);
            end
        end
        
       
        % =================================================================
               
    case 'row'
        
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the top row of height_map
        %   height_value = previous_height_value + corresponding_p_value
        height_map(1,1) = p(1,1);
        for col = 2:w
            height_map(1,col) = height_map(1,col-1) + p(1,col);
        end     
        % for each col
        %   for each element of the col except for topmost
        %       height_value = previous_height_value + corresponding_q_value
        
        for row = 2:h
            for col = 1:w
                height_map(row,col) = height_map(row-1,col) + q(row,col);
            end
        end
        
       
        % =================================================================
         
    case 'average'
        
        %%Col_major
        % =================================================================
        % YOUR CODE GOES HERE
        height_map_col_major = height_map;
        height_map_col_major(1,1) = q(1,1);
        for row = 2:h
            height_map_col_major(2,1) = height_map_col_major(row-1,1) + q(row,1);
        end
        
            
            
            
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        
        for row = 1:h
            for col = 2:w
                height_map_col_major(row,col) = height_map_col_major(row,col-1) + p(row,col);
            end
        end
        
        %Row_major
        
        height_map_row_major = height_map;
        height_map_row_major(1,1) = p(1,1);
        for col = 2:w
            height_map_row_major(1,col) = height_map_row_major(1,col-1) + p(1,col);
        end     
        % for each col
        %   for each element of the col except for topmost
        %       height_value = previous_height_value + corresponding_q_value
        
        for row = 2:h
            for col = 1:w
                height_map_row_major(row,col) = height_map_row_major(row-1,col) + q(row,col);
            end
        end
        
        height_map = (height_map_col_major + height_map_row_major)/2.0;
        % =================================================================
end


end


%% aim to draw fixed size grid pictures with different sizes and kinds of patterns 

% 1. image size
% 2. pattern kinds: 
% line, horizontal/vertical, width
% square, square size, gap_x, gap_y
% circle, circle radius, gap_x, gap_y
% triangle, triangle size (round to times of image)
% square_hollow, square size_big, size_small, gap_x, gap_y 
% hexagon, hexagon radius, gap_x, gap_y
% 3. output: 
% unit8 image, patterns' position([x,y]), pattern kind, 
% 

function [image, pt_pos, pt_kind, pt_size] = drawGrid_multi(image_size, pt_kind, pt_size, gap_x, gap_y)
    % some initials
    pt_pos = [];
    switch pt_kind
        case 'square'
            % draw a black image
            pt_size = pt_size * 2;
            I_tmp = zeros(image_size);
            % insert pattern
            %num_x = fix(image_size/(pt_size + gap_x));
            %num_y = fix(image_size/(pt_size + gap_y));
            for i = gap_x+1 : pt_size+gap_x : image_size-gap_x/2-pt_size/2
                for j = gap_y+1 : pt_size+gap_y : image_size-gap_y/2-pt_size/2
                    I_tmp(i:i+pt_size,j:j+pt_size) = 255;
                    pt_pos = [pt_pos,[i+pt_size/2;j+pt_size/2]];
                end
            end
%             imshow(I_tmp);
            image = I_tmp;
            pt_size = pt_size/2;
        case 'circle'
            I_tmp = zeros(image_size);
            for i = gap_x+1+pt_size : 2*pt_size+gap_x : image_size-gap_x/2-pt_size
                for j = gap_y+1+pt_size : 2*pt_size+gap_y : image_size-gap_y/2-pt_size
                    % I_tmp(i:i+pt_size,j:j+pt_size) = 255;
                    pt_pos = [pt_pos,[i;j]];
                end
            end
            x = pt_pos(1,:);
            y = pt_pos(2,:);
            %size(x)
            %size(y)
            Circles = insertShape(I_tmp,'FilledCircle',[x', y', pt_size*ones(length(x),1)],'Color','white','SmoothEdges',false,'Opacity',1);
            % imshow(Circles);
            image = Circles(:,:,1)*255;
%             size(image)
%             imshow(image);
        case 'triangle'
            error('to be done in the future!');
        case 'square_hollow'
            error('to be done!');
        case 'hexagon'            
            I_tmp = zeros(image_size);
            pgon = [];
            for i = gap_x+1+pt_size : 2*pt_size+gap_x : image_size-gap_x/2-pt_size
                for j = gap_y+1+pt_size : 2*pt_size+gap_y : image_size-gap_y/2-pt_size
                    % I_tmp(i:i+pt_size,j:j+pt_size) = 255;
                    pgon = [pgon nsidedpoly(6, 'Center', [i,j], 'Radius',pt_size)];
                    pt_pos = [pt_pos,[i;j]];
                end
            end  
            
            % bw = poly2mask(x,y,80,80);   
            % reshape(pgon(1).Vertices',1,[])
            Matrix_Polygon = [];
            for k = 1:length(pgon)
                Matrix_Polygon = [Matrix_Polygon; reshape(pgon(k).Vertices',1,[])];
            end
            hexagons = insertShape(I_tmp,'FilledPolygon', Matrix_Polygon, 'Color','white', 'SmoothEdges',false, 'Opacity',1);
            image = hexagons(:,:,1)*255;    
%             imshow(hexagons);
            
        otherwise
            error('please enter the correct pattern kind!');
    end
    
end
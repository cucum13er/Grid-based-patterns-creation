%% warped image
% aim to give an imput image a locally distortion based on each pattern

function [image, centers] = warpedImage_factor(Im, pt_kind, pt_pos, pt_size, gap_x, gap_y, warpFactor,movefactor) 

% below is setting up a affine transformation 
% plan to do a random factor at each time
% warpFactor = [theta, Scaling_factor, Trans_factor, Shear_factor];
% [theta, Scaling_factor, Shear_factor] = deal(warpFactor(1), warpFactor(2), warpFactor(3));
% %theta = 0;
% %Scaling_factor = 1;
% %Trans_factor = 0;
% %Shear_factor = 0.1;
% 
% Rotation = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];
% Scaling = [Scaling_factor, 0, 0; 0, Scaling_factor, 0; 0, 0 ,1];
% %Translation = [1, 0, Trans_factor; 0, 1, Trans_factor; 0, 0, 1];
% Shear = [1, Shear_factor, 0; Shear_factor, 1, 0; 0, 0, 1];
% Trans = Rotation * Scaling * Shear; %* Translation;
% T = affine2d(Trans');
centers = {};
% gap_x = floor(gap_x / movefactor / 2)*2;
% gap_y = floor(gap_y / movefactor / 2)*2;
switch pt_kind
    case 'square'
        for i = 1:length(pt_pos)
            % each pattern to be warped
            px = pt_pos(1,i);
            py = pt_pos(2,i);
            tmp_pt = Im(px-pt_size:px+pt_size, py-pt_size:py+pt_size);
            Im(px-pt_size:px+pt_size, py-pt_size:py+pt_size) = 0;
            %I_coord = imref2d(size(tmp_pt));
            T = affine_T(warpFactor);
            J = imwarp(tmp_pt,T);
            %figure;
            %imshow(J);
            
            if size(J) <= [2*pt_size+gap_x, 2*pt_size+gap_y]
                % distorted pattern size <= original size + gap/2, we put
                % it in a random position of extend gap/2 of original
                % position
                [row,col] = size(J);
                x_move = 2*pt_size+gap_x + 1 - row;
                y_move = 2*pt_size+gap_y + 1 - col;
                x_move_cut = randi([-round(x_move/2/movefactor), round(x_move/2/movefactor)],1);
                y_move_cut = randi([-round(y_move/2/movefactor), round(y_move/2/movefactor)],1);
                pt_begin = [x_move_cut, y_move_cut];
                % pt_begin = [randi(max(x_move,0)+1)-1, randi(max(y_move,0)+1)-1];% where to begin to put left-top corner
                % original topleft + total move/2 + random_move
                new_x = round(px-pt_size-gap_x/2 + x_move/2 + pt_begin(1) );
                new_y = round(py-pt_size-gap_y/2 + y_move/2 + pt_begin(2) );
                Im(new_x:new_x+row-1, new_y:new_y+col-1) = J;
                % Im(px-pt_size-gap_x/2+pt_begin(1):px-pt_size-gap_x/2+pt_begin(1)+row-1, py-pt_size-gap_y/2+pt_begin(2):py-pt_size-gap_y/2+pt_begin(2)+col-1) = J;
                tmp_x = round((new_x+new_x+row-1)/2);
                tmp_y = round((new_y+new_y+col-1)/2);
                centers{i} = [tmp_x,tmp_y];                
            else
                % able to be optimized 
                J = imresize(J,[2*pt_size+gap_x, 2*pt_size+gap_y]);
                % same as the maximum size, put it in that region
                Im(px-pt_size-gap_x/2:px+pt_size+gap_x/2-1, py-pt_size-gap_y/2:py+pt_size+gap_y/2-1) = J;
                tmp_x = round((px-gap_x/2 + px+pt_size+gap_x/2-1)/2);
                tmp_y = round((py-gap_y/2 + py+pt_size+gap_y/2-1)/2);
                centers{i} = [tmp_x,tmp_y];                  
            end
            %imshow(Im);
        end        
        %%%
%         for i = 1:length(pt_pos)
%             % each pattern to be warped
%             px = pt_pos(1,i);
%             py = pt_pos(2,i);
% %             tmp_pt = Im(px:px+pt_size, py:py+pt_size);
%             tmp_pt = Im(px-pt_size:px+pt_size, py-pt_size:py+pt_size);
%             Im(px:px+pt_size, py:py+pt_size) = 0;
%             %I_coord = imref2d(size(tmp_pt));
%             T = affine_T(warpFactor);
%             J = imwarp(tmp_pt,T);
%             %figure;
%             %imshow(J);
%             
%             if size(J) <= [2*pt_size+gap_x, 2*pt_size+gap_y]
%                 % distorted pattern size <= original size + gap/2, we put
%                 % it in a random position of extend gap/2 of original
%                 % position
%                 [row,col] = size(J);
%                 x_move = pt_size+gap_x - row;
%                 y_move = pt_size+gap_y - col;
%                 pt_begin = [randi(x_move+1)-1, randi(y_move+1)-1];% where to begin to put left-top corner
%                 Im(px-gap_x/2+pt_begin(1):px-gap_x/2+pt_begin(1)+row-1, py-gap_y/2+pt_begin(2):py-gap_y/2+pt_begin(2)+col-1) = J;
%                 tmp_x = round(((px-gap_x/2+pt_begin(1) + px-gap_x/2+pt_begin(1)+row-1)/2));
%                 tmp_y = round((py-gap_y/2+pt_begin(2) + py-gap_y/2+pt_begin(2)+col-1)/2);
%                 centers{i} = [tmp_x,tmp_y];
%             else
%                 % able to be optimized 
%                 J = imresize(J,[2*pt_size+gap_x, 2*pt_size+gap_y]);
%                 % same as the maximum size, put it in that region
% %                 Im(px-gap_x/2:px+pt_size+gap_x/2-1, py-gap_y/2:py+pt_size+gap_y/2-1) = J;
%                 Im(px-pt_size-gap_x/2:px+pt_size+gap_x/2-1, py-pt_size-gap_y/2:py+pt_size+gap_y/2-1) = J;
%                 tmp_x = round((px-gap_x/2 + px+pt_size+gap_x/2-1)/2);
%                 tmp_y = round((py-gap_y/2 + py+pt_size+gap_y/2-1)/2);
%                 centers{i} = [tmp_x,tmp_y];            
%             end
            
            %imshow(Im);
        
                   
    case 'circle'
        for i = 1:length(pt_pos)
            % each pattern to be warped
            px = pt_pos(1,i);
            py = pt_pos(2,i);
            tmp_pt = Im(px-pt_size:px+pt_size, py-pt_size:py+pt_size);
            Im(px-pt_size:px+pt_size, py-pt_size:py+pt_size) = 0;
            %I_coord = imref2d(size(tmp_pt));
            T = affine_T(warpFactor);
            J = imwarp(tmp_pt,T);
            %figure;
            %imshow(J);
            
            if size(J) <= [2*pt_size+gap_x, 2*pt_size+gap_y]
                % distorted pattern size <= original size + gap/2, we put
                % it in a random position of extend gap/2 of original
                % position
                [row,col] = size(J);
                x_move = 2*pt_size+gap_x + 1 - row;
                y_move = 2*pt_size+gap_y + 1 - col;
                x_move_cut = randi([-round(x_move/2/movefactor), round(x_move/2/movefactor)],1);
                y_move_cut = randi([-round(y_move/2/movefactor), round(y_move/2/movefactor)],1);
                pt_begin = [x_move_cut, y_move_cut];
                % pt_begin = [randi(max(x_move,0)+1)-1, randi(max(y_move,0)+1)-1];% where to begin to put left-top corner
                % original topleft + total move/2 + random_move
                new_x = round(px-pt_size-gap_x/2 + x_move/2 + pt_begin(1) );
                new_y = round(py-pt_size-gap_y/2 + y_move/2 + pt_begin(2) );
                Im(new_x:new_x+row-1, new_y:new_y+col-1) = J;
                
                tmp_x = round(((px-gap_x/2+pt_begin(1) + px-gap_x/2+pt_begin(1)+row-1)/2));
                tmp_y = round((py-gap_y/2+pt_begin(2) + py-gap_y/2+pt_begin(2)+col-1)/2);
                centers{i} = [tmp_x,tmp_y];                
            else
                % able to be optimized 
                J = imresize(J,[2*pt_size+gap_x, 2*pt_size+gap_y]);
                % same as the maximum size, put it in that region
                Im(px-pt_size-gap_x/2:px+pt_size+gap_x/2-1, py-pt_size-gap_y/2:py+pt_size+gap_y/2-1) = J;
                tmp_x = round((px-gap_x/2 + px+pt_size+gap_x/2-1)/2);
                tmp_y = round((py-gap_y/2 + py+pt_size+gap_y/2-1)/2);
                centers{i} = [tmp_x,tmp_y];                  
            end
            %imshow(Im);
        end

    case 'triangle'
        error('to be continued!');
    case 'square_hollow'
        error('to be done!');
    case 'hexagon'
        for i = 1:length(pt_pos)
            % each pattern to be warped
            px = pt_pos(1,i);
            py = pt_pos(2,i);
            tmp_pt = Im(px-pt_size:px+pt_size, py-pt_size:py+pt_size);
            Im(px-pt_size:px+pt_size, py-pt_size:py+pt_size) = 0;
            %I_coord = imref2d(size(tmp_pt));
            T = affine_T(warpFactor);
            J = imwarp(tmp_pt,T);
            %figure;
            %imshow(J);
            
            if size(J) <= [2*pt_size+gap_x, 2*pt_size+gap_y]
                % distorted pattern size <= original size + gap/2, we put
                % it in a random position of extend gap/2 of original
                % position
                [row,col] = size(J);
                x_move = 2*pt_size+gap_x + 1 - row;
                y_move = 2*pt_size+gap_y + 1 - col;
                x_move_cut = randi([-round(x_move/2/movefactor), round(x_move/2/movefactor)],1);
                y_move_cut = randi([-round(y_move/2/movefactor), round(y_move/2/movefactor)],1);
                pt_begin = [x_move_cut, y_move_cut];
                % pt_begin = [randi(max(x_move,0)+1)-1, randi(max(y_move,0)+1)-1];% where to begin to put left-top corner
                % original topleft + total move/2 + random_move
                new_x = round(px-pt_size-gap_x/2 + x_move/2 + pt_begin(1) );
                new_y = round(py-pt_size-gap_y/2 + y_move/2 + pt_begin(2) );
                Im(new_x:new_x+row-1, new_y:new_y+col-1) = J;
                
                tmp_x = round(((px-gap_x/2+pt_begin(1) + px-gap_x/2+pt_begin(1)+row-1)/2));
                tmp_y = round((py-gap_y/2+pt_begin(2) + py-gap_y/2+pt_begin(2)+col-1)/2);
                centers{i} = [tmp_x,tmp_y];                
            else
                % able to be optimized 
                J = imresize(J,[2*pt_size+gap_x, 2*pt_size+gap_y]);
                % same as the maximum size, put it in that region
                Im(px-pt_size-gap_x/2:px+pt_size+gap_x/2-1, py-pt_size-gap_y/2:py+pt_size+gap_y/2-1) = J;
                tmp_x = round((px-gap_x/2 + px+pt_size+gap_x/2-1)/2);
                tmp_y = round((py-gap_y/2 + py+pt_size+gap_y/2-1)/2);
                centers{i} = [tmp_x,tmp_y];                  
            end
            %imshow(Im);
        end
        
    otherwise
        error('please enter the correct pattern kind!');
        
end
image = Im;
end

        
%% PALINDRONE'S GAME OF LIFE: execute Game of Life
% Generates a Game of Life for X time

% Seed RNG
clearvars;

% rng(1337,'twister');

take_screenshot = false;

% Generative properties
how_many_frames     = 150;
frames_per_second   = 24;
type_of_game        = 'picture'; % 'picture'
cell_size           = 10;
border_size         = 0;
blank_frames        = 10;
direction           = 'reverse'; % 'forward'

switch type_of_game
    case 'random'
        % Determine the dimensions
        dimension_type = 'youtube';
        
        switch dimension_type
            case 'youtube'
                dimensions = [1080,1920];
            case 'instagram'
                dimensions = [1920,1080];
        end
        
        % Determine the colours
        colour(1,:) = [0,0,0]; % Black
        colour(2,:) = [255, 247, 210]; % Cream
        colour(3,:) = [254, 104, 51]; % Ochre
        
        % Populate board
        the_board   = randi(...
            size(colour,1),...
            dimensions(1)/cell_size, dimensions(2)/cell_size);
        
    case 'picture'
        % Load the picture
        the_foundation  = imread('../images/palindrone_youtube.png');
        
        % Determine the dimensions
        dimensions      = [size(the_foundation,1),size(the_foundation,2)];
        
        % Determine the colours
        colour(1,:) = [0,0,0]; % Black
        colour(2,:) = [255, 247, 210]; % Cream
        colour(3,:) = [254, 104, 51]; % Ochre
              
        % Define the block size
        block_size  = [cell_size, cell_size];
        
        % Function to calculate the mean of each block
        mean_filter = @(block_struct) mean2(block_struct.data);
        
        % Apply the block processing function to downsize the matrix
        image_board = blockproc(the_foundation(:,:,3), block_size, mean_filter);
        
        image_board(image_board == 0)   = 1;
        image_board(image_board == 210) = 2;
        image_board(image_board == 51)  = 3;
        
        % Populate noise board
        noise_board     = randi(...
            size(colour,1),...
            dimensions(1)/cell_size, dimensions(2)/cell_size);
        
        % Add X% random noise 
        noise_percent   = .01;
        
        small_dims = dimensions ./ cell_size;
        
        % Select these pixels
        these_pixels    = randperm(...
            small_dims(1) * small_dims(2), ...
            round( (small_dims(1)*small_dims(2)) * noise_percent));
        
        % Blend image & noise
        the_board               = image_board;
        the_board(these_pixels) = noise_board(these_pixels);
end

%% GENERATE GAME OF LIFE
% Generate game of life

disp('Generating Game of Life');

% Generate array
the_array = cell(1,how_many_frames);

for the_frame = 1:how_many_frames
   
    % Evolve the board
    if the_frame > blank_frames
        the_board   = evolve_life(the_board);
    end
    
    % Resize
    the_vision  = generate_board(the_board,cell_size,border_size);
    
    % Recolour
    the_image   = colourise(the_vision, colour);
    
    % Save into array
    switch direction
        case 'forward'
            the_array{the_frame} = the_image;
        case 'reverse'
            the_array{how_many_frames - the_frame + 1} = the_image;
    end
    
    fprintf('%3.0d / %3.0d\n',the_frame, how_many_frames);
end

%% START PSYCHTOOLBOX

clear PsychHID;

Screen('Preference', 'SkipSyncTests', 1);

[cfg.win, win_rect] = Screen('OpenWindow', 0, [0,0,0], ...
    [0,0,dimensions(2),dimensions(1)], [], 2);

%% PLAY GAME OF LIFE
% Cycle through each frame

for the_frame = 1:how_many_frames
    
    % Generate texture
    the_texture = Screen('MakeTexture', cfg.win, the_array{the_frame});
    
    % Draw & Flip texture
    Screen('DrawTexture', cfg.win, the_texture);
    Screen('Flip',cfg.win);
    
    % Save screenshot
    if take_screenshot
        the_screen = Screen('GetImage',cfg.win); %#ok<*UNRCH>
        the_title = sprintf('frametime_%s',datestr(now,'HHMMSSFFF'));
        imwrite(the_screen,['../images/' the_title '.png']);
    end
    
    % Close texture
    Screen('Close',the_texture);
    
    % Wait
    WaitSecs(1/frames_per_second);
end

WaitSecs(2);

%% CLOSE WINDOW

sca;

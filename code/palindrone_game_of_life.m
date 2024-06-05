%% PALINDRONE'S GAME OF LIFE: execute Game of Life
% Generates a Game of Life for X time

% Seed RNG
clearvars;

rng(606,'twister');

% Options
take_screenshot     = false;
take_video          = true;

% Generative properties
how_many_seconds    = 400;
frames_per_second   = 30;
type_of_game        = 'combo'; % 'picture' 'random' 'combo' 'noise'
cell_size           = 10;
border_size         = 0;
blank_frames        = 1;
direction           = 'forward'; % 'forward' 'reverse'

% The movie
moviename = 'screen_recording.mov';

% Determine the colours
colour(1,:) = [254, 104, 51]; % [36,30,3]; % Dark brown
colour(2,:) = [255, 247, 210]; % Cream
colour(3,:) = [254, 104, 51]; % Ochre
colour(4,:) = [36,30,3]; % Dark brown

noise_colour(1,:) = [36,30,3]; % Dark brown
noise_colour(2,:) = [255, 247, 210]; % Cream
noise_colour(3,:) = [254, 104, 51]; % Ochre
noise_colour(4,:) = [254, 149, 113]; % Lightest ochre
noise_colour(5,:) = [254, 128, 83]; % Medium ochre
noise_colour(6,:) = [254, 114, 61]; % Close ochre

% Determine frame number
how_many_frames = how_many_seconds * frames_per_second;

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
        
        % Populate board
        the_board   = randi(...
            size(colour,1),...
            dimensions(1)/cell_size, dimensions(2)/cell_size);
        
    case 'picture'
        % Load the picture
        the_foundation  = imread('../images/palindrone_youtube.png');
        
        % Determine the dimensions
        dimensions      = [size(the_foundation,1),size(the_foundation,2)];
              
        % Define the block size
        block_size  = [cell_size, cell_size];
        
        % Function to calculate the mean of each block
        mean_filter = @(block_struct) mean2(block_struct.data);
        
        % Apply the block processing function to downsize the matrix
        image_board = blockproc(the_foundation(:,:,3), block_size, mean_filter);
        
        image_board(image_board == 0)   = 4;
        image_board(image_board == 210) = 2;
        image_board(image_board == 51)  = 3;
        
        % Populate noise board
        noise_board     = randi(...
            size(colour,1),...
            dimensions(1)/cell_size, dimensions(2)/cell_size);
        
        % Add X% random noise 
        noise_percent   = .00001;
        
        small_dims = dimensions ./ cell_size;
        
        % Select these pixels
        these_pixels    = randperm(...
            small_dims(1) * small_dims(2), ...
            round( (small_dims(1)*small_dims(2)) * noise_percent));
        
        % Blend image & noise
        the_board               = image_board;
        the_board(these_pixels) = noise_board(these_pixels);
        
    case 'combo'
        % Load the picture
        the_foundation  = imread('../images/palindrone_youtube.png');
        
        % Determine the dimensions
        dimensions      = [size(the_foundation,1),size(the_foundation,2)];
              
        % Define the block size
        block_size  = [cell_size, cell_size];
        
        % Function to calculate the mean of each block
        mean_filter = @(block_struct) mean2(block_struct.data);
        
        % Apply the block processing function to downsize the matrix
        image_board = blockproc(the_foundation(:,:,3), block_size, mean_filter);
        
        image_board(image_board == 0)   = 4; % 1;
        image_board(image_board == 210) = 2;
        image_board(image_board == 51)  = 3;
        
        image_insert(image_board == 1)  = true;
        image_insert(image_board == 2)  = true;
        image_insert(image_board == 3)  = false;
        image_insert(image_board == 4)  = true;
        
        % Populate board
        the_board   = randi(...
            3, ... % size(colour,1),...
            dimensions(1)/cell_size, dimensions(2)/cell_size);
        
    case 'noise'
        % Load the picture
        the_foundation  = imread('../images/palindrone_youtube.png');
        
        % Determine the dimensions
        dimensions      = [size(the_foundation,1),size(the_foundation,2)];
              
        % Define the block size
        block_size  = [cell_size, cell_size];
        
        % Function to calculate the mean of each block
        mean_filter = @(block_struct) mean2(block_struct.data);
        
        % Apply the block processing function to downsize the matrix
        image_board = blockproc(the_foundation(:,:,3), block_size, mean_filter);
        
        image_board(image_board == 0)   = 1;
        image_board(image_board == 210) = 2;
        image_board(image_board == 51)  = 3;
        
        image_insert(image_board == 1)  = true;
        image_insert(image_board == 2)  = true;
        image_insert(image_board == 3)  = false;
        
        % Populate board
        the_board   = randi(...
            [3,6], ...
            dimensions(1)/cell_size, dimensions(2)/cell_size);
        
        
end

%% GENERATE GAME OF LIFE
% Generate game of life

disp('Generating Game of Life');

% Generate array
the_array = cell(1,how_many_frames);

for the_frame = 1:how_many_frames
   
    % Evolve the board
    switch type_of_game
        case 'noise'
            the_board = randi(...
                [3,6], ...
                dimensions(1)/cell_size, dimensions(2)/cell_size);
        otherwise
            if the_frame > blank_frames
                the_board   = evolve_life(the_board);
            end
    end
    
    % Insert the central image
    switch type_of_game
        case {'combo','noise'}
            the_OG = the_board; % Save original board
            
            the_board(image_insert) = image_board(image_insert);
    end
    
    % Resize & create border
    % the_vision  = generate_board(the_board,cell_size,border_size);
    the_vision = the_board;
    
    % Recolour
    switch type_of_game
        case 'noise'
            the_image = colourise(the_vision, noise_colour);
        otherwise
            the_image = colourise(the_vision, colour);
    end
    
    % Save into array
    switch direction
        case 'forward'
            the_array{the_frame} = the_image;
        case 'reverse'
            the_array{how_many_frames - the_frame + 1} = the_image;
    end
    
    switch type_of_game
        case 'combo'
             the_board = the_OG;
    end
    
    fprintf('%4.0d / %4.0d\n',the_frame, how_many_frames);
end

%% START PSYCHTOOLBOX

clear PsychHID;

Screen('Preference', 'SkipSyncTests', 1);

[cfg.win, win_rect] = Screen('OpenWindow', 0, [0,0,0], ...
    [0,0,dimensions(2),dimensions(1)], [], 2);

%% PLAY GAME OF LIFE
% Cycle through each frame

% Record screen
if take_video
       
    if exist(moviename, 'file')
        delete(moviename);
        warning('%s existed already! Will overwrite it...', moviename);
    end
       
    % Give it a moment to catch up
    WaitSecs('YieldSecs', 1);
    
    the_movie = Screen('CreateMovie', cfg.win, moviename,[],[], ...
        frames_per_second, ...
        ':CodecSettings=EncodingQuality=0.9 Profile=2'); % ':CodecSettings=Videoquality=0.01 Profile=2'); % ':CodecType=theoraenc');
    
end

% Sync to vertical retrace
t_0     = Screen('Flip', cfg.win, 0, 0);
t_prev  = t_0;

for the_frame = 1:how_many_frames
    
    % Generate texture
    the_texture = Screen('MakeTexture', cfg.win, the_array{the_frame});
    
    % Determine flip time
    t_scheduled = t_prev + (1/frames_per_second); 
    
    % Draw texture
    Screen('DrawTexture', cfg.win, the_texture,[],win_rect,[],0);
    
    % Flip precisely
    t_prev = Screen('Flip',cfg.win, t_scheduled, 0);
    
    % Save screenshot
    if take_screenshot
        the_screen = Screen('GetImage',cfg.win); %#ok<*UNRCH>
        the_title = sprintf('frametime_%s',datestr(now,'HHMMSSFFF'));
        imwrite(the_screen,['../screenshot/' the_title '.png']);
    elseif take_video
        Screen('AddFrameToMovie', cfg.win);
    end
    
    % Close texture
    Screen('Close',the_texture);
    
end

WaitSecs(1);

%% CLOSE WINDOW

if take_video
    Screen('FinalizeMovie', the_movie);
end

sca;

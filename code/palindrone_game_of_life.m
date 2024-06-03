%% PALINDRONE'S GAME OF LIFE: execute Game of Life
% Generates a Game of Life for X time

% Seed RNG
clearvars;

% rng(1337,'twister');

% Generative properties
how_many_frames     = 100;
frames_per_second   = 24;
type_of_game        = 'random'; % 'picture'
cell_size           = 10;

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
        
        % Determine the dimensions
        
        % Determine the colours
        
        % Populate board
end

%% GENERATE GAME OF LIFE
% Generate game of life

disp('Generating Game of Life');

% Generate array
the_array = cell(1,how_many_frames);

for the_frame = 1:how_many_frames
   
    % Evolve the board
    the_board   = evolve_life(the_board);
    
    % Resize
    the_vision  = generate_board(the_board,cell_size);
    
    % Recolour
    the_image   = colourise(the_vision, colour);
    
    % Save into array
    the_array{the_frame} = the_image;
    
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
    
    % Close texture
    Screen('Close',the_texture);
    
    % Wait
    WaitSecs(1/frames_per_second);
end

%% CLOSE WINDOW

sca;

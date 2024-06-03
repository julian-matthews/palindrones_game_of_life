%% PALINDRONE'S GAME OF LIFE: evolve board
% Implements a 3-colour game of life

function the_new_board = evolve_life( the_board )

% Get the size of the matrix
[rows, cols] = size(the_board);

% Initialize the next state matrix
the_new_board = the_board;

% Define the neighbors' offsets for Moore neighborhood
neighbor_offsets = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% Loop through each cell in the matrix
for i = 1:rows
    for j = 1:cols
        % Get the current cell value
        current_value = the_board(i, j);
        % Determine the value that beats the current cell value
        if current_value == 1
            beaten_by = 2;  % Paper beats rock
        elseif current_value == 2
            beaten_by = 3;  % Scissors beats paper
        elseif current_value == 3
            beaten_by = 1;  % Rock beats scissors
        end
        
        % Count the number of neighbors that beat the current cell
        beat_count = 0;
        for k = 1:size(neighbor_offsets, 1)
            neighbor_row = i + neighbor_offsets(k, 1);
            neighbor_col = j + neighbor_offsets(k, 2);
            % Check if the neighbor is within the bounds of the matrix
            if neighbor_row >= 1 && neighbor_row <= rows && neighbor_col >= 1 && neighbor_col <= cols
                if the_board(neighbor_row, neighbor_col) == beaten_by
                    beat_count = beat_count + 1;
                end
            end
        end
        
        % Update the cell value if it has more than 2 neighbors that beat it
        if beat_count > 2
            the_new_board(i, j) = beaten_by;
        end
    end
end

end
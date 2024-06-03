%% PALINDRONE'S GAME OF LIFE: generate board
% Resize the board and add border

function the_new_board = generate_board( the_board, cell_size )

% Border size
border_size = 1;

% Resize by factor of 'cell_size'
replicate_matrix = ones(cell_size, cell_size);

% Use the kron function to resize the matrix
the_new_board = kron(the_board, replicate_matrix);

% Overwrite the last two rows and columns of each 10x10 block with zeros
for i = 1:(size(the_new_board,1)/cell_size)
    for j = 1:(size(the_new_board,2)/cell_size)
        % Determine the block's start and end indices in the resized matrix
        start_row = (i-1)*cell_size + 1;
        end_row = start_row + 9;
        start_col = (j-1)*cell_size + 1;
        end_col = start_col + 9;
        
        % Set the last X rows and last two columns of each block to 0
        the_new_board(end_row - (border_size-1) ...
            :end_row, start_col:end_col) = 0;
        the_new_board(start_row:end_row, ...
            end_col - (border_size-1) ...
            :end_col) = 0;
    end
end

end
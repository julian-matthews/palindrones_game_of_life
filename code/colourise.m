%% PALINDRONE'S GAME OF LIFE: colourise
% Assign RGB colours using array indexing.

function the_image = colourise( the_board, colour )

% Initialize the image matrix with zeros
the_image = zeros(size(the_board, 1), size(the_board, 2), 3);

% Assign colors based on the values in the_board
for k = 1:3
    % Create a mask for each value
    mask = (the_board == k);
    % Assign the corresponding color to the mask
    for c = 1:3
        the_image(:,:,c) = the_image(:,:,c) + mask * colour(k,c);
    end
end

end

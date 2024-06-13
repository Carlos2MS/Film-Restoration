close all
clear

% Read in the picture
original = double(imread('greece.tif'));

% Read in the magic forcing function
% In the actual assignment you just have to to this ----> load forcing;
% We have to do the lines below. Don't use these in your submission!
load forcing;
%load forcing_right;
%f = [leftf rightf];

% Read in the corrupted picture which contains holes
load badpicture;

% Read in an indicator picture which is 1 where the
% pixels are missing in badicture.
mask = double(imread('badpixels.tif'));


% Please initialise your variables here.
restored = badpic; 

alpha = 0.8;
total_iterations = 2500;
%f(m,n) = 0;

err = zeros(1, total_iterations);
err2 = err;

restored20 = 0;
restored20_2 = 0;
restored_tmp = badpic;
restored2 = badpic;

% This displays the original picture in Figure 1
figure(1);
image(original);
title('Original');
colormap(gray(256));

% Display the corrupted picture in Figure 2
figure(2);
image(badpic);
title('Corrupted Picture');
colormap(gray(256));

    
% Here is where you can do your picture iterations.
% Locations of the missing pixels
[j, i] = find(mask ~= 0); 
%[rows, cols] = find(mask ~= 0); 

% Restored Picture without forcing function "f"
for iteration = 1 : total_iterations
   % Iterate over all the missing pixels (don't iterate over the whole image!)
    for x = 1: length(j)
        m = j(x);
        n = i(x);
        % SOR
        E_k = restored(m - 1, n) + restored(m + 1, n) + restored(m, n - 1) + restored(m, n + 1) - 4 * restored(m, n);
        restored_tmp(m, n) = restored(m, n) + ((alpha * E_k) / 4);   
    end;

    restored = restored_tmp;

     % The 20th iteration, you store your restored image in "restored20"
    if iteration == 20
        restored20 = restored;
    end;

    % After each iteration you calculate the mean absolute error between the original and restored images
    error_p = abs(original(mask ~= 0) - restored(mask ~= 0));
    err(iteration) = mean(error_p);
    
end;

% Display the restored image in Figure 3
figure(3);
image(restored);
title('Restored Picture');
colormap(gray(256));


% Restored Picture with forcing function "f"
restored_tmp = badpic;

for iteration = 1 : total_iterations,
  % Remember to assign restored20_2 and err2
  for x = 1: length(j)
        m = j(x);
        n = i(x);
        % SOR
        restored_tmp(m, n) = restored2(m - 1, n) + restored2(m + 1, n) + restored2(m, n - 1) + restored2(m, n + 1) - f(m, n);
        restored_tmp(m, n) = restored_tmp(m, n) / 4;
    end;
    restored2 = restored_tmp;

    % Mean absolute error between the original and restored images
    error_p = abs(original(mask ~= 0) - restored2(mask ~= 0));
    err2(iteration) = mean(error_p);

    % The 20th iteration, you store your restored image in "restored20_2"
    if iteration == 20
        restored20_2 = restored;
    end;

end;

% Display your restored image with forcing function as Figure 4
figure(4);
image(restored2);
title('Restored Picture (with F)');
colormap(gray(256));

% And plot your two error vectors versus iteration
figure(5);
plot(1:total_iterations, err, 'r-', 1:total_iterations, err2, 'b-', 'Linewidth', 3);

legend('No forcing function', 'With forcing function');
xlabel('Iteration', 'fontsize', 20);
ylabel('Mean Absolute Error', 'fontsize', 20);
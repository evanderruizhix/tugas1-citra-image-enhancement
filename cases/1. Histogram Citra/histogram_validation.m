% =========================================================================
% VALIDASI FUNGSI HISTOGRAM MANUAL DENGAN IMHIST
% =========================================================================
clear; clc; close all;

addpath(genpath('../../src'));
addpath(genpath('../../citra_test_images'));

images = {'image_01.png', 'image_02.png', 'image_03.png', 'image_04.png'};

fprintf('HASIL VALIDASI FUNGSI HISTOGRAM\n');
fprintf('%-12s | %-10s | %-24s | %-13s\n', 'File Citra', 'Tipe Citra', 'Selisih Maksimum (Pixel)', 'Status');

for i = 1:length(images)
    img_path = fullfile('1. Histogram Citra', images{i});
    img_in   = imread(img_path);
    is_3ch   = (size(img_in, 3) == 3);
    
    % Cek Grayscale vs RGB
    is_grayscale = true;
    if is_3ch
        diff_rg = max(abs(double(img_in(:,:,1)) - double(img_in(:,:,2))), [], 'all');
        diff_rb = max(abs(double(img_in(:,:,1)) - double(img_in(:,:,3))), [], 'all');
        if diff_rg ~= 0 || diff_rb ~= 0
            is_grayscale = false;
        end
    end
    
    % Visualisasi Citra dan Histogram
    figure('Name', sprintf('Validasi Histogram: %s', images{i}), 'NumberTitle', 'off');
    if is_grayscale
        img_gray = img_in(:,:,1);
        [h_manual, ~] = manual_histogram(img_gray);
        h_ref         = imhist(img_gray);
        diff = max(abs(h_manual(:) - h_ref(:))); 
        if diff == 0
            status_str = 'IDENTIK';
        else
            status_str = 'TIDAK IDENTIK';
        end
        fprintf('%-12s | %-10s | %-24d | %-13s\n', ...
            images{i}, 'Grayscale', diff, status_str);
            
        subplot(1, 3, 1); imshow(img_gray); title(sprintf('%s (Grayscale)', images{i}));
        subplot(1, 3, 2); bar(0:255, h_manual, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2]); 
        title('Histogram Manual'); xlabel('Intensitas'); ylabel('Frekuensi'); grid on;
        subplot(1, 3, 3); bar(0:255, h_ref, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2]); 
        title('imhist MATLAB'); xlabel('Intensitas'); ylabel('Frekuensi'); grid on;
    else
        [h_mR, ~] = manual_histogram(img_in(:,:,1));
        [h_mG, ~] = manual_histogram(img_in(:,:,2));
        [h_mB, ~] = manual_histogram(img_in(:,:,3));
        h_rR = imhist(img_in(:,:,1));
        h_rG = imhist(img_in(:,:,2));
        h_rB = imhist(img_in(:,:,3));
        diff_R = max(abs(h_mR(:) - h_rR(:)));
        diff_G = max(abs(h_mG(:) - h_rG(:)));
        diff_B = max(abs(h_mB(:) - h_rB(:)));
        if (diff_R == 0 && diff_G == 0 && diff_B == 0)
            status_str = 'IDENTIK';
        else
            status_str = 'TIDAK IDENTIK';
        end
        diff_str = sprintf('R:%d, G:%d, B:%d', diff_R, diff_G, diff_B);
        fprintf('%-12s | %-10s | %-24s | %-13s\n', ...
            images{i}, 'RGB', diff_str, status_str);     
        subplot(1, 3, 1); imshow(img_in); title(sprintf('%s (RGB)', images{i}));
        subplot(1, 3, 2); 
        plot(0:255, h_mR, 'r', 0:255, h_mG, 'g', 0:255, h_mB, 'b', 'LineWidth', 1.2); 
        xlim([0 255]);
        title('Histogram Manual'); xlabel('Intensitas'); ylabel('Frekuensi'); grid on;
        subplot(1, 3, 3); 
        plot(0:255, h_rR, 'r', 0:255, h_rG, 'g', 0:255, h_rB, 'b', 'LineWidth', 1.2); 
        xlim([0 255]);
        title('imhist MATLAB'); xlabel('Intensitas'); ylabel('Frekuensi'); grid on;
    end
end
% =========================================================================
% IMAGE ENHANCEMENT (KASUS 4, IMAGE 03)
% =========================================================================
% Note: Sesuaikan input atau metode pada bagian #2 dan #5,
% Bagian lain relatif konstan kecuali jika diperlukan perubahan
clear; clc; close all;

% #1 PENGATURAN PATH
addpath(genpath('../../src'));
addpath(genpath('../../citra_test_images'));

% #2 INPUT DAN METADATA
img_path      = '5. Kasus 4/image_03.png'; % Ubah sesuai kasus dan citra uji yang digunakan
method_name   = 'Unprocessed';             % Ubah sesuai metode yang digunakan
method_params = 'None';                    % Ubah sesuai parameter yang digunakan

img_in = imread(img_path);

% #3 HANDLING TIPE CITRA (GRAYSCALE DAN RGB)
is_3ch = (size(img_in, 3) == 3);
is_grayscale = false;
if is_3ch
    diff_rg = max(abs(double(img_in(:,:,1)) - double(img_in(:,:,2))), [], 'all');
    diff_rb = max(abs(double(img_in(:,:,1)) - double(img_in(:,:,3))), [], 'all');
    if diff_rg == 0 && diff_rb == 0
        is_grayscale = true; 
    end
else
    is_grayscale = true;
end

% #4 ANALISIS STATISTIK DAN HISTOGRAM AWAL
if is_grayscale
    img_in_proc = img_in(:,:,1);
    [~, hist_in] = manual_histogram(img_in_proc);
    stats_in = struct('min', min(img_in_proc,[],'all'), ...
                      'max', max(img_in_proc,[],'all'), ...
                      'mean', mean(double(img_in_proc),'all'), ...
                      'std', std(double(img_in_proc),0,'all'));
else
    [~, hist_in_R] = manual_histogram(img_in(:,:,1));
    [~, hist_in_G] = manual_histogram(img_in(:,:,2));
    [~, hist_in_B] = manual_histogram(img_in(:,:,3));
    stats_in = struct('min',  [min(img_in(:,:,1),[],'all'), min(img_in(:,:,2),[],'all'), min(img_in(:,:,3),[],'all')], ...
                      'max',  [max(img_in(:,:,1),[],'all'), max(img_in(:,:,2),[],'all'), max(img_in(:,:,3),[],'all')], ...
                      'mean', [mean(double(img_in(:,:,1)),'all'), mean(double(img_in(:,:,2)),'all'), mean(double(img_in(:,:,3)),'all')], ...
                      'std',  [std(double(img_in(:,:,1)),0,'all'), std(double(img_in(:,:,2)),0,'all'), std(double(img_in(:,:,3)),0,'all')]);
end

% #5 PROSES ENHANCEMENT
method_name   = 'Image Filtering (Gaussian 3x3 + High-Boost Filter)';
method_params = '3x3 Gaussian Mask [1 2 1; 2 4 2; 1 2 1]/16, High-Boost Alpha = 1.2, Replicate Padding';
gaussian_3x3  = [1 2 1; 2 4 2; 1 2 1] / 16;
img_gauss = manual_linear_filter(img_in, gaussian_3x3, 'replicate');
lowpass_gauss   = manual_linear_filter(img_gauss, gaussian_3x3, 'replicate');
highpass_gauss  = double(img_gauss) - double(lowpass_gauss);
alpha     = 1.2;
img_out   = uint8(double(img_gauss) + (alpha - 1) * double(img_gauss) + highpass_gauss);

% #6 ANALISIS STATISTIK DAN HISTOGRAM AKHIR
if is_grayscale
    if is_3ch && size(img_out, 3) == 3
        img_out_proc = img_out(:,:,1);
    else
        img_out_proc = img_out;
    end
    [~, hist_out] = manual_histogram(img_out_proc);
    stats_out = struct('min', min(img_out_proc,[],'all'), ...
                       'max', max(img_out_proc,[],'all'), ...
                       'mean', mean(double(img_out_proc),'all'), ...
                       'std', std(double(img_out_proc),0,'all'));
else
    [~, hist_out_R] = manual_histogram(img_out(:,:,1));
    [~, hist_out_G] = manual_histogram(img_out(:,:,2));
    [~, hist_out_B] = manual_histogram(img_out(:,:,3));
    stats_out = struct('min',  [min(img_out(:,:,1),[],'all'), min(img_out(:,:,2),[],'all'), min(img_out(:,:,3),[],'all')], ...
                      'max',  [max(img_out(:,:,1),[],'all'), max(img_out(:,:,2),[],'all'), max(img_out(:,:,3),[],'all')], ...
                      'mean', [mean(double(img_out(:,:,1)),'all'), mean(double(img_out(:,:,2)),'all'), mean(double(img_out(:,:,3)),'all')], ...
                      'std',  [std(double(img_out(:,:,1)),0,'all'), std(double(img_out(:,:,2)),0,'all'), std(double(img_out(:,:,3)),0,'all')]);
end

% #7 RINGKASAN OUTPUT
if is_grayscale
    if is_3ch
        type_str = 'Grayscale (Pseudo-RGB 3 Channel)';
    else
        type_str = 'Grayscale (1 Channel)';
    end
else
    type_str = 'RGB (True Color 3 Channel)';
end

fprintf('\n--- INFORMASI CITRA DAN METODE ENHANCEMENT ---\n');
fprintf('File Citra : %s\n', img_path);
fprintf('Tipe Citra : %s\n', type_str);
fprintf('Metode     : %s\n', method_name);
fprintf('Parameter  : %s\n', method_params);

if is_grayscale
    fprintf('\n--- STATISTIK CITRA MASUKAN ---\n');
    fprintf('Min    : %3d\n', stats_in.min);
    fprintf('Max    : %3d\n', stats_in.max);
    fprintf('Mean   : %6.2f\n', stats_in.mean);
    fprintf('StdDev : %6.2f\n', stats_in.std);
    
    fprintf('\n--- STATISTIK CITRA HASIL ENHANCEMENT ---\n');
    fprintf('Min    : %3d\n', stats_out.min);
    fprintf('Max    : %3d\n', stats_out.max);
    fprintf('Mean   : %6.2f\n', stats_out.mean);
    fprintf('StdDev : %6.2f\n', stats_out.std);
else
    fprintf('\n--- STATISTIK CITRA MASUKAN ---\n');
    fprintf('Channel | Min | Max |   Mean   |  StdDev\n');
    fprintf('  R     | %3d | %3d | %8.2f | %8.2f\n', stats_in.min(1), stats_in.max(1), stats_in.mean(1), stats_in.std(1));
    fprintf('  G     | %3d | %3d | %8.2f | %8.2f\n', stats_in.min(2), stats_in.max(2), stats_in.mean(2), stats_in.std(2));
    fprintf('  B     | %3d | %3d | %8.2f | %8.2f\n', stats_in.min(3), stats_in.max(3), stats_in.mean(3), stats_in.std(3));
    
    fprintf('\n--- STATISTIK CITRA HASIL ENHANCEMENT ---\n');
    fprintf('Channel | Min | Max |   Mean   |  StdDev\n');
    fprintf('  R     | %3d | %3d | %8.2f | %8.2f\n', stats_out.min(1), stats_out.max(1), stats_out.mean(1), stats_out.std(1));
    fprintf('  G     | %3d | %3d | %8.2f | %8.2f\n', stats_out.min(2), stats_out.max(2), stats_out.mean(2), stats_out.std(2));
    fprintf('  B     | %3d | %3d | %8.2f | %8.2f\n', stats_out.min(3), stats_out.max(3), stats_out.mean(3), stats_out.std(3));
end

% #8 VISUALISASI PERBANDINGAN
figure('Name', ['Pengujian: ' img_path], 'NumberTitle', 'off');

% Citra Masukan vs Citra Hasil
subplot(2, 2, 1); imshow(img_in);  title('Citra Masukan');
subplot(2, 2, 2); imshow(img_out); title(['Hasil Enhancement: ' method_name]);

% Histogram Awal vs Histogram Hasil
subplot(2, 2, 3);
if is_grayscale
    bar(0:255, hist_in, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2]);
    title('Histogram Awal');
else
    plot(0:255, hist_in_R, 'r', 0:255, hist_in_G, 'g', 0:255, hist_in_B, 'b', 'LineWidth', 1.2);
    title('Histogram Awal (RGB)'); legend('R', 'G', 'B');
end
xlabel('Intensitas'); ylabel('Probabilitas'); grid on;

subplot(2, 2, 4);
if is_grayscale
    bar(0:255, hist_out, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2]);
    title('Histogram Hasil');
else
    plot(0:255, hist_out_R, 'r', 0:255, hist_out_G, 'g', 0:255, hist_out_B, 'b', 'LineWidth', 1.2);
    title('Histogram Hasil (RGB)'); legend('R', 'G', 'B');
end
xlabel('Intensitas'); ylabel('Probabilitas'); grid on;

% #9 EKSPLORASI I
% Analisis perbandingan metode image smoothing
img_g3 = img_gauss; 

gaussian_5x5 = [1  4  7  4  1;
    4 16 26 16  4;
    7 26 41 26  7;
    4 16 26 16  4;
    1  4  7  4  1] / 273;
img_g5 = manual_linear_filter(img_in, gaussian_5x5, 'replicate');

img_m3 = manual_nonlinear_filter(img_in, 3, 'median');

figure('Name', ['Eksplorasi I - Perbandingan Smoothing: ' img_path], 'NumberTitle', 'off');
subplot(2, 2, 1); imshow(img_in); title('Citra Masukan');
subplot(2, 2, 2); imshow(img_g3); title('Gaussian Filter 3x3');
subplot(2, 2, 3); imshow(img_g5); title('Gaussian Filter 5x5');
subplot(2, 2, 4); imshow(img_m3); title('Median Filter 3x3');

% #10 EKSPLORASI II
% Analisis pengujian image sharpening
lowpass_blur  = manual_linear_filter(img_in, gaussian_3x3, 'replicate');
highpass_diff = double(img_in) - double(lowpass_blur);

img_unsharp = uint8(double(img_in) + (1.0 * highpass_diff)); 
img_hb1     = uint8(((1.2 - 1) * double(img_in)) + highpass_diff); 
img_hb2     = uint8(((1.5 - 1) * double(img_in)) + highpass_diff); 

figure('Name', ['Eksplorasi II - Pengujian Sharpening: ' img_path], 'NumberTitle', 'off');
subplot(2, 2, 1); imshow(img_in);      title('Citra Masukan');
subplot(2, 2, 2); imshow(img_unsharp); title('Unsharp Masking (alpha = 1.0)');
subplot(2, 2, 3); imshow(img_hb1);     title('High-Boost Filter (alpha = 1.2)');
subplot(2, 2, 4); imshow(img_hb2);     title('High-Boost Filter (alpha = 1.5)');

% #11 EKSPLORASI III
% Penerapan High-Boost Filter pada citra hasil smoothing
alpha2 = 1.5;
img_kombinasi_a2 = uint8(double(img_gauss) + (alpha2 - 1) * double(img_gauss) + highpass_gauss);

figure('Name', ['Eksplorasi III - Penerapan High-Boost Filter setelah Smoothing: ' img_path], 'NumberTitle', 'off');
subplot(2, 2, 1); imshow(img_in);           title('1. Citra Masukan');
subplot(2, 2, 2); imshow(img_gauss);        title('Gaussian Filter 3x3 (Tanpa High-Boost)');
subplot(2, 2, 3); imshow(img_out);          title('Gaussian Filter 3x3 + High-Boost (alpha = 1.2)');
subplot(2, 2, 4); imshow(img_kombinasi_a2); title('Gaussian Filter 3x3 + High-Boost (alpha = 1.5)');


% #11 EKSPLORASI IV
% Perbandingan histogram Gaussian Filter 3x3 tanpa dan dengan High-Boost (alpha = 1.2)

[~, hist_gauss] = manual_histogram(img_gauss);
[~, hist_high_boost] = manual_histogram(img_out);

figure('Name', ['Eksplorasi IV - Perbandingan Histogram: ' img_path], 'NumberTitle', 'off');
subplot(2, 2, 1); 
imshow(img_gauss); 
title('Gaussian Filter 3x3 (Tanpa High-Boost)');
subplot(2, 2, 2); 
imshow(img_out); 
title('Gaussian Filter 3x3 + High-Boost (alpha = 1.2)');
subplot(2, 2, 3);
bar(0:255, hist_gauss, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2]);
title('Histogram Gaussian Filter 3x3 (Tanpa High-Boost)');
xlabel('Intensitas'); ylabel('Probabilitas'); grid on;
subplot(2, 2, 4);
bar(0:255, hist_high_boost, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2]);
title('Histogram Gaussian Filter 3x3 + High-Boost (alpha = 1.2)');
xlabel('Intensitas'); ylabel('Probabilitas'); grid on;
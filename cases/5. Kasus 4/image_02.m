% =========================================================================
% IMAGE ENHANCEMENT (KASUS 4, IMAGE 02)
% =========================================================================
% Note: Sesuaikan input atau metode pada bagian #2 dan #5,
% Bagian lain relatif konstan kecuali jika diperlukan perubahan
clear; clc; close all;

% #1 PENGATURAN PATH
addpath(genpath('../../src'));
addpath(genpath('../../citra_test_images'));

% #2 INPUT DAN METADATA
img_path      = '5. Kasus 4/image_02.png'; % Ubah sesuai kasus dan citra uji yang digunakan
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
method_name   = 'Nonlinear Filter';
method_params = 'Median Window 5x5 (RGB)';
img_out = zeros(size(img_in), 'like', img_in);
for c = 1:3
    img_out(:,:,c) = manual_nonlinear_filter(img_in(:,:,c), 5, 'median');
end

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
    xlim([0 255]);
end
xlabel('Intensitas'); ylabel('Probabilitas'); grid on;

subplot(2, 2, 4);
if is_grayscale
    bar(0:255, hist_out, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2]);
    title('Histogram Hasil');
else
    plot(0:255, hist_out_R, 'r', 0:255, hist_out_G, 'g', 0:255, hist_out_B, 'b', 'LineWidth', 1.2);
    title('Histogram Hasil (RGB)'); legend('R', 'G', 'B');
    xlim([0 255]);
end
xlabel('Intensitas'); ylabel('Probabilitas'); grid on;

% #9 EKSPLORASI TAMBAHAN
% Mencoba variasi ukuran window penapis median per kanal RGB: 3x3, 5x5, dan 7x7
img_m5 = img_out; % Hasil 5x5 dari Bagian #5 (Parameter Optimal)

img_m3 = zeros(size(img_in), 'like', img_in);
img_m7 = zeros(size(img_in), 'like', img_in);
for c = 1:3
    img_m3(:,:,c) = manual_nonlinear_filter(img_in(:,:,c), 3, 'median');
    img_m7(:,:,c) = manual_nonlinear_filter(img_in(:,:,c), 7, 'median');
end

figure('Name', ['Analisis Ukuran Window Median Filtering (RGB): ' img_path], 'NumberTitle', 'off');

subplot(2, 2, 1); imshow(img_in); 
title('Citra Masukan');

subplot(2, 2, 2); imshow(img_m3); 
title('Median Filter 3x3');

subplot(2, 2, 3); imshow(img_m5); 
title('Median Filter 5x5');

subplot(2, 2, 4); imshow(img_m7); 
title('Median Filter 7x7');
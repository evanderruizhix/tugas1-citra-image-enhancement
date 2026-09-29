% =========================================================================
% IMAGE ENHANCEMENT (KASUS 3, IMAGE 01)
% =========================================================================
% Note: Sesuaikan input atau metode pada bagian #2 dan #5,
% Bagian lain relatif konstan kecuali jika diperlukan perubahan
clear; clc; close all;

% #1 PENGATURAN PATH
addpath(genpath('../../src'));
addpath(genpath('../../citra_test_images'));

% #2 INPUT DAN METADATA
img_path      = '4. Kasus 3/image_01.png'; % Ubah sesuai kasus dan citra uji yang digunakan
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
method_name   = 'Intensity Transformation -> Contrast Stretching';
method_params = 'Min-Max Stretching';

if is_grayscale
    img_out = contrast_stretching(img_in_proc);
    if is_3ch
        img_out = cat(3, img_out, img_out, img_out);
    end
else
    img_out = zeros(size(img_in), 'like', img_in);
    for c = 1:3
        img_out(:,:,c) = contrast_stretching(img_in(:,:,c));
    end
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
% Perbandingan Contrast Stretching (Min-Max vs Percentile) dengan Histogram Equalization dan Gamma Correction

manual_r_min = 120;
manual_r_max = 201;

if is_grayscale
    img_cs_minmax_proc = contrast_stretching(img_in_proc); 
    img_cs_manual_proc = contrast_stretching(img_in_proc, manual_r_min, manual_r_max); 
    img_gamma_low_proc  = power_transform(img_in_proc, 1, 0.5);
    img_gamma_high_proc = power_transform(img_in_proc, 1, 1.5);
    img_he_proc         = histogram_equalization(img_in_proc);
    
    if is_3ch
        img_cs_minmax = cat(3, img_cs_minmax_proc, img_cs_minmax_proc, img_cs_minmax_proc);
        img_cs_manual = cat(3, img_cs_manual_proc, img_cs_manual_proc, img_cs_manual_proc);
        img_gamma_low  = cat(3, img_gamma_low_proc, img_gamma_low_proc, img_gamma_low_proc);
        img_gamma_high = cat(3, img_gamma_high_proc, img_gamma_high_proc, img_gamma_high_proc);
        img_he         = cat(3, img_he_proc, img_he_proc, img_he_proc);
    else
        img_cs_minmax = img_cs_minmax_proc;
        img_cs_manual = img_cs_manual_proc;
        img_gamma_low  = img_gamma_low_proc;
        img_gamma_high = img_gamma_high_proc;
        img_he         = img_he_proc;
    end
else
    img_cs_minmax = zeros(size(img_in), 'like', img_in);
    img_cs_manual = zeros(size(img_in), 'like', img_in);
    img_gamma_low  = zeros(size(img_in), 'like', img_in);
    img_gamma_high = zeros(size(img_in), 'like', img_in);
    img_he         = zeros(size(img_in), 'like', img_in);
    
    for c = 1:3
        img_cs_minmax(:,:,c) = contrast_stretching(img_in(:,:,c));
        img_cs_manual(:,:,c) = contrast_stretching(img_in(:,:,c), manual_r_min, manual_r_max);
        img_gamma_low(:,:,c)  = power_transform(img_in(:,:,c), 1, 0.5);
        img_gamma_high(:,:,c) = power_transform(img_in(:,:,c), 1, 1.5);
        img_he(:,:,c)         = histogram_equalization(img_in(:,:,c));
    end
end

figure('Name', ['Eksplorasi I - Perbandingan Variasi Enhancement: ' img_path], 'NumberTitle', 'off');
subplot(2, 3, 1); imshow(img_in);         title('1. Citra Masukan');
subplot(2, 3, 2); imshow(img_cs_minmax);  title('2. CS Default (Min-Max)');
subplot(2, 3, 3); imshow(img_cs_manual);  title(sprintf('3. CS Manual Range (%d-%d)', manual_r_min, manual_r_max));
subplot(2, 3, 4); imshow(img_he);         title('4. Histogram Equalization');
subplot(2, 3, 5); imshow(img_gamma_low);  title('5. Gamma Correction (gamma = 0.5)');
subplot(2, 3, 6); imshow(img_gamma_high); title('6. Gamma Correction (gamma = 1.5)');

% #10 EKSPLORASI II
% Analisis perbandingan Min-Max Stretching Default vs Manual Range beserta histogramnya

if is_grayscale
    [~, hist_in_val]     = manual_histogram(img_in_proc);
    [~, hist_minmax_val] = manual_histogram(img_cs_minmax_proc);
    [~, hist_manual_val] = manual_histogram(img_cs_manual_proc);
end

figure('Name', ['Eksplorasi II - Analisis Min-Max vs Manual Range Stretching: ' img_path], 'NumberTitle', 'off');
subplot(2, 3, 1); imshow(img_in);        title('1. Citra Masukan');
subplot(2, 3, 2); imshow(img_cs_minmax); title('2. CS Default (Min-Max)');
subplot(2, 3, 3); imshow(img_cs_manual); title(sprintf('3. CS Manual Range (%d-%d)', manual_r_min, manual_r_max));

subplot(2, 3, 4);
if is_grayscale
    bar(0:255, hist_in_val, 'BarWidth', 1, 'FaceColor', [0.3 0.3 0.3]);
else
    plot(0:255, hist_in_R, 'r', 0:255, hist_in_G, 'g', 0:255, hist_in_B, 'b', 'LineWidth', 1.2);
end
title('Histogram Citra Masukan');
xlabel('Intensitas'); ylabel('Probabilitas'); grid on; xlim([0 255]);

subplot(2, 3, 5);
if is_grayscale
    bar(0:255, hist_minmax_val, 'BarWidth', 1, 'FaceColor', [0.2 0.4 0.8]);
else
    [~, h_mm_R] = manual_histogram(img_cs_minmax(:,:,1));
    [~, h_mm_G] = manual_histogram(img_cs_minmax(:,:,2));
    [~, h_mm_B] = manual_histogram(img_cs_minmax(:,:,3));
    plot(0:255, h_mm_R, 'r', 0:255, h_mm_G, 'g', 0:255, h_mm_B, 'b', 'LineWidth', 1.2);
end
title('Histogram CS Default (Min-Max)');
xlabel('Intensitas'); ylabel('Probabilitas'); grid on; xlim([0 255]);

subplot(2, 3, 6);
if is_grayscale
    bar(0:255, hist_manual_val, 'BarWidth', 1, 'FaceColor', [0.8 0.2 0.2]);
else
    [~, h_man_R] = manual_histogram(img_cs_manual(:,:,1));
    [~, h_man_G] = manual_histogram(img_cs_manual(:,:,2));
    [~, h_man_B] = manual_histogram(img_cs_manual(:,:,3));
    plot(0:255, h_man_R, 'r', 0:255, h_man_G, 'g', 0:255, h_man_B, 'b', 'LineWidth', 1.2);
end
title(sprintf('Histogram CS Manual (%d-%d)', manual_r_min, manual_r_max));
xlabel('Intensitas'); ylabel('Probabilitas'); grid on; xlim([0 255]);
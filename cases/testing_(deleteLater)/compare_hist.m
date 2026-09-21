% TESTING SKRIP UJI DENGAN CITRA UJI DAN KODE FUNGSI PADA FOLDER TERPISAH
% (DELETE LATER)

addpath(genpath('../src'));
addpath(genpath('../citra_test_images'));

% Memanggil gambar uji langsung dari folder 'citra_test_images'
img = imread('1. Histogram Citra/image_04.png');

if size(img, 3) == 3
    img_gray = uint8(img(:, :, 1));
else
    img_gray = uint8(img);
end

% Memanggil fungsi manual yang tersimpan di dalam folder 'src/'
[counts_manual, Hist_manual] = manual_histogram(img_gray);

hist_native = imhist(img_gray);

figure;
subplot(1, 2, 1);
bar(0:255, counts_manual, 'BarWidth', 1, 'FaceColor', 'b');
title('Histogram Manual (Fungsi Sendiri)');
xlabel('Intensitas'); ylabel('Jumlah Piksel');
grid on;

subplot(1, 2, 2);
bar(0:255, hist_native, 'BarWidth', 1, 'FaceColor', 'r');
title('Histogram Native (imhist)');
xlabel('Intensitas'); ylabel('Jumlah Piksel');
grid on;

selisih = abs(counts_manual(:) - hist_native(:));
total_beda = sum(selisih);

fprintf('\n=== HASIL VALIDASI ===\n');
if total_beda == 0
    fprintf('SUCCESS: Hasil fungsi manual 100%% IDENTIK dengan imhist!\n');
else
    fprintf('WARNING: Terdapat perbedaan total %d piksel.\n', total_beda);
end

total_prob = sum(Hist_manual);
fprintf('Total Probabilitas Hist (Normalisasi): %.4f (Harus 1.0000)\n', total_prob);

indeks_beda = find(counts_manual(:) ~= hist_native(:));
if ~isempty(indeks_beda)
    fprintf('\n=== CUPLIKAN NILAI YANG BERBEDA (%d Intensitas Beda) ===\n', length(indeks_beda));
    fprintf('Intensitas (0-255) | Manual | imhist | Selisih\n');
    fprintf('-----------------------------------------------\n');
    
    jumlah_sampel = min(10, length(indeks_beda));
    for idx = 1:jumlah_sampel
        i = indeks_beda(idx);
        intensitas = i - 1;
        val_manual = counts_manual(i);
        val_native = hist_native(i);
        bedanya     = abs(val_manual - val_native);
        
        fprintf('       %3d         | %6d | %6d | %6d\n', ...
            intensitas, val_manual, val_native, bedanya);
    end
    
    if length(indeks_beda) > 10
        fprintf('... dan %d intensitas lainnya.\n', length(indeks_beda) - 10);
    end
else
    fprintf('\nTidak ada perbedaan nilai (100%% Identik)!\n');
end
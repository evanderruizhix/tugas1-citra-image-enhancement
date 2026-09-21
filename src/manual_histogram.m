function [h, p] = manual_histogram(Image)
    % Fungsi menghitung histogram citra berukuran M x N dengan 256 derajat keabuan (graylevel).  
    % Output:
    %   h : Frekuensi piksel (0..255)
    %   p : Probabilitas atau Normalisasi (float 0.0..1.0)
    
    % Ambil ukuran citra (M = jumlah baris, N = jumlah kolom)
    [M, N] = size(Image);
    
    % Inisialisasi h[0..255] dengan 0
    h = zeros(1, 256);
    
    % Hitung frekuensi piksel
    for i = 1:M
        for j = 1:N
            val = double(Image(i, j));
            h(val + 1) = h(val + 1) + 1;
        end
    end
    
    % Normalisasi p[i] dengan jumlah seluruh pixel
    n = M * N;
    p = zeros(1, 256);
    for i = 1:256
        p(i) = h(i) / n;
    end
end
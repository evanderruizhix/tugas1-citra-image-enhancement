function ImageOut = histogram_spesification(Image, Spec)
    % HISTOGRAM_SPESIFICATION
    % Fungsi untuk memetakan distribusi intensitas citra input yang mengikuti spesifikasi histogram target.
    % Input:
    %   Image : Matriks citra 2D (uint8)
    %   Spec  : Vektor 1x256 spesifikasi histogram target
    % Output:
    %   ImageOut : Matriks citra 2D hasil spesifikasi/matching (uint8)
    
    [N, M] = size(Image);
    Image = uint8(Image);
    
    % Hitung histogram dan probabilitas citra input
    [~, Hist] = manual_histogram(Image);
    
    % Hitung Histogram Equalization dari citra input
    HistInput = zeros(1, 256);
    sum_hist = 0.0;
    for i = 1:256
        sum_hist = sum_hist + Hist(i);
        HistInput(i) = floor(255 * sum_hist);
    end
    
    % Hitung Histogram Equalization dari histogram target
    HistSpec = zeros(1, 256);
    sum_spec = 0.0;
    for i = 1:256
        sum_spec = sum_spec + Spec(i);
        HistSpec(i) = floor(255 * sum_spec);
    end
    
    % Transformasi Balikan
    InvHist = zeros(1, 256);
    for i = 1:256
        minval = abs(HistInput(i) - HistSpec(1));
        minj = 1;
    
        for j = 1:256
            diff_val = abs(HistInput(i) - HistSpec(j));
            if diff_val < minval
                minval = diff_val;
                minj = j;
            end
        end    
        InvHist(i) = minj - 1;
    end
    
    % Update piksel citra sesuai hasil pemetaan
    ImageOut = zeros(N, M, 'uint8');
    for i = 1:N
        for j = 1:M
            pixel_val = double(Image(i, j));
            ImageOut(i, j) = uint8(InvHist(pixel_val + 1));
        end
    end
end
function ImageOut = histogram_equalization(Image)
    % HistOGRAM_EQUALIZATION
    % Fungsi untuk meratakan distribusi intensitas citra (perataan
    % Histogram)
    % Input:
    %   Image : Matriks citra 2D
    % Output:
    %   ImageOut : Matriks citra 2D hasil ekualisasi

    [n, m] = size(Image);
    Image = uint8(Image);
    total_pixels = n * m;

    % Membuat Histogram dari freq setiap intensitas
    Hist = zeros(1, 256);
    for i = 1:n
        for j = 1:m
            value = double(Image(i, j)) + 1;
            Hist(value) = Hist(value) + 1;
        end
    end

    % Menghitung probabilitas dan nilai CDF (Cumulative Distribution
    % Function)
    cdf = zeros(1, 256);
    sum_prob = 0.0;
    for i = 1:256
        prob = Hist(i) / total_pixels;
        sum_prob = sum_prob + prob;

        % Pemetaan ke grayscale baru (0 - 256)
        cdf(i) = floor(255 * sum_prob);
    end

    % Update pixel citra sesuai hasil pemetaan cdf
    ImageOut = zeros(n, m, 'uint8');
    for i = 1:n
        for j = 1:m
            pixel_value = double(Image(i, j));
            ImageOut(i, j) = uint8(cdf(pixel_value + 1));
        end
    end
end


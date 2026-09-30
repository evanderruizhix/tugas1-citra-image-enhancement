function ImageOut = log_transform(Image, c)
    % LOG_TRANSFORM
    % Fungsi untuk memetakan intensitas piksel menggunakan transformasi
    % logaritma
    % Input:
    %   Image : Matriks citra 2D (uint8)
    %   c     : Konstanta pengali agar kembali ke rentang 0-255
    % Output:
    %   ImageOut : Matriks citra 2D hasil transformasi 

    if nargin < 2
        c = 255/log(256);
    end

    [n, m] = size(Image);
    ImageOut = zeros(n, m, 'uint8');

    for i = 1:n
        for j = 1:m
            pixel_value = double(Image(i, j));

            % transformasi log: s = c* log(1 + r)
            value = c * log(1 + pixel_value);
            ImageOut(i, j) = uint8(value);
        end
    end
end
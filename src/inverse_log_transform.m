function ImageOut = inverse_log_transform(Image, c)
    % INVERSE_LOG_TRANSFORM
    % Fungsi untuk memetakan intesitas pixel menggunakan transformasi inverse logaritma
    % Input:
    %   Image : Matriks citra 2D (uint8)
    %   c     : Konstanta pengali agar kembali ke rentang 0-255
    % Output:
    %   ImageOut : Matriks citra 2D hasil transformasi 

    if nargin < 2
        c = 1;
    end

    [n, m] = size(Image);
    img_double = im2double(Image);
    img_out_double = zeros(n, m, 'double');

    for i = 1:n
        for j = 1:m
            img_out_double(i, j) = exp(img_double(i, j)^c) - 1;
        end
    end

    max_value = max(img_out_double(:));
    
    if max_value > 0
        img_out_double = img_out_double / max_value;
    end

    ImageOut = uint8(img_out_double * 255);
end
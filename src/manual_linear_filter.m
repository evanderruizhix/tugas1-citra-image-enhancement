function ImageOut = manual_linear_filter(Image, Mask, padding_type)
    % Melakukan filtering linear (konvolusi spasial) 2D pada citra grayscale.
    % Input:
    %   Image        : Matriks citra 2D M x N (uint8 atau double)
    %   Mask         : Matriks kernel 2D ukuran ganjil (K x K)
    %   padding_type : Metode padding tepi: 'replicate' (default) atau 'zero' (opsional)
    % Output:
    %   ImageOut     : Matriks citra 2D hasil filtering (uint8)
    
    if nargin < 3
        padding_type = 'replicate';
    end
    
    % Konversi citra input ke double untuk perhitungan konvolusi
    ImageDouble = double(Image);
    [M, N] = size(ImageDouble);
    [m_rows, m_cols] = size(Mask);
    
    % Hitung offset padding dari pusat mask
    pad_r = floor(m_rows / 2);
    pad_c = floor(m_cols / 2);
    
    % Rotasi mask 180 derajat untuk konvolusi spasial
    MaskRotated = zeros(m_rows, m_cols);
    for r = 1:m_rows
        for c = 1:m_cols
            MaskRotated(r, c) = Mask(m_rows - r + 1, m_cols - c + 1);
        end
    end
    
    % Membuat matriks padding
    PaddedImage = zeros(M + 2*pad_r, N + 2*pad_c);    
    PaddedImage(pad_r + 1 : pad_r + M, pad_c + 1 : pad_c + N) = ImageDouble;
    
    % Menangani batas tepi
    if strcmpi(padding_type, 'replicate')
        for r = 1:pad_r
            PaddedImage(r, pad_c + 1 : pad_c + N) = ImageDouble(1, :);
            PaddedImage(M + pad_r + r, pad_c + 1 : pad_c + N) = ImageDouble(M, :);
        end
        for c = 1:pad_c
            PaddedImage(:, c) = PaddedImage(:, pad_c + 1);
            PaddedImage(:, N + pad_c + c) = PaddedImage(:, N + pad_c);
        end
    end
    
    % Proses konvolusi spasial
    ResultDouble = zeros(M, N);
    for i = 1:M
        for j = 1:N
            sub_region = PaddedImage(i : i + m_rows - 1, j : j + m_cols - 1);
            pixel_sum = 0.0;
            for kr = 1:m_rows
                for kc = 1:m_cols
                    pixel_sum = pixel_sum + (sub_region(kr, kc) * MaskRotated(kr, kc));
                end
            end
            ResultDouble(i, j) = pixel_sum;
        end
    end
    
    % Clipping agar nilai piksel berada di rentang [0, 255]
    for i = 1:M
        for j = 1:N
            val = ResultDouble(i, j);
            if val < 0
                val = 0;
            elseif val > 255
                val = 255;
            end
            ResultDouble(i, j) = val;
        end
    end
    
    % Casting output ke uint8
    ImageOut = uint8(ResultDouble);
end
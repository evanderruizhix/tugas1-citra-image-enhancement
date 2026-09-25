function ImageOut = manual_nonlinear_filter(Image, window_size, filter_type)
    % Melakukan filtering non-linear (Median, Min, atau Max) pada citra grayscale 2D.
    % Input:
    %   Image       : Matriks citra 2D M x N (uint8 atau double)
    %   window_size : Window ukuran ganjil (integer)
    %   filter_type : Tipe filter: 'median' (default), 'min', atau 'max' (opsional)
    % Output:
    %   ImageOut    : Matriks citra 2D hasil filtering (uint8)
    
    if nargin < 3
        filter_type = 'median';
    end
    
    ImageDouble = double(Image);
    [M, N] = size(ImageDouble);
    pad_len = floor(window_size / 2);
    num_elements = window_size * window_size;
    
    % Membuat matriks padding
    PaddedImage = zeros(M + 2*pad_len, N + 2*pad_len);
    PaddedImage(pad_len + 1 : pad_len + M, pad_len + 1 : pad_len + N) = ImageDouble;
    
    % Menangani batas tepi
    for r = 1:pad_len
        PaddedImage(r, pad_len + 1 : pad_len + N) = ImageDouble(1, :);
        PaddedImage(M + pad_len + r, pad_len + 1 : pad_len + N) = ImageDouble(M, :);
    end
    for c = 1:pad_len
        PaddedImage(:, c) = PaddedImage(:, pad_len + 1);
        PaddedImage(:, N + pad_len + c) = PaddedImage(:, N + pad_len);
    end
    
    % Proses filtering non-linear
    ResultDouble = zeros(M, N);
    neighbors = zeros(1, num_elements);
    
    for i = 1:M
        for j = 1:N
            sub_region = PaddedImage(i : i + window_size - 1, j : j + window_size - 1);
            idx = 1;
            for kr = 1:window_size
                for kc = 1:window_size
                    neighbors(idx) = sub_region(kr, kc);
                    idx = idx + 1;
                end
            end
            for x = 1:(num_elements - 1)
                for y = 1:(num_elements - x)
                    if neighbors(y) > neighbors(y + 1)
                        temp = neighbors(y);
                        neighbors(y) = neighbors(y + 1);
                        neighbors(y + 1) = temp;
                    end
                end
            end
    
            % Filtering sesuai tipe (median, min, atau max)
            if strcmpi(filter_type, 'min')
                ResultDouble(i, j) = neighbors(1);
            elseif strcmpi(filter_type, 'max')
                ResultDouble(i, j) = neighbors(num_elements);
            else 
                mid_idx = ceil(num_elements / 2);
                ResultDouble(i, j) = neighbors(mid_idx);
            end
        end
    end
    
    % Casting output ke uint8
    ImageOut = uint8(ResultDouble);
end
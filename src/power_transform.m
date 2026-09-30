function ImageOut = power_transform(Image, c, gamma)
    % POWER_TRANSFORM
    % Fungsi untuk memetakan pixel menggunakan transformasi pangkat (gamma)
    %   Image : Matriks citra 2D (uint8)
    %   c     : Konstanta pengali (default 1)
    %   gamma : Nilai gamma
    % Output:
    %   ImageOut : Matriks citra 2D hasil transformasi

    if nargin < 2
        c = 1;
    end

    if nargin < 3
        gamma = 1;
    end 

    [n, m] = size(Image);
    ImageOut = zeros(n, m, 'uint8');

    for i = 1:n
        for j = 1:m

            % Normalisasi pixel ke rentang 0-1 untuk perhitungan pangkat
            r = double(Image(i, j)) / 255.0;

            % trans power: s = c * r^gamma
            value = c * (r^gamma) * 255.0;
            ImageOut(i, j) = uint8(value);
        end
    end
end


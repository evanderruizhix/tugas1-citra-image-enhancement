function ImageOut = image_negative(Image)
    % IMAGE_NEGATIVE
    % Fungsi untuk menghasilkan citra negatif
    % Input:
    %   Image : Matriks citra 2D
    % Output:
    %   ImageOut : Matriks citra 2D hasil negatif

    [n, m] = size(Image);
    Image = uint8(Image);
    ImageOut = zeros(n, m, 'uint8');

    for i = 1:n
        for j = 1:m
            ImageOut(i, j) = 255 - Image(i, j);
        end
    end
end
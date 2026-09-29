function ImageOut = contrast_stretching(Image, r_min, r_max)
    % Memetakan rentang piksel citra menggunakan Linear Contrast Stretching
    % Input:
    %   Image   : Matriks citra 2D (uint8 atau double)
    %   r_min   : Batas intensitas bawah (default: min nilai piksel asli)
    %   r_max   : Batas intensitas atas (default: max nilai piksel asli)
    % Output:
    %   ImageOut : Matriks citra 2D hasil peregangan (uint8)

    ImageDouble = double(Image);

    % Penanganan Parameter Default (min max contrast stretching)
    if nargin < 2 || isempty(r_min)
        r_min = min(ImageDouble(:));
    end
    if nargin < 3 || isempty(r_max)
        r_max = max(ImageDouble(:));
    end

    % Hindari pembagian 0
    if r_max == r_min
        ImageOut = uint8(ImageDouble);
        return;
    end
    fprintf('r_min: %.2f | r_max: %.2f\n', r_min, r_max);

    % Linear Contrast Stretching
    ImageStretched = (ImageDouble - r_min) * (255.0 / (r_max - r_min));

    % Clipping jika r_min dan r_max di luar/dalam rentang asli
    ImageStretched(ImageStretched < 0) = 0;
    ImageStretched(ImageStretched > 255) = 255;
    
    ImageOut = uint8(ImageStretched);
end
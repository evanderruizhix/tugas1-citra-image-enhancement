function ImageOut = contrast_stretching(Image, method, p_low, p_high)
    % Memetakan rentang piksel citra menggunakan Min-Max atau Percentile
    % Input:
    %   Image   : Matriks citra 2D (uint8 atau double)
    %   method  : 'minmax' (default) atau 'percentile'
    %   p_low   : Persentil batas bawah (default: 1 untuk percentile)
    %   p_high  : Persentil batas atas (default: 99 untuk percentile)
    % Output:
    %   ImageOut : Matriks citra 2D hasil peregangan (uint8)

    % Penanganan Parameter
    if nargin < 2 || isempty(method)
        method = 'minmax';
    end
    if nargin < 3 || isempty(p_low)
        p_low = 1;
    end
    if nargin < 4 || isempty(p_high)
        p_high = 99;
    end

    ImageDouble = double(Image);

    % Penentuan Nilai r_min dan r_max Berdasarkan Metode
    if strcmpi(method, 'percentile')
        r_min = prctile(ImageDouble(:), p_low);
        r_max = prctile(ImageDouble(:), p_high);
    else
        r_min = min(ImageDouble(:));
        r_max = max(ImageDouble(:));
    end

    % Hindari pembagian 0 jika citra bernilai konstan
    if r_max == r_min
        ImageOut = uint8(ImageDouble);
        return;
    end

    % Linear Contrast Stretching
    ImageStretched = (ImageDouble - r_min) * (255.0 / (r_max - r_min));

    % Clipping untuk Percentile Stretching
    ImageStretched(ImageStretched < 0) = 0;
    ImageStretched(ImageStretched > 255) = 255;
    
    ImageOut = uint8(ImageStretched);
end
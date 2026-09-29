function ImageOut = manual_high_boost(Image, Mask, alpha, padding_type)
    % Fungsi melakukan High-Boost Filtering pada citra (Output = alpha * Original - Lowpass).
    % Input:
    %   Image        : Matriks citra 2D M x N (uint8 atau double)
    %   Mask         : Matriks kernel lowpass filter
    %   alpha        : Faktor  pengali high-boost (alpha >= 1)
    %   padding_type : Metode penanganan batas citra ('replicate' atau 'zero')
    % Output:
    %   ImageOut     : Matriks citra hasil High-Boost Filtering (uint8)
    
    if nargin < 4, padding_type = 'replicate'; end
    if nargin < 3, alpha = 1.2; end

    ImageDouble = double(Image);
    
    % Lowpass dengan Linear Filter
    lowpass = double(manual_linear_filter(Image, Mask, padding_type));
    
    % Operasi High-Boost
    ResultDouble = alpha * ImageDouble - lowpass;
    
    % Clipping
    ResultDouble(ResultDouble < 0) = 0;
    ResultDouble(ResultDouble > 255) = 255;
    
    ImageOut = uint8(ResultDouble);
end
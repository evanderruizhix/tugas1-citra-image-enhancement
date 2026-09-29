function mainGUI()
    % PATH DAN INISIALISASI VARIABEL UTAMA
    addpath(genpath('src'));
    addpath(genpath('citra_test_images'));

    appData = struct();
    appData.originalImg = [];
    appData.imgHistory  = {}; 
    appData.histData    = {}; 
    appData.is3Ch       = false;
    appData.isGrayscale = true;
    appData.baseDir     = 'citra_test_images';

    % INISIALISASI MAIN WINDOW
    fig = figure('Name', 'Tugas 1 IF4073 - Analisis dan Perbaikan Kualitas Citra', ...
                 'NumberTitle', 'off', 'MenuBar', 'none', 'Resize', 'off', ...
                 'Position', [50, 50, 1320, 680]);

    % PANEL INPUT, PARAMETER, DAN STATISTIK
    pnlLeft = uipanel('Parent', fig, 'Title', 'Panel Kontrol & Analisis', ...
                      'FontWeight', 'bold', 'Units', 'pixels', 'Position', [10, 10, 480, 660]);

    % Input Citra
    pnlImg = uipanel('Parent', pnlLeft, 'Title', 'Input Citra', ...
                     'FontWeight', 'bold', 'Units', 'pixels', 'Position', [10, 556, 458, 88]);

    uicontrol('Parent', pnlImg, 'Style', 'text', 'String', 'Folder:', 'HorizontalAlignment', 'left', 'Position', [10, 42, 50, 20]);
    popFolder = uicontrol('Parent', pnlImg, 'Style', 'popupmenu', 'String', {'-'}, 'Position', [65, 40, 380, 25]);
    uicontrol('Parent', pnlImg, 'Style', 'text', 'String', 'File:', 'HorizontalAlignment', 'left', 'Position', [10, 12, 50, 20]);
    popFile = uicontrol('Parent', pnlImg, 'Style', 'popupmenu', 'String', {'-'}, 'Position', [65, 10, 290, 25]);
    
    set(popFolder, 'Callback', @(~,~) updateFileDropdown(popFolder, popFile));
    uicontrol('Parent', pnlImg, 'Style', 'pushbutton', 'String', 'Muat', 'FontWeight', 'bold', 'Position', [365, 10, 80, 25], 'Callback', @(~,~) loadImage());

    % Metode dan Parameter
    pnlMeth = uipanel('Parent', pnlLeft, 'Title', 'Metode dan Parameter', ...
                      'FontWeight', 'bold', 'Units', 'pixels', 'Position', [10, 328, 458, 220]);

    uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Metode:', 'HorizontalAlignment', 'left', 'Position', [10, 172, 50, 20]);
    
    metodeList = {'Contrast Stretching', 'Linear Filter', 'Non-linear Filter', ...
                  'High-Boost Filter', 'Histogram Equalization', 'Histogram Specification', ...
                  'Validasi Histogram'};
              
    popMethod = uicontrol('Parent', pnlMeth, 'Style', 'popupmenu', ...
                          'String', metodeList, 'Value', 1, 'Position', [65, 170, 380, 25], 'Callback', @methodChanged);
    % Kolom Input
    % Contrast Stretching
    txtKanalCS = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Kanal', 'FontWeight', 'bold', 'Position', [10, 145, 50, 18]);
    txtMinCS   = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Min Input', 'FontWeight', 'bold', 'Position', [70, 145, 180, 18]);
    txtMaxCS   = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Max Input', 'FontWeight', 'bold', 'Position', [260, 145, 180, 18]);
    txtR = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'R / Gray:', 'HorizontalAlignment', 'left', 'Position', [10, 118, 55, 20]);
    editRmin = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '-', 'Position', [70, 118, 180, 22]);
    editRmax = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '-', 'Position', [260, 118, 180, 22]);
    txtG = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'G:', 'HorizontalAlignment', 'left', 'Position', [10, 88, 55, 20]);
    editGmin = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '-', 'Position', [70, 88, 180, 22]);
    editGmax = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '-', 'Position', [260, 88, 180, 22]);
    txtB = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'B:', 'HorizontalAlignment', 'left', 'Position', [10, 58, 55, 20]);
    editBmin = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '-', 'Position', [70, 58, 180, 22]);
    editBmax = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '-', 'Position', [260, 58, 180, 22]);
    groupCS = [txtKanalCS, txtMinCS, txtMaxCS, txtR, editRmin, editRmax, txtG, editGmin, editGmax, txtB, editBmin, editBmax];

    % Linear dan High-Boost Filter
    txtDyn1 = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Matriks Kernel:', 'HorizontalAlignment', 'left', 'Position', [10, 122, 100, 20], 'Visible', 'off');
    editDyn1 = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '[1 2 1; 2 4 2; 1 2 1]/16', 'HorizontalAlignment', 'left', 'Position', [115, 122, 330, 22], 'Visible', 'off');
    txtDyn2 = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Padding:', 'HorizontalAlignment', 'left', 'Position', [10, 90, 100, 20], 'Visible', 'off');
    popDyn2 = uicontrol('Parent', pnlMeth, 'Style', 'popupmenu', 'String', {'replicate', 'zero'}, 'Position', [115, 88, 330, 25], 'Visible', 'off');
    txtDyn3 = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Alpha:', 'HorizontalAlignment', 'left', 'Position', [10, 58, 100, 20], 'Visible', 'off');
    editDyn3 = uicontrol('Parent', pnlMeth, 'Style', 'edit', 'String', '1.2', 'HorizontalAlignment', 'left', 'Position', [115, 58, 330, 22], 'Visible', 'off');
    groupDyn = [txtDyn1, editDyn1, txtDyn2, popDyn2, txtDyn3, editDyn3];
    
    % Histogram Specification
    txtRef1 = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'Folder Acuan:', 'HorizontalAlignment', 'left', 'Position', [10, 122, 100, 20], 'Visible', 'off');
    popRefFolder = uicontrol('Parent', pnlMeth, 'Style', 'popupmenu', 'String', {'-'}, 'Position', [115, 120, 330, 25], 'Visible', 'off');
    txtRef2 = uicontrol('Parent', pnlMeth, 'Style', 'text', 'String', 'File Acuan:', 'HorizontalAlignment', 'left', 'Position', [10, 90, 100, 20], 'Visible', 'off');
    popRefFile = uicontrol('Parent', pnlMeth, 'Style', 'popupmenu', 'String', {'-'}, 'Position', [115, 88, 330, 25], 'Visible', 'off');
    set(popRefFolder, 'Callback', @(~,~) updateFileDropdown(popRefFolder, popRefFile));
    groupRef = [txtRef1, popRefFolder, txtRef2, popRefFile];

    % Tombol Eksekusi
    btnProcess = uicontrol('Parent', pnlMeth, 'Style', 'pushbutton', 'String', 'Terapkan', 'FontWeight', 'bold', 'BackgroundColor', [0.15 0.55 0.25], 'ForegroundColor', 'white', 'Position', [10, 12, 140, 32], 'Callback', @(~,~) processImage());
    btnUndo = uicontrol('Parent', pnlMeth, 'Style', 'pushbutton', 'String', 'Undo Tahap', 'FontWeight', 'bold', 'BackgroundColor', [0.9 0.6 0.1], 'Position', [160, 12, 130, 32], 'Callback', @(~,~) undoImage());
    btnReset = uicontrol('Parent', pnlMeth, 'Style', 'pushbutton', 'String', 'Reset Semua Tahap', 'FontWeight', 'bold', 'BackgroundColor', [0.75 0.2 0.2], 'ForegroundColor', 'white', 'Position', [300, 12, 140, 32], 'Callback', @(~,~) resetImage());

    % INFORMASI CITRA DAN RIWAYAT
    pnlStatus = uipanel('Parent', pnlLeft, 'Title', 'Informasi Citra dan Riwayat Tahapan', 'FontWeight', 'bold', 'Units', 'pixels', 'Position', [10, 165, 458, 155]);
    lblFileInfo = uicontrol('Parent', pnlStatus, 'Style', 'text', 'String', 'File: -', 'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'Position', [10, 115, 438, 18], 'BackgroundColor', [0.94 0.94 0.94]);
    lblTypeInfo = uicontrol('Parent', pnlStatus, 'Style', 'text', 'String', 'Tipe: -', 'HorizontalAlignment', 'left', 'FontWeight', 'bold', 'Position', [10, 96, 438, 18], 'BackgroundColor', [0.94 0.94 0.94]);
    tblHistory = uitable('Parent', pnlStatus, 'ColumnName', {'Tahap', 'Metode', 'Parameter'}, 'ColumnWidth', {40, 120, 350}, 'RowName', [], 'Position', [6, 6, 442, 88]);

    % STATISTIK CITRA
    pnlMetrics = uipanel('Parent', pnlLeft, 'Title', 'Statistik Citra', 'FontWeight', 'bold', 'Units', 'pixels', 'Position', [10, 10, 458, 147]);
    tblMetrics = uitable('Parent', pnlMetrics, 'ColumnName', {'Fitur', 'Citra Masukkan', 'Citra Hasil Enhancement'}, 'ColumnWidth', {95, 160, 160}, 'RowName', [], 'Position', [6, 6, 442, 118]);

    % VISUALISASI CITRA BESERTA HISTOGRAMNYA
    pnlRight = uipanel('Parent', fig, 'Title', 'Visualisasi Citra (Masukkan dan Hasil Enhancement)', 'FontWeight', 'bold', 'Units', 'pixels', 'Position', [500, 10, 810, 660]);

    pnlToggle = uipanel('Parent', pnlRight, 'Title', 'Kanal Histogram (RGB)', 'FontWeight', 'bold', 'Units', 'pixels', 'Position', [440, 590, 350, 45]);
    chkR = uicontrol('Parent', pnlToggle, 'Style', 'checkbox', 'String', 'R', 'FontWeight', 'bold', 'ForegroundColor', [0.8 0 0], 'Value', 1, 'Position', [30, 6, 60, 20], 'Callback', @(~,~) refreshHistograms());
    chkG = uicontrol('Parent', pnlToggle, 'Style', 'checkbox', 'String', 'G', 'FontWeight', 'bold', 'ForegroundColor', [0 0.6 0], 'Value', 1, 'Position', [130, 6, 60, 20], 'Callback', @(~,~) refreshHistograms());
    chkB = uicontrol('Parent', pnlToggle, 'Style', 'checkbox', 'String', 'B', 'FontWeight', 'bold', 'ForegroundColor', [0 0 0.8], 'Value', 1, 'Position', [230, 6, 60, 20], 'Callback', @(~,~) refreshHistograms());

    axInImg   = axes('Parent', pnlRight, 'Position', [0.05, 0.54, 0.40, 0.33]);
    axInHist  = axes('Parent', pnlRight, 'Position', [0.54, 0.54, 0.41, 0.33]);
    axOutImg  = axes('Parent', pnlRight, 'Position', [0.05, 0.12, 0.40, 0.33]);
    axOutHist = axes('Parent', pnlRight, 'Position', [0.54, 0.12, 0.41, 0.33]);
    axis([axInImg axOutImg axInHist axOutHist], 'off');
    
    btnDownload = uicontrol('Parent', pnlRight, 'Style', 'pushbutton', 'String', 'Simpan Citra Hasil', ...
                            'FontWeight', 'bold', 'BackgroundColor', [0.1 0.4 0.6], 'ForegroundColor', 'white', ...
                            'Position', [40, 20, 330, 32], 'Enable', 'off', 'Callback', @(~,~) downloadImage());

    set([btnProcess, btnUndo, btnReset, chkR, chkG, chkB], 'Enable', 'off');

    refreshDirectories();

    % FUNGSI UTAMA
    % Fungsi Pembantu Update Ketersediaan Folder Dinamis
    function refreshDirectories()
        if ~exist(appData.baseDir, 'dir'), mkdir(appData.baseDir); end
        d = dir(appData.baseDir);
        isSub = [d(:).isdir];
        fldNames = {d(isSub).name}';
        fldNames(ismember(fldNames,{'.','..'})) = [];
        if isempty(fldNames), fldNames = {'(Kosong)'}; end
        
        set(popFolder, 'String', fldNames, 'Value', 1);
        set(popRefFolder, 'String', fldNames, 'Value', 1);
        
        updateFileDropdown(popFolder, popFile);
        updateFileDropdown(popRefFolder, popRefFile);
    end
    
    % Fungsi Pembantu Update Ketersediaan File Dinamis
    function updateFileDropdown(popFld, popFil)
        flds = get(popFld, 'String');
        selFld = flds{get(popFld, 'Value')};
        if strcmp(selFld, '(Kosong)')
            set(popFil, 'String', {'-'}, 'Value', 1); return;
        end
        f = dir(fullfile(appData.baseDir, selFld, '*.*'));
        fNames = {f(~[f.isdir]).name}';
        fNames = fNames(~startsWith(fNames, '.'));
        if isempty(fNames), fNames = {'(Kosong)'}; end
        set(popFil, 'String', fNames, 'Value', 1);
    end

    % Fungsi Pergantian Metode Enhancement
    function methodChanged(~, ~)
        val = get(popMethod, 'Value');
        set(groupCS, 'Visible', 'off');
        set(groupDyn, 'Visible', 'off');
        set(groupRef, 'Visible', 'off');
        
        if val == 1 % Contrast Stretching
            set(groupCS, 'Visible', 'on');
        elseif val == 2 % Linear Filter
            set([txtDyn1, editDyn1, txtDyn2, popDyn2], 'Visible', 'on');
            set(txtDyn1, 'String', 'Matriks Kernel:');
            if isempty(strfind(get(editDyn1, 'String'), '['))
                set(editDyn1, 'String', '[1 2 1; 2 4 2; 1 2 1]/16');
            end
            set(txtDyn2, 'String', 'Tipe Padding:');
            set(popDyn2, 'String', {'replicate', 'zero'}, 'Value', 1);
        elseif val == 3 % Non-Linear Filter
            set([txtDyn1, editDyn1, txtDyn2, popDyn2], 'Visible', 'on');
            set(txtDyn1, 'String', 'Ukuran Window (M x M):');
            set(editDyn1, 'String', '3');
            set(txtDyn2, 'String', 'Tipe Filter:');
            set(popDyn2, 'String', {'median', 'min', 'max'}, 'Value', 1);
        elseif val == 4 % High-Boost
            set([txtDyn1, editDyn1, txtDyn2, popDyn2, txtDyn3, editDyn3], 'Visible', 'on');
            set(txtDyn1, 'String', 'Matriks Lowpass:');
            if isempty(strfind(get(editDyn1, 'String'), '['))
                set(editDyn1, 'String', '[1 2 1; 2 4 2; 1 2 1]/16');
            end
            set(txtDyn2, 'String', 'Tipe Padding:');
            set(popDyn2, 'String', {'replicate', 'zero'}, 'Value', 1);
        elseif val == 5 % Histogram Equalization
            % Tanpa parameter
        elseif val == 6 % Histogram Specification
            set(groupRef, 'Visible', 'on');
        elseif val == 7 % Validasi Histogram
            % Tanpa parameter
        end
    end

    % Fungsi Memuat Citra
    function loadImage()
        folders = get(popFolder, 'String'); folderSelected = folders{get(popFolder, 'Value')};
        files = get(popFile, 'String'); fileSelected = files{get(popFile, 'Value')};
        if strcmp(folderSelected, '(Kosong)') || strcmp(fileSelected, '(Kosong)'), return; end
        
        imgPath = fullfile(appData.baseDir, folderSelected, fileSelected);
        if ~exist(imgPath, 'file'), errordlg('File tidak ditemukan!', 'Error File'); return; end

        img = imread(imgPath);
        appData.originalImg = img;
        appData.imgHistory  = {img};
        appData.histData = {0, 'Citra Masukkan Awal', '-'};
        
        appData.is3Ch = (size(img, 3) == 3);
        appData.isGrayscale = false;
        if appData.is3Ch
            if max(abs(double(img(:,:,1)) - double(img(:,:,2))), [], 'all') == 0 && max(abs(double(img(:,:,1)) - double(img(:,:,3))), [], 'all') == 0
                appData.isGrayscale = true;
            end
        else
            appData.isGrayscale = true;
        end

        set(lblFileInfo, 'String', ['File: ', fileSelected]);
        if appData.isGrayscale
            set(lblTypeInfo, 'String', 'Tipe: Grayscale');
        else
            set(lblTypeInfo, 'String', 'Tipe: RGB');
        end

        imgD = double(img);
        if appData.isGrayscale
            set(txtR, 'String', 'Gray:');
            set(editRmin, 'String', num2str(min(imgD(:)))); set(editRmax, 'String', num2str(max(imgD(:))));
            set([editGmin, editGmax, editBmin, editBmax], 'String', '-', 'Enable', 'off', 'BackgroundColor', [0.9 0.9 0.9]);
            set([chkR, chkG, chkB], 'Enable', 'off', 'Value', 0);
        else
            set(txtR, 'String', 'R:');
            set(editRmin, 'String', num2str(min(min(imgD(:,:,1))))); set(editRmax, 'String', num2str(max(max(imgD(:,:,1)))));
            set(editGmin, 'String', num2str(min(min(imgD(:,:,2)))), 'Enable', 'on', 'BackgroundColor', 'white');
            set(editGmax, 'String', num2str(max(max(imgD(:,:,2)))), 'Enable', 'on', 'BackgroundColor', 'white');
            set(editBmin, 'String', num2str(min(min(imgD(:,:,3)))), 'Enable', 'on', 'BackgroundColor', 'white');
            set(editBmax, 'String', num2str(max(max(imgD(:,:,3)))), 'Enable', 'on', 'BackgroundColor', 'white');
            set([chkR, chkG, chkB], 'Enable', 'on', 'Value', 1);
        end

        set([btnProcess, btnReset], 'Enable', 'on');
        set([btnUndo, btnDownload], 'Enable', 'off');
        methodChanged(); 
        updateVisuals();
    end

    % Fungsi Pemrosesan Metode Enhancement yang Digunakan
    function processImage()
        imgIn = appData.imgHistory{end}; 
        metodeVal = get(popMethod, 'Value');

        % Validasi Histogram (Tanpa Enhancement)
        if metodeVal == 7
            files = get(popFile, 'String'); 
            fileSelected = files{get(popFile, 'Value')};
            runHistogramValidation(imgIn, fileSelected);
            return;
        end

        imgOut = zeros(size(imgIn), 'like', imgIn);
        namaMetode = '';
        paramStr = '';

        try
            if metodeVal == 1
                namaMetode = 'Contrast Stretching';
                rmin = str2double(get(editRmin, 'String')); rmax = str2double(get(editRmax, 'String'));
                if appData.isGrayscale
                    imgOut = contrast_stretching(imgIn(:,:,1), rmin, rmax);
                    if appData.is3Ch, imgOut = cat(3, imgOut, imgOut, imgOut); end
                    paramStr = sprintf('Gray: [%g, %g]', rmin, rmax);
                else
                    gmin = str2double(get(editGmin, 'String')); gmax = str2double(get(editGmax, 'String'));
                    bmin = str2double(get(editBmin, 'String')); bmax = str2double(get(editBmax, 'String'));
                    imgOut(:,:,1) = contrast_stretching(imgIn(:,:,1), rmin, rmax);
                    imgOut(:,:,2) = contrast_stretching(imgIn(:,:,2), gmin, gmax);
                    imgOut(:,:,3) = contrast_stretching(imgIn(:,:,3), bmin, bmax);
                    paramStr = sprintf('R:[%g,%g] G:[%g,%g] B:[%g,%g]', rmin, rmax, gmin, gmax, bmin, bmax);
                end
                
            elseif metodeVal == 2
                namaMetode = 'Linear Filter';
                maskStr = get(editDyn1, 'String'); Mask = str2num(maskStr); %#ok<ST2NM>
                pad_opts = get(popDyn2, 'String'); pad_type = pad_opts{get(popDyn2, 'Value')};
                if appData.isGrayscale
                    imgTemp = manual_linear_filter(imgIn(:,:,1), Mask, pad_type);
                    if appData.is3Ch, imgOut = cat(3, imgTemp, imgTemp, imgTemp); else, imgOut = imgTemp; end
                else
                    for c = 1:3, imgOut(:,:,c) = manual_linear_filter(imgIn(:,:,c), Mask, pad_type); end
                end
                paramStr = sprintf('Kernel: %s, Pad: %s', maskStr, pad_type);
                
            elseif metodeVal == 3
                namaMetode = 'Non-Linear Filter';
                w_size = str2double(get(editDyn1, 'String'));
                type_opts = get(popDyn2, 'String'); filt_type = type_opts{get(popDyn2, 'Value')};
                if appData.isGrayscale
                    imgTemp = manual_nonlinear_filter(imgIn(:,:,1), w_size, filt_type);
                    if appData.is3Ch, imgOut = cat(3, imgTemp, imgTemp, imgTemp); else, imgOut = imgTemp; end
                else
                    for c = 1:3, imgOut(:,:,c) = manual_nonlinear_filter(imgIn(:,:,c), w_size, filt_type); end
                end
                paramStr = sprintf('Tipe: %s, Window: %dx%d', upper(filt_type), w_size, w_size);

            elseif metodeVal == 4
                namaMetode = 'High-Boost Filter';
                maskStr = get(editDyn1, 'String'); Mask = str2num(maskStr); %#ok<ST2NM>
                pad_opts = get(popDyn2, 'String'); pad_type = pad_opts{get(popDyn2, 'Value')};
                alpha = str2double(get(editDyn3, 'String'));
                if appData.isGrayscale
                    imgTemp = manual_high_boost(imgIn(:,:,1), Mask, alpha, pad_type);
                    if appData.is3Ch, imgOut = cat(3, imgTemp, imgTemp, imgTemp); else, imgOut = imgTemp; end
                else
                    for c = 1:3, imgOut(:,:,c) = manual_high_boost(imgIn(:,:,c), Mask, alpha, pad_type); end
                end
                paramStr = sprintf('Lowpass: %s, Pad: %s, A: %.2f', maskStr, pad_type, alpha);
                
            elseif metodeVal == 5
                namaMetode = 'Histogram Equalization';
                if appData.isGrayscale
                    imgTemp = histogram_equalization(imgIn(:,:,1));
                    if appData.is3Ch, imgOut = cat(3, imgTemp, imgTemp, imgTemp); else, imgOut = imgTemp; end
                else
                    for c = 1:3, imgOut(:,:,c) = histogram_equalization(imgIn(:,:,c)); end
                end
                paramStr = '-';
                
            elseif metodeVal == 6
                namaMetode = 'Histogram Specification';
                fRef = get(popRefFolder, 'String'); fRef = fRef{get(popRefFolder, 'Value')};
                files = get(popRefFile, 'String'); fileRef = files{get(popRefFile, 'Value')};
                if strcmp(fRef, '(Kosong)') || strcmp(fileRef, '(Kosong)')
                    error('Silakan pilih citra acuan terlebih dahulu!');
                end
                
                imgRef = imread(fullfile(appData.baseDir, fRef, fileRef));
                if appData.isGrayscale
                    if size(imgRef, 3) == 3, imgRef = rgb2gray(imgRef); end
                    [~, Spec] = manual_histogram(imgRef(:,:,1));
                    imgTemp = histogram_spesification(imgIn(:,:,1), Spec);
                    if appData.is3Ch, imgOut = cat(3, imgTemp, imgTemp, imgTemp); else, imgOut = imgTemp; end
                else
                    if size(imgRef, 3) == 1, imgRef = cat(3, imgRef, imgRef, imgRef); end
                    for c = 1:3
                        [~, Spec] = manual_histogram(imgRef(:,:,c));
                        imgOut(:,:,c) = histogram_spesification(imgIn(:,:,c), Spec);
                    end
                end
                paramStr = sprintf('Citra Acuan: %s', fileRef);
            end
        catch ME
            errordlg(ME.message, 'Validasi Input Gagal'); return;
        end

        appData.imgHistory{end+1} = imgOut;
        tahapKe = length(appData.imgHistory) - 1;
        appData.histData(end+1, :) = {tahapKe, namaMetode, paramStr};
        
        set([btnUndo, btnDownload], 'Enable', 'on');
        updateVisuals();
    end
    
    % Validasi Histogram
    function runHistogramValidation(img, fileName)
        isGray = appData.isGrayscale;
        
        if isGray
            ch1 = img(:,:,1);
            [~, hManual] = manual_histogram(ch1);
            hManual = double(hManual(:));
            
            hMatlab = double(imhist(ch1));
            if sum(hManual) <= 1.5 
                hMatlab = hMatlab / numel(ch1);
            end
            
            diffVals = abs(hManual - hMatlab);
            maxDiff = max(diffVals);
            maeDiff = mean(diffVals);
            
            statusStr = 'PASSED (Identik)';
            statusColor = [0 0.5 0];
            if maxDiff > 1e-4
                statusStr = 'FAILED (Berbeda)';
                statusColor = [0.8 0 0];
            end
            
            dlg = figure('Name', 'Status Validasi Histogram', 'NumberTitle', 'off', ...
                         'MenuBar', 'none', 'Resize', 'off', 'WindowStyle', 'modal', ...
                         'Position', [500, 350, 460, 260]);
                     
            uicontrol('Parent', dlg, 'Style', 'text', 'String', 'Hasil Validasi Histogram (Manual vs imhist)', ...
                      'FontWeight', 'bold', 'Position', [20, 220, 420, 22], 'HorizontalAlignment', 'center');
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', ['File Citra: ', fileName], ...
                      'Position', [30, 185, 400, 20], 'HorizontalAlignment', 'left');
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', 'Tipe Citra: Grayscale', ...
                      'Position', [30, 165, 400, 20], 'HorizontalAlignment', 'left');
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', sprintf('Max Difference : %.6f', maxDiff), ...
                      'Position', [30, 135, 400, 20], 'HorizontalAlignment', 'left');
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', sprintf('Mean Abs Error  : %.6f', maeDiff), ...
                      'Position', [30, 115, 400, 20], 'HorizontalAlignment', 'left');
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', ['Status: ', statusStr], ...
                      'FontWeight', 'bold', 'ForegroundColor', statusColor, ...
                      'Position', [30, 80, 400, 20], 'HorizontalAlignment', 'left');
                  
            uicontrol('Parent', dlg, 'Style', 'pushbutton', 'String', 'Tutup', 'FontWeight', 'bold', ...
                      'Position', [180, 20, 100, 32], 'Callback', @(~,~) close(dlg));
        else
            maxDiffs = zeros(1, 3);
            maeDiffs = zeros(1, 3);
            
            for c = 1:3
                ch = img(:,:,c);
                [~, hManual] = manual_histogram(ch);
                hManual = double(hManual(:));
                
                hMatlab = double(imhist(ch));
                if sum(hManual) <= 1.5
                    hMatlab = hMatlab / numel(ch);
                end
                
                diffVals = abs(hManual - hMatlab);
                maxDiffs(c) = max(diffVals);
                maeDiffs(c) = mean(diffVals);
            end
            
            overallMax = max(maxDiffs);
            overallMae = mean(maeDiffs);
            
            statusStr = 'PASSED (Identik)';
            statusColor = [0 0.5 0];
            if overallMax > 1e-4
                statusStr = 'FAILED (Berbeda)';
                statusColor = [0.8 0 0];
            end
            
            % Modal Dialog RGB
            dlg = figure('Name', 'Status Validasi Histogram', 'NumberTitle', 'off', ...
                         'MenuBar', 'none', 'Resize', 'off', 'WindowStyle', 'modal', ...
                         'Position', [500, 300, 480, 340]);
                     
            uicontrol('Parent', dlg, 'Style', 'text', 'String', 'Hasil Validasi Histogram (Manual vs imhist)', ...
                      'FontWeight', 'bold', 'Position', [20, 300, 440, 22], 'HorizontalAlignment', 'center');
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', ['File Citra: ', fileName], ...
                      'Position', [30, 268, 420, 20], 'HorizontalAlignment', 'left');
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', 'Tipe Citra: RGB', ...
                      'Position', [30, 248, 420, 20], 'HorizontalAlignment', 'left');
                  
            tblData = {
                'Red (R)', sprintf('%.6f', maxDiffs(1)), sprintf('%.6f', maeDiffs(1));
                'Green (G)', sprintf('%.6f', maxDiffs(2)), sprintf('%.6f', maeDiffs(2));
                'Blue (B)', sprintf('%.6f', maxDiffs(3)), sprintf('%.6f', maeDiffs(3));
                'KESELURUHAN', sprintf('%.6f', overallMax), sprintf('%.6f', overallMae)
            };
            
            uitable('Parent', dlg, 'Data', tblData, ...
                    'ColumnName', {'Kanal', 'Max Diff', 'Mean Error (MAE)'}, ...
                    'ColumnWidth', {110, 130, 150}, 'RowName', [], ...
                    'Position', [30, 108, 420, 125]);
                  
            uicontrol('Parent', dlg, 'Style', 'text', 'String', ['Status: ', statusStr], ...
                      'FontWeight', 'bold', 'ForegroundColor', statusColor, ...
                      'Position', [30, 72, 420, 20], 'HorizontalAlignment', 'left');
                  
            uicontrol('Parent', dlg, 'Style', 'pushbutton', 'String', 'Tutup', 'FontWeight', 'bold', ...
                      'Position', [190, 18, 100, 32], 'Callback', @(~,~) close(dlg));
        end
    end

    % Fungsi Menyimpan Citra
    function downloadImage()
        if length(appData.imgHistory) < 2, return; end
        prompt = {'Masukkan nama file (tanpa ekstensi .png):'};
        dlgtitle = 'Simpan Citra Hasil';
        dims = [1 50];
        definput = {'hasil_enhancement_01'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        if isempty(answer), return; end
        
        fileName = [answer{1}, '.png'];
        saveDir = fullfile(appData.baseDir, '6. Hasil Enhancement');
        if ~exist(saveDir, 'dir'), mkdir(saveDir); end
        
        fullPath = fullfile(saveDir, fileName);
        try
            imwrite(appData.imgHistory{end}, fullPath);
            msgbox(['Berhasil menyimpan citra di: ', fullPath], 'Sukses Menyimpan');
            refreshDirectories();
        catch ME
            errordlg(['Gagal menyimpan citra: ', ME.message], 'Error Menyimpan');
        end
    end
    
    % Fungsi Undo Tahapan Enhancement
    function undoImage()
        if length(appData.imgHistory) > 1
            appData.imgHistory(end) = [];
            appData.histData(end, :) = [];
            if length(appData.imgHistory) == 1
                set([btnUndo, btnDownload], 'Enable', 'off'); 
            end
            updateVisuals();
        end
    end

    % Fungsi Reset Tahapan Enhancement
    function resetImage()
        if isempty(appData.imgHistory), return; end
        appData.imgHistory = {appData.imgHistory{1}}; 
        appData.histData = appData.histData(1, :);
        set([btnUndo, btnDownload], 'Enable', 'off');
        updateVisuals();
    end

    % Fungsi Perubahan Antarmuka Setelah Pemrosesan
    function updateVisuals()
        imgOrig = appData.imgHistory{1};
        imgCurr = appData.imgHistory{end};

        axis([axInImg axOutImg], 'on');
        imshow(imgOrig, 'Parent', axInImg); title(axInImg, 'Citra Masukkan');
        imshow(imgCurr, 'Parent', axOutImg); title(axOutImg, 'Citra Hasil Enhancement');
        refreshHistograms();

        statsIn = calculateStats(imgOrig, appData.isGrayscale);
        statsOut = calculateStats(imgCurr, appData.isGrayscale);
        if appData.isGrayscale
            tblData = {
                'Min', num2str(statsIn.min(1)), num2str(statsOut.min(1));
                'Max', num2str(statsIn.max(1)), num2str(statsOut.max(1));
                'Mean', sprintf('%.2f', statsIn.mean(1)), sprintf('%.2f', statsOut.mean(1));
                'Std Dev', sprintf('%.2f', statsIn.std(1)), sprintf('%.2f', statsOut.std(1));
            };
        else
            tblData = {
                'Min (R,G,B)', sprintf('%d, %d, %d', statsIn.min), sprintf('%d, %d, %d', statsOut.min);
                'Max (R,G,B)', sprintf('%d, %d, %d', statsIn.max), sprintf('%d, %d, %d', statsOut.max);
                'Mean', sprintf('%.1f, %.1f, %.1f', statsIn.mean), sprintf('%.1f, %.1f, %.1f', statsOut.mean);
                'Std Dev', sprintf('%.1f, %.1f, %.1f', statsIn.std), sprintf('%.1f, %.1f, %.1f', statsOut.std);
            };
        end
        set(tblMetrics, 'Data', tblData);
        set(tblHistory, 'Data', appData.histData);
    end

    % Fungsi Perubahan Histogram Setelah Pemrosesan
    function refreshHistograms()
        if isempty(appData.imgHistory), return; end
        axis([axInHist axOutHist], 'on');
        plotCustomHistogram(axInHist, appData.imgHistory{1}, 'Histogram Citra Masukkan');
        plotCustomHistogram(axOutHist, appData.imgHistory{end}, 'Histogram Citra Hasil Enhancement');
    end
    
    % Fungsi Plot Histogram Manual
    function plotCustomHistogram(targetAx, img, titleText)
        cla(targetAx, 'reset'); hold(targetAx, 'on');
        if appData.isGrayscale
            [~, hVal] = manual_histogram(img(:,:,1));
            bar(targetAx, 0:255, hVal, 'BarWidth', 1, 'FaceColor', [0.2 0.2 0.2], 'EdgeColor', 'none');
            legend(targetAx, 'hide'); 
        else
            showR = get(chkR, 'Value'); showG = get(chkG, 'Value'); showB = get(chkB, 'Value');
            legendLabels = {};
            if showR, [~, hVal] = manual_histogram(img(:,:,1)); plot(targetAx, 0:255, hVal, 'r', 'LineWidth', 1.2); legendLabels{end+1} = 'R'; end
            if showG, [~, hVal] = manual_histogram(img(:,:,2)); plot(targetAx, 0:255, hVal, 'g', 'LineWidth', 1.2); legendLabels{end+1} = 'G'; end
            if showB, [~, hVal] = manual_histogram(img(:,:,3)); plot(targetAx, 0:255, hVal, 'b', 'LineWidth', 1.2); legendLabels{end+1} = 'B'; end
            if ~isempty(legendLabels), legend(targetAx, legendLabels, 'Location', 'northeast'); else, legend(targetAx, 'hide'); end
        end
        title(targetAx, titleText); xlabel(targetAx, 'Intensitas'); ylabel(targetAx, 'Probabilitas');
        targetAx.XLim = [0 255]; grid(targetAx, 'on'); hold(targetAx, 'off');
    end

    function stats = calculateStats(img, isGray)
        if isGray
            imgP = double(img(:,:,1));
            stats.min = min(imgP, [], 'all'); stats.max = max(imgP, [], 'all');
            stats.mean = mean(imgP, 'all'); stats.std = std(imgP, 0, 'all');
        else
            stats.min = [min(img(:,:,1),[],'all'), min(img(:,:,2),[],'all'), min(img(:,:,3),[],'all')];
            stats.max = [max(img(:,:,1),[],'all'), max(img(:,:,2),[],'all'), max(img(:,:,3),[],'all')];
            stats.mean = [mean(double(img(:,:,1)),'all'), mean(double(img(:,:,2)),'all'), mean(double(img(:,:,3)),'all')];
            stats.std = [std(double(img(:,:,1)),0,'all'), std(double(img(:,:,2)),0,'all'), std(double(img(:,:,3)),0,'all')];
        end
    end
end
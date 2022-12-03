function [denoised, error] = denoise(s, problemType, option, lvl)
% DENOISE removes the noise from the input signal 's' using the chosen denoising regime 'option.'
% DENOISE takes 's' as a vector and will return a denoised vector of the same length.
% 'ProblemType' is a categorical integer whichspecifies if the problem is (1) short-term, (2) long-term, 
% or (3) interpolation. Option is the denoising regime. Valid options are
% currently "fourier" and "wavelet." 'lvl' is the wavelet decomposition
% level parameter.

%% Use a Fourier decomposition to denoise the data
% The filter type can change.
if option == "fourier"
    dt = 3;
    Fs = 1/dt;
    cut = 1/60/30;
    stpns = 0.95;
    % recall that 's' is the input signal
    denoised = lowpass(s,cut,Fs,'Steepness',stpns);
end
  
%% Use wavelets to denoise the data
% From https://www.mathworks.com/help/wavelet/ug/one-dimensional-discrete-wavelet-analysis.html

% TO DO:
% Search for the right wavelet to use and to what level we should
% decompose the signal
%   Need to write it all down on a spreadsheet, ideally with
%   documentation of the plots we looked at and a few words about which
%   features we care about within the plot.

% disp("(DENOISE.m) using option = 'wavelet'");

if option ~= "fourier" % assumes that you can choose ONLY fourier or wavelet
    % Get the signal, s, and the length of the range for cleaning
    l_s = length(s);

    % Perform a multilevel decomposition of the signal using the
    % Daubechies-1 ('db1') wavelet (Haar wavelet) for starters.
    wvlt = char(option);

    % Use a set the level of decomposition we would like to perform.
    % This is passed into the function as a parameter but I will leave the
    % line below here to make it 
    % lvl = 7;
    % https://www.mathworks.com/help/wavelet/gs/introduction-to-the-wavelet-families.html
    [C, L] = wavedec(s, lvl, wvlt);

    % Extract aproximation coefficients
    cA3 = appcoef(C, L, wvlt, lvl);
    % Extract the detail coefficients for levels 1, 2,..., lvl
    % [cD1,cD2,cD3] = detcoef(C, L, [1, 2, 3]); %(note: this is being
    % converted into a parametric formulation)
    cD = detcoef(C, L, 1:lvl);

    % Reconstruct the LVL-level approximation
    A = wrcoef('a', C, L, wvlt, lvl);
    % Reconstruct the details at levels 1, 2,...,lvl from C and store in
    % the columns of the detail matrix D. D1 is column 1, D2 column 2,
    % and so on.
    for i = 1:lvl
        D(:, i) = wrcoef('d', C, L, wvlt, i); 
    end

    % Denoise the signal, but better (tune the wavelet contributions 
    % through thresholding, as oppposed to straight removal)
    [thr,sorh,keepapp] = ddencmp('den','wv', s); 
    clean = wdencmp('gbl',C,L,option,lvl,thr,sorh,keepapp);

%     % Reconstruct the original signal from the LVL-level decomposition
%     A0 = waverec(C, L, wvlt);
    % Reconstruct the original signal from the LVL-level decomposition
    % using the first half (rounded up) of the levels
    A0 = waverec(C, L, wvlt);

    % Reconstruction LVL-level decomposition error
    lvlERR = max(abs(s-A0));
    % Thresholding decomposition error
    thrERR = max(abs(s-clean));

    % Denoise the signal using the optimal number of of intervals
    [sDen,~,thrParams,~,BestNbOfInt] = cmddenoise(s,option,lvl);
    sDen = sDen'; % need it as a column, not a row
    
    plotOn = false; % Set TRUE when optimizing and debugging, FALSE when running testingFile.m!
    if plotOn == true % so that it's easy to turn plotting on and off without slowing down RMSE calculations
        % Display the results of the multilevel decomposition
        nCols = 2; % how many columns of plots in the subplot
        nRows = floor((lvl+1)/nCols) + (mod(lvl+1, nCols) ~= 0); % how many rows in subplot
        
        % Plot the reconstructed aproximation coefficients
        subplot(nRows,nCols,1); plot(A);  
        title(['Approximation A' int2str(lvl)]) 
        for i = 1 : lvl
            subplot(nRows,nCols,i+1); plot(D(:, i));  
            title(['Detail D' int2str(i)])
        end

        % Check wavelet aproximation
        figure();
        subplot(2,3,1); plot(s);
        title('Original');
        axis off
        subplot(2,3,4); plot(A);
        title(['Level ' int2str(lvl) ' Wavelet Approximation']);
        axis off
    
        % Plot the crudely denoised signal
        subplot(2,3,2); plot(s); title('Original Signal') 
        subplot(2,3,5); plot(clean); title('Crude Denoising')
        % Plot the threshold denoised signal
        subplot(2,3,3); plot(s); title('Original Signal') 
        subplot(2,3,6); plot(clean); title('Threshold Denoising')

        % Plot the autodenoised signal using cmddenoise
        figure();
        plot(sDen);

    end
    
%     denoised = A0; % return the reconstructed crudely denoised signal
    denoised = clean; % return the threshold reconstructed signal
%     denoised = sDen; % return the autodenoised signal
end

end % end of file

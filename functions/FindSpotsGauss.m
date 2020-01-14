function [fishAnalysisData] = FindSpotsGauss(varargin)
    G = varargin{1};
    Bits = varargin{2};
    f = varargin{3};
    PathToSave = varargin{4};
    threshold = varargin{5};

    % '' as argument will generate default parameters
    params = getFishAnalysisParams('');
    fishAnalysisData.params = params;
    %fishAnalysisData.params.outputFileID = [PathToSave,'/fout.txt'];
    %fout = fishAnalysisData.params.outputFileID;
    %fishAnalysisData.params.DoG_center = 
    %fishAnalysisData.params.DoG_surround = 
    %fishAnalysisData.params.DoG_filterSize = 
    % Size of snippets of bright spots to store on disc, deafault 0
    %fishAnalysisData.params.fit_store3dSnippetSize == 0;
    

    % As one of the diagnostic plots, we will be saving the histograms of pixel
    % intensity distributions before and after DoG filtering. Prepare for saving these
    % plots by determining the bins locations.
    
    % This would be nice, but costs too much:
    %   maxIntensityOrig = single(max(imageStack(:))); 
    % So, instead:
    maxIntensityOrig = 2.^Bits -1;
    
    binEdges = linspace(0,maxIntensityOrig,100);
    % To make sure we do not lose values that are out of bounds: pixel intensities can
    % certainly not fall below 0, but what if DoG filterted image turns out ot have
    % higher intensity pixels than maxIntensityOrig?
    binEdges = [binEdges, inf];

    freqCountsDog = zeros(size(binEdges));
    freqCountsOrig= zeros(size(binEdges));
    
    % Size of snippets of bright spots to store on disc
    % When we will have detected columns, we will discard most of these and arrange the
    % remaining ones into the 3d snippets to store with detected spots.
    if fishAnalysisData.params.fit_store3dSnippetSize == 0
        snipSize = 0;
    else
        % add a margin to take into account the possible shift between shadows' xy
        % coordinates
        snipSize = fishAnalysisData.params.fit_store3dSnippetSize + fishAnalysisData.params.shadow_dist;
    end
    
    % Go frame by frame through the stack. Filter each image with the DoG filter and
    % detect bright spots (i.e. local maxima).
    %
    % DoG filtering is implemented by imfilter, which can accept a 3d image directly.
    % But filtering the whole stack would require a lot of memory (to store the original
    % stack and the filtered stack, instead of the original stack and one filtered
    % frame), so let's go frame by frame. (This should let us treat larger stacks.)
    brightSpots=[];
    
    % Save how many bright spots there are on each layer (we will need this information
    % every time we will be preallocating memory for treating spots frame by frame) 
    % brightSpotsFrameDistribution(i) is the index of the first bright spot that is NOT
    % on layers 1...i-1. In other words, it is the index of the first bright spot on
    % layer i, and brightSpotsFrameDistribution(sizeZ+1) = totalNumberOfSpots + 1.
    %brightSpotsFrameDistribution=zeros(1,sizeZ+1);
    brightSpotsFrameDistribution=zeros(1,size(G,3)+1);
    brightSpotsFrameDistribution(1)=1;
    if snipSize>0
        brightSpotSnippets = zeros([0, 2*snipSize+1, 2*snipSize+1], 'uint16');
    else
        brightSpotSnippets = [];
    end
    
    % when to threshold
    if threshold == Inf
        fishAnalysisData.params.saveDogImages=true;
        mkdir([PathToSave,'/DOGs/'])
    end
    %threshold = 0;
    %
    %
for z=1:size(G,3)
    originalFrame = G(:,:,z);
        %originalFrame=getImageFrame(handleIAI, frame);
        dogFilteredFrame = dogFilter(originalFrame,fishAnalysisData);        
    
    %fprintf(fout,' averaging filter...');
    filt = fspecial('gaussian', fishAnalysisData.params.DoG_filterSize, ...
                                    fishAnalysisData.params.DoG_center);
    avgFrame = imfilter(originalFrame, filt, 'replicate');
    %fprintf(fout,' searching for local maxima...');
        
    % findLocalMaxima only returns local maxima that are further than some minimal
        % distance from the edges, so we don't have to worry about out-of-bounds error.
        %z = 1; 
        
        newBrightSpots=findLocalMaxima(dogFilteredFrame,z,threshold,fishAnalysisData);
        
        spotIdx = sub2ind(size(originalFrame), ...
                  newBrightSpots(:,2), newBrightSpots(:,1));
        dogs = single(dogFilteredFrame(spotIdx));
        raw = single(avgFrame(spotIdx));
                
        brightSpotsFrameDistribution(z+1)=brightSpotsFrameDistribution(z)+...
            size(newBrightSpots,1);

        brightSpots = [brightSpots;
            newBrightSpots, dogs, raw]; %#ok<AGROW>
        
     %%% Diagnostics %%%
        if fishAnalysisData.params.saveDogImages            
            % Save the DOG filtered image to the diagnostics folder.
            %[ignore,name] = fileparts(...
            %    fishAnalysisData.stackDescription.channels(ch(1)).imageStackFileNames{z});
            name = ['f',num2str(f),'z',num2str(z)];
            % Multiply by 10 because single -> uint16 loses precision
            imwrite(uint16(10*dogFilteredFrame),...
               [PathToSave,'/DOGs/','DOG_x10_', '_', name, '.tif']);
        end
        
        % Frequency counts of pixel intenities of this frame before DoG filtering
        frameFreqCount=histc(originalFrame(:),binEdges);
        freqCountsOrig = freqCountsOrig + frameFreqCount';
        
        % Frequency counts of pixel intenities of this frame after DoG filtering
        frameFreqCount=histc(dogFilteredFrame(:),binEdges);
        freqCountsDog = freqCountsDog + frameFreqCount';
    %%% End(Diagnostics) %%%
    end
    
    %fprintf('\tThe unfiltered "bright spots" list contains %d entries.\n',...
     %   size(brightSpots, 1));
    
    if ~isempty(brightSpotSnippets)
        %fprintf(fout,'\tSaving the preliminary list of bright spot snippets.\n');
        save(fullfile(fishAnalysisData.stackDescription.adjustments,...
            ['BRIGHT_SPOT_SNIPPETS_', channelGroupPrefix]),'brightSpotSnippets','-v7.3');
    end
    
    %fishAnalysisData.channels(ch).brightSpotsFrameDistribution=brightSpotsFrameDistribution;
        
%%% Diagnostics %%%
    if ~isempty(brightSpots)
        %diagFigure = figure;
        bins = min(brightSpots(:,4)):fishAnalysisData.params.autoThreshold_binSize:max(brightSpots(:,4));

        %clf;
        %[n, xout] = hist(brightSpots(:,4));
        %bar(xout, n);
        %hold on;
        %title('Spot density as a function of threshold (before shadow column filtering)');
        %xlabel('Threshold')
        %saveDiagnosticFigure(ch(1), diagFigure,'thresholdSelectionDog.tif',fishAnalysisData);

        %close(diagFigure);
    end
    
    
    fishAnalysisData.stackDescription.overrideParams = '';
    fishAnalysisData.stackSize(1) = size(G,1);
    fishAnalysisData.stackSize(2) = size(G,2);
    fishAnalysisData.stackSize(3) = size(G,3);
    groupInfo.brightSpotsLocations = brightSpots(:,1:3);
    groupInfo.brightSpotsIntensities = brightSpots(:,4:end);
    groupInfo.brightSpotsFrameDistribution = brightSpotsFrameDistribution;
    groupInfo.ch = 0;
            % Select from the list of brightSpots the points that look like they might be true spots
            % or shadows of true spots
            %fprintf(fout,'Filtering "bright spots" to determine spot candidates...\n');
            groupInfo = chooseCandidateSpots(groupInfo, fishAnalysisData);        
    brightSpotsIntensities = groupInfo.brightSpotsIntensities;
     
    fishAnalysisData.channels.fits = fitCandidateSpots(...
                    G, groupInfo, brightSpotsIntensities, fishAnalysisData);  
                
    
    fishAnalysisData.channels.brightSpots = ...
                [groupInfo.brightSpotsLocations brightSpotsIntensities];
            fishAnalysisData.channels.brightestZ = groupInfo.brightestZ;
            fishAnalysisData.channels.brightestN = groupInfo.brightestN;
            fishAnalysisData.channels.brightSpotsFrameDistribution = ...
                groupInfo.brightSpotsFrameDistribution;
      
end
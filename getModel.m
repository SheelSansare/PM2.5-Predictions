% Get model to fit data

function testOutput = getModel(trainData, testData, modelType)
    % test output is the predicted value on testData using the learned model 
    % model Type is type of model we will use in this case 
    
    % Linear
    if modelType == "linear"
        % formation of the vector necessary for the 
        [Y,X] = min2Hour(trainData); % Converting seconds data to hour data
        n = length(X);  % % getting the length of the training data set
        Xtrain = [ones(n,1) datenum(X)];  % Creating nx2 time vector matrix
        Ytrain = Y; % the actual value at training locations
        [Ytest,Xt] = min2Hour(testData);
        ntest = length(Xt);  % hourly converted data
        Xtest = [ones(ntest,1) datenum(Xt)];
        
        B = pinv(Xtrain'*Xtrain)*Xtrain'*Ytrain;
        testOutput = B'*Xtest';
    
    % Polynomial
    elseif modelType == "polynomial"
        %% closed end solution for the polynomial regression based on the degree
        degree = 25;
        [Y,X] = min2Hour(trainData);
        [p,s] = polyfit(datenum(X),Y,degree);
        [testOutput, delta] = polyval(p, datenum(X), s);
    
    % Gaussian Process
    elseif modelType == "gaussianProcess"
        %% getting train variables which are lat,long and time
        train_time = datenum(trainData.time)-min(datenum(trainData.time));
        train_lat = trainData.lat;
        train_lon = trainData.lon;
        train_tmp = trainData.tmp;
        train_hmd = trainData.hmd;
        train_spd = trainData.spd;
        
        %% obtain the max lat and lon which is used for normalization/standardization
        
        % making x_train and y_train and feeding it to the gaussian process regression model
        % Use the normalized data (scaled to be between 0 and 1)
        
        % x_train = [normalize(train_time,'range'), normalize(train_lat,'range') , normalize(train_lon,'range'),normalize(train_tmp,'range'), normalize(train_hmd,'range'), normalize(train_spd,'range')];
        %x_train = [normalize(train_time,'range'), normalize(train_lat,'range') , normalize(train_lon,'range'), normalize(train_hmd,'range')];
        x_train = [normalize(train_time, 'range')];
        
        y_train = trainData.pm2d5;
        
        %% inserting the initial parameters for the kernel function which need to be tuned
        d = size(x_train,2);
        kparams = 4*ones(d,1); % This is the parameter need to be optimised and its importance has to be understood
        sigma0 = 1;
        gprMdl = fitrgp(x_train,y_train,'KernelFunction','ardexponential','KernelParameters',[kparams;sigma0],'Sigma',sigma0);
        
        %% forming the test data just like train data and normalizing it on basis of the train data
        test_time = datenum(testData.time) - min(datenum(trainData.time));
        test_lat = testData.lat;
        test_lon = testData.lon;
        test_hmd = testData.hmd;
        test_spd= testData.spd;
        test_tmp= testData.tmp;
        
        %% Normalizing the test data set
        test_time = (test_time-min(train_time))/(max(train_time)-min(train_time));
        %test_lat = (test_lat-min(train_lat))/(max(train_lat)-min(train_lat));
        %test_lon = (test_lon-min(train_lon))/(max(train_lon)-min(train_lon));
        %test_hmd = (test_hmd-min(train_hmd))/(max(train_hmd)-min(train_hmd));
        % test_spd = (test_spd-min(train_spd))/(max(train_spd)-min(train_spd));
        % test_tmp = (test_tmp-min(train_tmp))/(max(train_tmp)-min(train_tmp));
        
        %% formation of the x_test used as input into the gaussian model to predict the values
        % x_test = [test_time, test_lat, test_lon, test_tmp, test_hmd, test_spd];
        %x_test = [test_time, test_lat, test_lon, test_hmd];
        x_test = [test_time];
        
        %% output vector from the gaussian model
        % testOutput is the predicted output value on the test data
        testOutput = predict(gprMdl,x_test);
    end
    
    %  figure()
    %  plot((1:d)',log(sigmaM),'ro-');
    %  xlabel('Length scale number');
    %  ylabel('Log of length scale'); 
end

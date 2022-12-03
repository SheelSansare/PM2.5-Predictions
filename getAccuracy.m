function accuracy=getAccuracy(testOutput,actualTestValue)
%% testOutput is the predicted output value on the test dataset
%% actualTestValue is the actual value of Test dataset
%% accuracy is the singular double value defining the the accuracy of the predicted values
% [Y, X] = min2Hour(actualTestValue);
% actualTestValue = table(X, Y);
% rng(1)  % set random seed
% cv = cvpartition(size(actualTestValue,1),'HoldOut',0.2); % 5-fold cross-validation
% % Note: actualTestValue should be a nx1 vector
% idx_tmp = cv.test;    % obtain test data indices
accuracy = (sqrt(mse(testOutput,actualTestValue)));
% for assignemnt 3 using ridge regression, their codes got 1.2, we got
% 1.8812
% calculate RMSE between testOutput and actualTestValue 
end
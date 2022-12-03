function [gradient,cost] = errorFunc(X,Y,params)
%% Parameters are the unknowns which are used to define our model. (Vector of size n)
%% Cost is the error on our train data. Single double value
%% Gradient: How we want to update our parameters. Vector of doubles whose size is equal to the parameter size
%% (number of parameters)
%% X is the input feature vector for training set
%% Y is the actual pm2d5 value for training set

cost = sum(sum((Y - params * X').^2))/2/(length(X));
disp(cost)
gradient = 2*(cost)^0.5 * sum(X,1);
end
clear; close all; clc

train = readtable('ANN_IN2.csv');

train = train(1:2500,:);

test = readtable('ANN_OUT.csv');

rng('default')
t = templateTree('Reproducible',true);

Mdl1 = fitrensemble(train,'Var46','OptimizeHyperparameters','auto','Learners',t, ...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'));

hs = predict(Mdl1,test);
Hs = test.Var46(:);

plot(hs, Hs, '.')
xlim([0 6])
ylim([0 6])


plot(Hs)
hold on
plot(hs)

legend('Buoy', 'Radar')


mse1 = resubLoss(Mdl1);



SST = sum((Hs - mean(Hs, 'omitnan')).^2, 'omitnan');
SSR = sum((Hs - hs).^2, 'omitnan');

R2 = 1-(SSR/SST);

error = hs-Hs;

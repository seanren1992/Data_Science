%% Model Predictions
%  David Li 

close all, clear all, clc
%% Importing response data

data = dataset('xlsfile', 'ResponseData.xls');

%% Characterize the response surfaces for 4 surrogate effects 

EffectName = {'Algometry'    'Tetany'    'Sedation'    'Laryingoscopy'};

for i = 1:length(EffectName)
    
    [fitresults(i), gof(i)] = myCreateSurfaceFit(data.Propofol, data.Remifentanil, data.(EffectName{i}), EffectName{i}) ;  %#ok<SAGROW>
    disp([' Model for ', EffectName{i}, '  is '])
    disp(fitresults{i})
    disp('... and GOF is ')
    disp(gof(i))
    
end

%%  Assessment of model predictions 

valData = dataset('xlsfile', 'ValidationData.xls');

% Evaluate surface at concentration in validation data
valData.Algometry       = fitresults{1}(valData.Propofol, valData.Remifentanil) ;
valData.Tetany          = fitresults{2}(valData.Propofol, valData.Remifentanil) ;
valData.Sedation        = fitresults{3}(valData.Propofol, valData.Remifentanil) ;
valData.Laryingoscopy   = fitresults{4}(valData.Propofol, valData.Remifentanil) ;

valData


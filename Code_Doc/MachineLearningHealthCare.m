%% Health Care Classification Analytics (Machine Learning)
%  David Li 

%% Import Data and Explore Variables 
% Use a function genenrated by the Import Tool to import several columns
% from the data file.

Arrhythmia = importArrhythmia('arrhythmia.data');

% Providing good variable names for later use in Visualization.
varnames = {'age','sex','height','weight','QRSduration','PRinterval',...
    'QTinterval','Tinterval','Pinterval','heartrate','diagnosis'};

%% Explore variables 

gscatter(Arrhythmia(:,1) ,Arrhythmia(:,10) ,Arrhythmia(:,11));
xlabel('Age'); ylabel('Heart Rate'); legend('normal', 'abnormal');

%% Covaraince Matrix 

covmat = corrcoef(Arrhythmia);
plotCovarianceMatrix(covmat,varnames);

%% Separate Data

X = Arrhythmia(:,1:end-1);
Y = Arrhythmia(:,end);


%% Exploratory Visualizations

diagnosis = cell(size(Y));
for i = 1:numel(Y)
    if Y(i) == 1
        diagnosis{i} = 'Normal';
    else 
        diagnosis{i} = 'Abnormal';
    end
end
gplotmatrix(X,[],diagnosis,[],'^+',[],[],'hist',varnames(1:10),varnames(1:10))
figure; 
parallelcoords(X,'group',diagnosis,'labels',varnames(1:10));
figure;
andrewsplot(X,'group',diagnosis)

%% Partitoin Data 

c2 = cvpartition(Y, 'holdout');
Xtrain = X(training(c2, 1),:);
Xtest = X(test(c2, 1),:);
Ytrain = Y(training(c2, 1));
Ytest = Y(test(c2,1));

%% SVM Classifier 

SVMmodel = fitcsvm(Xtrain,Ytrain);
Ypredict = classificationSVM(SVMmodel,Xtest);
CMat_SVM = confusionmat(Ypredict,Ytest);
disp('SVM Classifier Confusion Matrix: ')
disp(CMat_SVM)
loss_SVM = (sum(sum(CMat_SVM))-sum(diag(CMat_SVM)))/sum(sum(CMat_SVM));
disp (['SVM Classifier Loss is: ', num2str(loss_SVM*100),'%'])

%% Improved SVM Classifier

n=0;
C_start=0.2;C_step=0.05;C_end=1;
for ker = 1:4
    
    for C = C_start:C_step:C_end
        
        
        try
            switch ker 
                case 1 
                    SVMkernel = 'linear';
                case 2
                    SVMkernel = 'rbf';
                case 3 
                    SVMkernel = 'quadratic';
                case 4 
                    SVMkernel = 'polynomial';
            end 
            
            
            
            SVMmodel = fitsvm(Xtrain,Ytrain,'boxconstraint',C,'Kernel_Function',SVMkernel);
            Ypredict = classificationSVM(SVMmodel,Xtest);
            CMat_SVM = confusionmat(Ypredict,Ytest);
            loss_SVM = (sum(sum(CMat_SVM))-sum(diag(CMat_SVM)))/sum(sum(CMat_SVM));
            
            
            n=n+1;
            model_res{n} = SVMmodel; loss_res{n} = loss_SVM;Cmat_res{n} = CMat_SVM;SVMker{n} = SVMkernel; Cvec{n} = C;
            
        catch me
            n=n+1;
            model_res{n} = nan;loss_res{n} = nan;Cmat_res{n} = nan;SVMker{n} = nan;Cvec{n} = nan;
        end 
    end 
end 
losMat = reshape(loss_res,numel(C_start:C_step:C_end),[]);
[Xg,Yg] = meshgrid(C_start:C_step:C_end,1:4);
h=surf(xg,yg,losMat');
ylabel('Kernal')
xlabel('C')
zlabel('Loss')
ax = get(h,'Parent');
set(ax,'Ytrick',1:4,'YTrickLabel',{'linear','rbf','quadratic','polynomial'})
[bestSVMloss,ind] = min(loss_res);
disp('Best SVM Classifier Confusion Matrix: ')
disp(Cmat_res{ind})
disp(['Best SVM Classifier Loss is: ',num2str(bestSVMloss*100),'%'])
disp(['Using ',SVMker{ind},' Kenal function and C=',num2str(cvec(ind))]);

%% Neural Networks - Setting up network 
% Create a Pattern Recognition Network

hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 70/100;

%% Train the Network 

Y_NN = [(Y==1) (Y==2)];
[net,tr] = train(net,X',Y_NN');
X_test = X(tr.testInd,:)';
Y_test = Y(tr.testInd,:)';
Y_test_NN = [(Y_test==1) ;(Y_test==2)];

OUTtest = net(X_test);

[~,CMAT_NN,~,~] = condusion(Y_test_NN,OUTtest);
loss_NN = (sum(sum(CMAT_NN))-sum(diag(CMAT_NN)))/sum(sum(CMAT_NN));
disp('NN Classifier Confusion Matrix:')
disp(CMAT_NN)
disp(['NN Classifier Loss is: ', num2str(loss_NN*100),'%'])

%% Naive Bayes Classifier

baymodel =  NaiveBayes.fit(Xtrain,Ytrain,'Distribution','Kernel');
Ypredict = predict(baymodel,Xtest);

%%  Results of Naive Bayes Classifier

disp(1-(sum(Ytest~=Ypredict)/length(Ytest)));
confusionmat(Ypredict, Ytest)

%% Sequential Feature Selection

if parpool('size') == 0
    parpool open 2
end 
opts = statset('display','iter','useparallel','always');

fun = @(Xtrain,Ytrain,Xtest,Ytest)...
    sum(Ytest~=predict(NaiveBaves.fit(Xtrain,Ytrain,'Distribution','kernel'), Xtest));

fs = sequentialfs(fun,X,Y,'cv',c2,'options',opts);

%% Prediction Using significant Variables

Ypredict = predict(NaiveBayes.fit(Xtrain(:,fs),Ytrain,'Distribution','Kernel'), Xtest(:,fs));
disp(1-(sum(Ytest~=Ypredict)/lenght(Ytest)));
confusionmat(Ypredict, Ytest)








library(AppliedPredictiveModeling)
data(solubility)

library(shiny)
library(caret)
library(nnet)




# get the RMSE and Rsquared for an lm model of the box-cox transformed parameters
# these are the baseline values against which the nnet model will be evaluated
linear<-function(trainingData, testingData) {
  lmTrainingData<-trainingData
  lmTrainingData$Solubility<-solTrainY
  lmFit<-lm(Solubility ~ .,data = lmTrainingData)
  
  lmPred<-predict(lmFit, testingData)
  lmSummary<-defaultSummary(data.frame(obs=solTestY, pred=lmPred))
  lmSummary
}

# single neural netowrk
nnSingle<-function(trainingData, testingData, inputNumHiddenNodes, inputDecay) {
  
    
  singleNnetFit<-reactive({nnet(trainingData, solTrainY, size = inputNumHiddenNodes, decay = inputDecay,
                linout = TRUE, trace = FALSE, maxit = 500, 
                MaxNWts = inputNumHiddenNodes * (ncol(trainingData) + 1) + inputNumHiddenNodes + 1)})
  
  
  singleNnetPred<-reactive({predict(singleNnetFit(), testingData)})
  singleNnetSummary<-reactive({defaultSummary(data.frame(obs=solTestY, pred=singleNnetPred()))})
}


#average of 'n' neural netowrks
nnAverage<-function(trainingData, testingData, inputNumHiddenNodes, inputDecay, inputNumModels) {
  
  
  
  avgNnetFit<-reactive({avNNet(trainingData, solTrainY, size = inputNumHiddenNodes, decay = inputDecay, repeats = inputNumModels,
                     linout = TRUE, trace = FALSE, maxit = 500, 
                     MaxNWts = inputNumHiddenNodes * (ncol(trainingData) + 1) + inputNumHiddenNodes + 1)})
  
  
  avgNnetPred<-reactive({predict(avgNnetFit(), testingData)})
  avgNnetSummary<-reactive({defaultSummary(data.frame(obs=solTestY, pred=avgNnetPred()))})
  
}





#remove correlated predictors
correlated<-findCorrelation(cor(solTrainXtrans),cutoff=.75)
trainingData<-solTrainXtrans[,-correlated]
testingData<-solTestXtrans[, -correlated]

#call the linear function during initialization, it isn't dynamic
lmSummary<-linear(trainingData, testingData)





shinyServer(
  function(input,output) {
    
    singleNnetSummary<-nnSingle(trainingData, testingData, input$numHiddenNodes, input$inputDecay)
    averageNnetSummary<-nnAverage(trainingData, testingData, input$numHiddenNodes, input$inputDecay, input$numModels)
    
    
    
    output$lmRMSE <- renderPrint({lmSummary[1]})
    output$lmRSquared <- renderPrint({lmSummary[2]})

    output$singleNnetRMSE <- renderPrint({as.data.frame(singleNnetSummary())[1,1]})
    output$singleNnetRSquared <- renderPrint({as.data.frame(singleNnetSummary())[2,1]})

    output$averageNnetRMSE <- renderPrint({as.data.frame(averageNnetSummary())[1,1]})
    output$averageNnetRSquared <- renderPrint({as.data.frame(averageNnetSummary())[2,1]})
    
#     output$newHist<- renderPlot({
#       hist
#     })
  }
)
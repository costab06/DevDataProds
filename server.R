
library(AppliedPredictiveModeling)
data(solubility)

library(shiny)
library(caret)
library(nnet)




#remove correlated predictors
correlated<-findCorrelation(cor(solTrainXtrans),cutoff=.75)
trainingData<-solTrainXtrans[,-correlated]
testingData<-solTestXtrans[, -correlated]

lmTrainingData<-trainingData
lmTrainingData$Solubility<-solTrainY



# calculate the lm model since it is static
lmFit<-lm(Solubility ~ .,data = lmTrainingData)

lmPred<-predict(lmFit, testingData)
lmSummary<-defaultSummary(data.frame(obs=solTestY, pred=lmPred))



shinyServer(
  function(input,output) {
    
    
    singleNnetFit<-reactive({nnet(trainingData, solTrainY, size = input$numHiddenNodes, decay = input$inputDecay,
                                  linout = TRUE, trace = FALSE, maxit = 500, 
                                  MaxNWts = input$numHiddenNodes * (ncol(trainingData) + 1) + input$numHiddenNodes + 1)})
    
    
    singleNnetPred<-reactive({predict(singleNnetFit(), testingData)})
    singleNnetSummary<-reactive({defaultSummary(data.frame(obs=solTestY, pred=singleNnetPred()))})
    
    
    averageNnetFit<-reactive({avNNet(trainingData, solTrainY, size = input$numHiddenNodes, decay = input$inputDecay, repeats = input$numModels,
                                     linout = TRUE, trace = FALSE, maxit = 500, 
                                     MaxNWts = input$numHiddenNodes * (ncol(trainingData) + 1) + input$numHiddenNodes + 1)})
    
    
    averageNnetPred<-reactive({predict(averageNnetFit(), testingData)})
    averageNnetSummary<-reactive({defaultSummary(data.frame(obs=solTestY, pred=averageNnetPred()))})
    
    
    
    
    output$lmRMSE <- renderPrint({lmSummary[1]})
    output$lmRSquared <- renderPrint({lmSummary[2]})
    
    output$singleNnetRMSE <- renderPrint({as.data.frame(singleNnetSummary())[1,1]})
    output$singleNnetRSquared <- renderPrint({as.data.frame(singleNnetSummary())[2,1]})
    
    output$averageNnetRMSE <- renderPrint({as.data.frame(averageNnetSummary())[1,1]})
    output$averageNnetRSquared <- renderPrint({as.data.frame(averageNnetSummary())[2,1]})
    
    lmResids<-lmPred-solTestY
    output$lmResids<- renderPlot({plot(lmResids)})
    
    singleResids<-reactive(singleNnetPred()-solTestY)
    output$singleNnetResids<- renderPlot({plot(singleResids())})
    
    averageResids<-reactive(averageNnetPred()-solTestY)
    output$averageNnetResids<- renderPlot({plot(averageResids())})

  }
)
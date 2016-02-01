shinyUI(
  pageWithSidebar(
    headerPanel("Illustrating Inputs"),
    sidebarPanel(
      numericInput("numHiddenNodes", "Number of hidden nodes in the neural network",2,min = 1, max = 10, step = 1),
      numericInput("inputDecay", "Decay of weights during training (regularization parameter)",
                   0.01,min = 0.005, max = 0.02, step = 0.001),
      numericInput("numModels", "Number of Neural Netowrk models to average", 2, min = 1, max = 10, step = 1),
      #     checkboxGroupInput("checkBoxValue","Checkbox",
      #                        c("Value 1" = "1",
      #                          "value 2" = "2",
      #                          "value 3" = "3")),
      #     dateInput("dateValue", "Date:"),
      
      
      #    sliderInput("mu", "Enter the multiplier",value=4,min=2,max=10,step=.5,)
      
      
      submitButton("Submit")
    ),
    mainPanel(
      tabsetPanel (
        tabPanel("Introduction",
          p("This application uses the Solubility Data Set from \"Applied Predictive Modeling - Kuhn and Johnson\" in order to compare
            a basic linear model to a single neural network model and an average of a number of neural network models."),
          p("On the sidebar the user is able to specify paramemters for the nerual network models.  The application supports setting the
            number of hidden neurons for each neural network, the regularization parameter that decays the weights during training,
            and the number of neural networks to use when averaging."),
          p("In the \"Summary\" tab is a display of the RMSE and RSquared statistics for the three approaches, and in the \"Residuals\" tab 
            are plots of the residuals from testing the models."),
          p("Please allow some time for the page to load, computing the neural networks is compuationally intensive.")
        ),
        tabPanel("Summary",
                 
                 h4("RMSE from lm:"),
                 verbatimTextOutput("lmRMSE"),
                 
                 h4("RSquared from lm"),
                 verbatimTextOutput("lmRSquared"),
                 
                 
                 h4("RMSE from single NNet model"),
                 verbatimTextOutput("singleNnetRMSE"),
                 
                 h4("RSquared from single NNet model"),
                 verbatimTextOutput("singleNnetRSquared"),
                 
                 h4("RMSE from averaged NNet model"),
                 verbatimTextOutput("averageNnetRMSE"),
                 
                 h4("RSquared from averaged NNet model"),
                 verbatimTextOutput("averageNnetRSquared")
        ),
        tabPanel("Residuals",
                 h4("Plots go here...")
        )
      )
    )
    
    
    #    plotOutput("newHist")
    
  )
)


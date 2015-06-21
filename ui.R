library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title.
  titlePanel("Neural Network for Function Approximation"),
  
  
  sidebarLayout(
    sidebarPanel(
      
      
      helpText("This application executes the function approximation",
               "of a number of observations. To execute it click on the",
               "Model tab and click on the Run Model button."),
            
      helpText("The number of neurons in the hidden layer will determine the",
               "number of weigths for the free parameters. In the Model tab",
               "you will see a greather number of weigts, this number include",
               "the weight between the hidden layer and the output layer."),
      
      # Number of neurons in the hidden layer
      sliderInput("hiddenunits", "Number of neurons in the hidden layer", 
                  min=1, max=16, value=5),
      
      helpText("The training set should be sufficiently large and diverse",
               "so that it could represent the problem well. For good",
               "generalization, the size of the training set should be",
               "several times larger that the network capacity."),
      
      # Size of the training set
      sliderInput("trainnigsetsize", "Size of the training set", 
                  min=0.1, max=0.9, value=0.6, step=0.1),
      br(),
      p("Number of records in the trainig set"),
      verbatimTextOutput("trainingsetn"),
      br(),
      p("Root Mean Square Error (Test Set)"),
      verbatimTextOutput("error"),
      br(),
      
      actionButton("runModel", label = "Run Model")),
    
    # 
    mainPanel(
      
      tabsetPanel(type = "tabs", 
                  tabPanel("Model", verbatimTextOutput("model")), 
                  tabPanel("Summary", verbatimTextOutput("summary")), 
                  tabPanel("Plot",  plotOutput("plot")), 
                  tabPanel("Table", dataTableOutput("table"))
                  )
    )
  )
)
)
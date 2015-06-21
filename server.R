library(shiny)
library(nnet)

source("NormalizeFunc.R")


shinyServer(function(input, output) {
  
  output$summary <- renderPrint({
    
    sales.ship.hist <<- read.csv(file="CorrectedSalesShipmentHistory_Original.csv",head=TRUE)
    sales.ship.hist <<- sales.ship.hist[sales.ship.hist$DP.Shorts > 0,]
    
    input$runModel
    
    summary(sales.ship.hist)      
    
  })
  
  # Run the Neural Network Model
  output$model <- renderPrint({
    
    input$runModel
    
    trainnigsetsize <- isolate(input$trainnigsetsize)
    hiddenunits <- isolate(input$hiddenunits)
    
    set.seed(8787)
    n.rows <- NROW(sales.ship.hist)
    
    inTrain <- sample(1:n.rows,n.rows* trainnigsetsize)
    
    tColumns <- c("DP.Calc.Adjusted.KF","DP.Ship.Hist","DP.Shorts")
    
    trdata <- normalize(sales.ship.hist[inTrain,tColumns])
    trdata.mm <- minmax(sales.ship.hist[inTrain,tColumns])
    tsdata <- normalize(sales.ship.hist[-inTrain,tColumns],trdata.mm)
    
    tsn <<- NROW(trdata)
    
    formula <- as.formula("DP.Calc.Adjusted.KF~DP.Ship.Hist+DP.Shorts")
    
    corrected.ship.hist <<- nnet(formula,trdata,size=hiddenunits,
                                maxit=1000,decay=0.01,linout=TRUE)
    
    #Run them through the neural network
    net.results <- predict(corrected.ship.hist, tsdata) 
    
    #Lets display a better version of the results
    
    result.data <- data.frame(cbind(DP.Calc.Adjusted.KF=net.results,
                                    DP.Ship.Hist=tsdata$DP.Ship.Hist,
                                    DP.Shorts=tsdata$DP.Shorts))
    colnames(result.data) <- c("DP.Calc.Adjusted.KF","DP.Ship.Hist","DP.Shorts")
    
    result <<- data.frame(denormalize(result.data,trdata.mm),sales.ship.hist[-inTrain,1])
    
    colnames(result) <- c("DP.Calc.Adjusted.KF","DP.Ship.Hist","DP.Shorts","DP.AdjCalc")
    
    result_model <<- data.frame(result, DP.error= result$DP.Calc.Adjusted.KF - result$DP.AdjCalc)
   
    
    test.error <<- sqrt(mean(result_model$DP.error^2))
      
    #train.error <<-sqrt(corrected.ship.hist$value/sum(trdata$DP.Calc.Adjusted.KF))
          
    print("Test Error")
    print(test.error)
      
    
  })
  
  output$plot <- renderPlot({
    
    input$runModel
    
    plot(result_model$DP.Calc.Adjusted.KF, result_model$DP.AdjCalc)
    
  })
  
  
  output$table <- renderDataTable({
    
    
    input$runModel
    
    
    data <- isolate(result_model)
    data
  })
  
  output$trainingsetn <- renderPrint({
    
    
    input$runModel
    
    isolate({print(tsn )})
    
  })
  
  
  output$error <- renderPrint({
    
    input$runModel
  
    isolate({print(test.error)})
  })
  
}) #ShinyServer










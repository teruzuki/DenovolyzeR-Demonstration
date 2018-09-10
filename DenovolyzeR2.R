
#
library(DT)
library(denovolyzeR)
library(shiny)
library(ggplot2)


ui <- fluidPage(
  
  titlePanel("DenovolyzeR: an Autism Sequencing Consortium Production"),
  titlePanel("-A demo"),
 
  sidebarLayout(
    
    
    sidebarPanel(
      
      
      selectInput(inputId = "dataset",
                  label = "Choose an analysis method:",
                  choices = c("Overall de novo burden", 
                              "Genes containing multiple de novos", 
                              "Genes containing multiple de novos with permutations",
                              "Genes containing multiple de novos with permutations and contains >1 de novo lof variant",
                              "Significance of each gene"
                              )
                  
                  ),
      
      
      numericInput(inputId = "obs",
                   label = "Maximum number of observations to view:",
                   value = 30),
      actionButton("go", "Go")
      
    ),
    
    
    mainPanel(
      
      # Output: Verbatim text for data summary ----
      verbatimTextOutput("summary"),
      
      # Output: HTML table with requested number of observations ----
      tableOutput("view"),
      
      # Output a message about current option
      verbatimTextOutput("message")
    )
  )
)
# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  # Return the requested dataset ----
  datasetInput <- eventReactive(input$go,{
    switch(input$dataset,
           "Overall de novo burden" = denovobyCla.3ft <- data.frame(denovolyzeByClass(genes=autismDeNovos$gene,
                                                                                 classes=autismDeNovos$class,
                                                                                 nsamples=1078)),
           "Genes containing multiple de novos" = denovoMulHit.3ft <- denovoMulHit.3ft <- data.frame(denovolyzeMultiHits(genes=autismDeNovos$gene,
                                                                                                                         classes=autismDeNovos$class,
                                                                                                                         nsamples=1078)),
           "Genes containing multiple de novos with permutations" = denovoMulHit.4ft <- data.frame(denovolyzeMultiHits(genes=autismDeNovos$gene,
                                                                                                                       classes=autismDeNovos$class,
                                                                                                                       nsamples=1078,
                                                                                                                       nperms=1000)),
           "Genes containing multiple de novos with permutations and contains >1 de novo lof variant" = denovoMulHit.5ft <- data.frame(denovolyzeMultiHits(genes=autismDeNovos$gene,
                                                                                                                                                           classes=autismDeNovos$class,
                                                                                                                                                           nsamples=1078,
                                                                                                                                                           nperms=1000,
                                                                                                                                                           nVars="expected")),
           "Significance of each gene" = head(
             denovolyzeByGene(genes=autismDeNovos$gene,
                              classes=autismDeNovos$class,
                              nsamples=1078)
           ))
    
  })
  
  # Generate a summary of the dataset ----
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  # Show the first "n" observations ----
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
  # show corresponding message
  output$message <- renderPrint({
    dataset <- datasetInput()
    switch(input$dataset,
           "Overall de novo burden" = "First we want to know whether there are more de novos than expected, using the denovolyzeByClass() function. These variants were obtained by sequencing 1,078 cases, so we use nsamples=1078.",
           "Genes containing multiple de novos" = "Here it looks like there may be an excess of genes with >1 lof variant, >1 missense, and >1 protein-altering variant. We will want to increase the number if permutations here to get a handle on our level of significance.",
           "Genes containing multiple de novos with permutations" = "increased power",
           "Genes containing multiple de novos with permutations and contains >1 de novo lof variant" = "expected genes",
           "Significance of each gene" = "List of protein-alternating genes"
           )
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)


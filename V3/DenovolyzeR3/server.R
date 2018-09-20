#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(DT)
library(dplyr)
library(denovolyzeR)
library(shiny)
library(markdown)
library(ggplot2)
library(qqman)


shinyServer(function(input, output, session) {
  
  datasetInput1 <- eventReactive(input$go1,{
    
    dn1 <- denovolyzeByClass(genes=autismDeNovos$gene,
                             classes=autismDeNovos$class,
                             nsamples=1078)
    dn2 <- denovolyzeByClass(genes=autismDeNovos$gene,
                             classes=autismDeNovos$class,
                             nsamples=1078,
                             includeClasses=c("frameshift", "non", "splice", "lof"))
    dn1$pValue <- sprintf("%7.2e",dn1$pValue)
    dn2$pValue <- sprintf("%7.2e",dn2$pValue)
    
    switch (input$RoundOneInput,
            "Display original data" = autismDeNovos,
            "Overall de novo burden" = dn1,
            "Overall de novo burden for Loss of Function Mutations" = dn2)
  })
  
  datasetInput2 <- eventReactive(input$go2,{
    
    dn3 <- denovolyzeMultiHits(genes=autismDeNovos$gene,
                               classes = autismDeNovos$class,
                               nsamples = 1078,
                               nperms = input$nperm1)
    dn4 <- denovolyzeMultiHits(genes=autismDeNovos$gene,
                               classes = autismDeNovos$class,
                               nsamples = 1078,
                               includeClasses = "lof"
                               #nVars = "expected"
                               
                               )
    dn3$pValue <- sprintf("%7.2e",dn3$pValue)
    dn4$pValue <- sprintf("%7.2e",dn4$pValue)
    
    switch (input$RoundTwoInput,
            "Number of genes containing multiple de novo Variants" = dn3,
            "LoF genes carrying multiple de novo variants under given sample size" = dn4)
  })
  
  datasetInput3 <- eventReactive(input$go3, {
    dn5 <- denovolyzeByGene(genes = autismDeNovos$gene,
                            classes = autismDeNovos$class,
                            nsamples = 1078) %>% subset(prot_observed>1)
    
    dn5$lof_pValue <- sprintf("%7.2e",dn5$lof_pValue)
    dn5$prot_pValue <- sprintf("%7.2e",dn5$prot_pValue)
    
    dn6 <- denovolyzeByGene(genes = autismDeNovos$gene,
                            classes = autismDeNovos$class,
                            nsamples = 1078) %>% subset(lof_pValue<1)
    dn6$lof_pValue <- sprintf("%7.2e",dn6$lof_pValue)
    dn6$prot_pValue <- sprintf("%7.2e",dn6$prot_pValue)
    
    dn7 <- denovolyzeByGene(genes = autismDeNovos$gene,
                                   classes = autismDeNovos$class,
                                   nsamples = 1078) %>% subset(lof_pValue<10e-6)
    dn7$lof_pValue <- sprintf("%7.2e",dn7$lof_pValue)
    dn7$prot_pValue <- sprintf("%7.2e",dn7$prot_pValue)
    
    switch(input$Round3Input,
           "Display frequency of de novo variants in individual genes" = dn5,
           "Omit p = 1" = dn6,
           "Display Significant genes" = dn7)
    
  })
  
  
  output$view1 <- renderTable({
    
    head(datasetInput1(), n = input$obs1)
    
    
  })
  
  output$plot1 <- renderPlot({
    ggplot(datasetInput1(), aes(x= class, y=as.double(pValue), fill=class))+
      geom_bar(stat="identity", width=0.7)+
      theme_minimal()
  })
  
  output$view2 <- renderTable({
      head(datasetInput2(), n = input$obs2)
    })
  
  output$plot2 <- renderPlot({
    ggplot(datasetInput2(), aes(x= class, y=as.double(pValue), fill=class))+
      geom_bar(stat="identity", width=0.7)+
      theme_minimal()
  })
  
  output$view3 <- renderTable({
    head(datasetInput3(), n = input$obs3)
  })
  
  output$plot3 <- renderPlot({
    ggplot(datasetInput3(), aes(x= gene, y=as.double(lof_pValue), fill=gene))+
      geom_bar(stat="identity", width=0.7)+
      theme(legend.position="none")
  })
  
})

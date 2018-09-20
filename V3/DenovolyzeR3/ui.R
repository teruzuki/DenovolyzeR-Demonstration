#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

# Define UI for application that draws a histogram
shinyUI(navbarPage("DenovolyzeR",
  
  theme = "bootstrap.css",
  
  tabPanel("Intro",
           includeMarkdown("./md/intro.md"),
           #includeCSS("./css/styles.css"),
           hr()),
  
  tabPanel("burden of de novo variants",
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 inputId = "RoundOneInput",
                 label = "Actions",
                 choices = c("Display original data",
                             "Overall de novo burden",
                             "Overall de novo burden for Loss of Function Mutations"
                 )
               ),
               numericInput(
                 inputId = "obs1",
                 label = "Maximum number of observations to view:",
                 value = 10
               ),
               actionButton("go1", "Go")
             ),
             mainPanel(
               tags$style(type="text/css",
                          ".shiny-output-error { visibility: hidden; }",
                          ".shiny-output-error:before { visibility: hidden; }"
               ),
               tableOutput("view1"),
               hr(),
               plotOutput("plot1")
             )
           )
  ),
  tabPanel("numeber of genes with mutiple de novo variants",
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 inputId = "RoundTwoInput",
                 label = "Actions",
                 choices = c("Number of genes containing multiple de novo Variants",
                             "LoF genes carrying multiple de novo variants under given sample size"
                 )
               ),
               numericInput(
                 inputId = "obs2",
                 label = "Maximum number of observations to view:",
                 value = 10
               ),
               numericInput(
                 inputId = "nperm1",
                 label = "Permutations",
                 value = 100
               ),
               actionButton("go2", "Go")
             ),
             mainPanel(
                tableOutput("view2"),
                hr(),
                plotOutput("plot2")
             )
           )
  ),
  tabPanel("frequency of de novo variants in individual genes",
           sidebarLayout(
             sidebarPanel(
               selectInput(
                 inputId = "Round3Input",
                 label = "Action",
                 choices = c("Display frequency of de novo variants in individual genes",
                             "Omit p = 1",
                             "Display Significant genes")
               ),
               numericInput(
                 inputId = "obs3",
                 label = "Maximum number of observations to view:",
                 value = 10
               ),
               actionButton("go3", "Go")
             ),
             mainPanel(
               tableOutput("view3"),
               hr(),
               plotOutput("plot3")
             )
           )
  )
  )
)

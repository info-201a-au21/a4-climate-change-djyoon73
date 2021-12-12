library(shiny)
library(ggplot2)
library(rsconnect)
library(plotly)

source("my_ui.R")
source("my_server.R")

shinyApp(ui = ui, server = server)
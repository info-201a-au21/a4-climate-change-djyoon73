library("dplyr")
library("stringr")
library("shiny")
library("plotly")
library("mapproj")

source("my_ui.R")
source("my_server.R")

shinyApp(ui = ui, server = server)
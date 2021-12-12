library("dplyr")
library("stringr")
library("shiny")
library("plotly")
library("mapproj")

source("my_server.R")

co2_emission_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    h2(style = "color:blue", "Introduction"),
    
    p("Today we are working with data on CO2 and Greenhouse Gas Emissions by", strong("Our World in Data."),
    "The data is updated and includes data on CO2 emissions (annual, per capita, cumulative and consumption-based),
     other greenhouse gases, energy mix, and other relevant metrics. The exploration of this data is extremely 
     important as the effects of greenhouse gas emissions are becoming increasingly apparent in the world today."),
  
    p("The dataset is so large however, I decided to narrow down my area of analysis to include the following metrics."),
  
    p(em("Year"), " is the year of observation."),
  
    p(em("Country"), " refers to the geographic location of the emission. For this exploration, I decided to group countries
         together to view CO2 emissions continentally, on a global scale."),
    
    p(em("CO2"), " refers to the annual production-based emissions of CO2, measured in million tonnes."),
  
    p(em("Cumulative CO2"), " refers to the cumulative production-based emissions of CO2 since the first year of data availability, 
      measured in million tonnes."),
  
    p(em("CO2 Per Capita"), " refers to the annual production-based emissions of CO2, measured in tonnes 
         per person."),
    
    p("I will also be using the variables", em(" cement CO2, coal CO2, flaring CO2, gas CO2, and
    oil CO2."), "These variables will reference CO2 emissions as a result of that certain industry 
      measured in million tonnes."),
  
    h2(style = "color:blue", "Relevant Values of Interest"),
    p("Currently, this dataset does not include emissions of CO2 from Antarctica as it is negligible, so I decided to narrow my focus to the 6
      other major continents."),
  
    p("I found that in the most current year in record,", textOutput("highest_co2_per_capita", inline=T), " Australia had the highest CO2 per capita. On the
      opposite end of the spectrum, ", textOutput("lowest_co2_per_capita", inline=T), "had the lowest CO2 per capita."),
  
    p("I also found out that cumulatively, since the beginning of when this data was recorded, ", textOutput("highest_cumulative_co2", inline=T), " had the higehst
      emissions of CO2. ", textOutput("lowest_cumulative_co2", inline=T), " had the lowest cumulative emissions of CO2."),
  
    p("I then proceeded to analyze the relative proportions of CO2 contributions by each country, as of the most recent year of record. I found that Asia contributed the
      most to the world's CO2 levels in 2020, with 60% of the world's total CO2 emissions coming from Asia. 17% of the world's CO2 emissions came from North America. 
      14.6% of the world's CO2 emissions came from Europe. 4% of the world's CO2 emissions came from Africa. 3% of the world's CO2 emissions came from South America.
      And lastly, only 1% of the world's CO2 emissions came from Australia."),
    
    p("What is interesting, is that despite Australia having the highest CO2 emissions per capita, the continent itself contributed the least to the world's total CO2 levels in 2020.")
  ))

plot_sidebar <- sidebarPanel(
    selectInput(
    inputId = "y_axis_input",
    label = "Y axis",
    choices = list("Total Emissions of CO2" = "co2",
                   "Emissions of CO2 From Coal" = "coal_co2",
                   "Emissions of CO2 From Flaring" = "flaring_co2",
                   "Emissions of CO2 From Gas" = "gas_co2",
                   "Emissions of CO2 From Oil" = "oil_co2"),
    selected = "co2_per_capita"
  ),
  checkboxGroupInput(
    inputId = "continent_input",
    label = "Select a Continent to Display:",
    choices = list("Africa" = "Africa",
                   "South America" = "South America",
                   "North America" = "North America",
                   "Asia" = "Asia",
                   "Europe" = "Europe",
                   "Australia" = "Australia"),
    selected = "Africa"
  )
)

plot_main <- mainPanel(
  plotlyOutput(outputId = "co2_plot"),
  h2(style = "color:blue", "Chart Purpose"),
  p("This chart displays CO2 emissions, as well as CO2 emissions by industry over the past 20 years for the six main continents. 
    This chart is useful in identifying in trends of CO2 emissions over the years, answering questions such as: is CO2 emission
    gradually increasing? How does it vary by continent or by industry? Is there ever a spike of rapid increase or decrease?"),
  p("In terms of total emission of CO2, Asia contributes most to the world's total CO2 
    levels, ranging from 9,000 million tons to 21,000 million tons from the year 2000 to 2020. 
    Europe and North America add nearly the same CO2 emissions, ranging between 5000 million tons to 7500 million tons. 
    They also follow a very similar trend of no noticable increase, with a slight decrease during the year of 2019. 
    Africa, South America, and Australia have very low levels of CO2 emission, averaging around 1,000 million tons. 
    Likewise, the emissions are rather consistent through the year and do not display a significant trend. "),
  p("The discrepancy between CO2 emissions between Asia and the other continents are so great, that Asia could even be seen as an 
    outlier. Even when adjusting the Y axis to show emissions of CO2 by industry, the pattern is that
    Asia is always the highest, at least as of the most recent year. "),
  p("This chart clearly displays the trends of CO2 emission in total and by industry for the six different continents over time. ")
)

plot_tab <- tabPanel(
  "CO2 Emissions by Industry",
  sidebarLayout(
    plot_sidebar,
    plot_main
  )
)

ui <- navbarPage(
  "Trends in CO2 Emissions",
  intro_tab,
  plot_tab
)
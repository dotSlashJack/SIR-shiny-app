# Shiny app to generate a simple SIR model
# By Jack Hester, Emily Nomura, and Emma Dennis-Knieriem
library(shiny)
library(ggplot2)
library(deSolve)
library(shinyWidgets)
library(ggthemes)

# Define UI elements
ui <- fluidPage(
    
    titlePanel("SIR Simulator"), # app title
    setBackgroundColor("#7cccd6"), # background color
    
    # add sliders and their description
    sidebarLayout(
        sidebarPanel(
            style="background-color: #eaf2f3;",
            sliderInput("beta",
                        paste("\U03B2"),
                        min = 1,
                        max = 100,
                        value = 50
            ),
            tags$em("Flow rate from susceptible to infected"),
            #setSliderColor("#eaf2f3", 1),
            tags$br(), tags$br(),
            sliderInput("nu",
                        paste0("\U1D742"),
                        min = 1,
                        max = 50,
                        value = 15
            ),
            tags$em("Flow rate from infected to recovered"),
            tags$br(),tags$br(),
            sliderInput("N",
                        "\U1D441",
                        min = 1e5,
                        max = 1e8,
                        value = 1e5
            ),
            tags$em("Total population size"),
            tags$br(),tags$br(),
            sliderInput("i0",
                        "Initial # Infected",
                        min = 1,
                        max = 1e2,
                        value = 1
            ),
            tags$em("The number infected at the beginning (t=0)")
        ),
        
        # add plot, download, descriptive text
        mainPanel(
                    plotOutput("plot"),
                    tags$br(),
                    #add button to download time series data
                    downloadButton('downloadData', 'Download SIR Time Series', style="color: black; background-color: #eaf2f3;"),
                    tags$br(), tags$br(),
                    
                    tags$p(
                        style="background-color: #eaf2f3; padding: 20px;",
                        "Please use the sliders on the panel to the left to provide the model with the desired parameters and it will automatically update. For more information on the parameters, click the link to the README below.
                        Below the plot, you can also see the maximum number of infected individuals, as well as time step (day) at which there were the most infected individuals.
                        If you want to access the raw time series data for the SIR model with your specific inputs, you can download them as a csv by clicking the download button above.",
                        tags$br(), tags$br(),
                        tags$a(href="https://github.com/dotSlashJack/SIR-shiny-app", "README and Source Code", style="color: black; text-decoration-line: underline;")
                    ),
                  )
    ),
)

# Define server logic
server <- function(input, output) {
    
    
    # build SIR model
    sir.model <- function(t, y, parms) {
        #'sir model
        #'param t the time points
        #'param y the initial conditions of the SIR model (initial S,I, and R numbers)
        #'param parms a list of parameters containing beta, nu, and N of the model (see comments in function)
        #'
        #'return dy, a list containing the number of susceptible, infected, and recovered at each time point
        with(as.list(c(y,parms)),{
            #S = # number of susceptibles
            #I = # number of infecteds
            #R = # number of recovered and immune
            #beta = flow rate between susceptible and infected
            #nu = flow rate between infected and recovered
            
            dS =  - (beta*S*I)/N
            dI = (beta*S*I)/N - I*(nu)
            dR= nu*I
            
            dy=c(dS, dI, dR)
            return(list(dy))
        })
    }
    
    # add functions to support the download button
    output$plot <- renderPlot({
        
        output$downloadData <- downloadHandler(
            filename <- function() {
                paste('SIR-data', Sys.Date(), '.csv', sep='')
            },
            
            # download the SIR data at each time step as a CSV
            # con is the save location (user specified in UI popup)
            content <- function(con) {
                data <- data.frame(day=time.points*100, susceptible=result$S, infected=result$I, recovered=result$R)
                write.csv(data, con)
            }
        )
        
        parameters=list(
            beta = input$beta,
            nu = input$nu,
            N = input$N
        )
        
        #N <- 1e5 #pop size
        N <- input$N
        init.inf <- input$i0
        init.cond=c(S=(N-init.inf), I=init.inf, R=0) # start w user specified number of infected individuals, maybe make this dynamic later
        tmax=1
        npoints=100
        time.points = seq(0, tmax, tmax/npoints)
        
        # add info about results
        result <- as.data.frame(ode(y=init.cond, time=time.points, sir.model, parms=parameters))
        
        # add info on this plot
        colors <- c("Susceptible" = "orange", "Infected" = "red", "Recovered" = "green")
        ggplot(data=result) +
            geom_line(aes(x=time, y=S, color = "Susceptible"), size=1) +
            geom_line(aes(x=time, y=I, color = "Infected"), size=1) +
            geom_line(aes(x=time, y=R, color = "Recovered"), size=1) +
            labs(x = "Time (Days)",
                 y = "Population",
                 color = "Legend") +
            scale_color_manual(values = colors) +
            ggtitle("Susceptible, Infected, and Recovered Individuals Over Time") +
            theme_stata() +
            theme(plot.caption = element_text(size=14),
                  axis.title = element_text(size=14),
                  title = element_text(size=15),
                  legend.text = element_text(size=14),
                  legend.title = element_blank(),
                  plot.caption.position = "plot"
                  ) +
            labs(caption = paste0("\nThe maximum number of individuals infected was ", round(max(result$I),0), ',\noccuring at day ', result$time[which.max(result$I)]*100 ))
        
    })
}

# Run the application
shinyApp(ui = ui, server = server)


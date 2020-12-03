#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(deSolve)
library(docstring)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("SIR Simulator"),
    #titlePanel("Plot of Nubmer of Susceptible, Infected, and Recovered Individuals"),
    #mainPanel("Plot of Nubmer of Susceptible, Infected, and Recovered Individuals"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("beta",
                        "Beta values:",
                        min = 1,
                        max = 100,
                        value = 50
                        ),
            "Add beta description\n",
            sliderInput("nu",
                        "Nu values:",
                        min = 1,
                        max = 50,
                        value = 15
            ),
            "Add nu description\n\n",
            sliderInput("N",
                        "Population size:",
                        min = 1e5,
                        max = 1e8,
                        value = 1e5
            ),
            "Add pop description\n"
        ),

        # Show a plot of the generated distribution
        mainPanel(plotOutput("plot"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # build SIR model
    sir.model <- function(t, y, parms) {
        #'sir model
        #'param t the ...
        #'param y ...
        #'param parms a list... including...
        #'return...
        #
        with(as.list(c(y,parms)),{
            #S = # number of susceptibles
            #I = # number of infecteds
            #R = # number of recovered and immune
            #beta = 
            #nu = 
            
            dS =  - (beta*S*I)/N
            dI = (beta*S*I)/N - I*(nu)
            dR= nu*I
            
            dy=c(dS, dI, dR)
            return(list(dy))
        })
    }
    
    output$plot <- renderPlot({
        
        
        parameters=list(
            #alpha = .525,
            alpha = input$alpha,
            #beta = .00105,
            beta = input$beta,
            nu = input$nu,
            N <- input$N
            #nu=52
        )
        
        #N <- 1e5 #pop size
        #TODO: make a slider for number infected at beginning
        N <- input$N
        init.cond=c(S=(N-1), I=1, R=0) # start w one infected, maybe make this dynamic later
        tmax=1
        npoints=100
        #tmax = npoints
        time.points = seq(0, tmax, tmax/npoints)
        
        # add info about results
        result <- as.data.frame(ode(y=init.cond, time=time.points, sir.model, parms=parameters))
        
        # add info on this plot
        ggplot(data=result) +
            geom_line(aes(x=time, y=S),color="green") +
            geom_line(aes(x=time, y=I),color="red") +
            geom_line(aes(x=time, y=R),color="orange") +
            ylab("Number of Individuals") +
            xlab("Time") +
            ggtitle("Susceptible, Infected, and Recovered Individuals Over Time")
            
    })
}

#TODO: add a 

#TODO: add documetation

# Run the application 
shinyApp(ui = ui, server = server)

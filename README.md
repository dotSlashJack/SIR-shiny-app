# SIR Modeling Tool

### Visualize SIR time series data with a Shiny app

### By Jack Hester, Emma Dennis-Knieriem, and Emily Nomura

Primary contact: jack_hester [at] brown [dot] edu

## Overview

This Shiny app generates a plot of an SIR model. The plot models susceptible (S), infected (I), and recovered (R) populations over time. The input parameters, &beta;, &nu;,  &#119873;, and initial # infectious, can be changed by the user with sliders. Our motel assumes homogenous, random mixing and does not take births, deaths, pre-infectious and latent periods, or any other demographics into account. More information on SIR models can be found <a href="https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SIR_model">here</a>.

### The mathematical model

<img src="https://render.githubusercontent.com/render/math?math=\frac{dS}{dt} = -\frac{\beta*S*I}{N}">

<img src="https://render.githubusercontent.com/render/math?math=\frac{dS}{dt} = \frac{\beta*S*I}{N} - \nu*I">

<img src="https://render.githubusercontent.com/render/math?math=\frac{dS}{dt} = \nu*I">

## User Inputs/Use

Our app shows the number of individuals in the susceptible, infected, and recovered groups over time based on the user-provided parameters mentioned above. The app also allows users to download a CSV that contains the number in each category at each time step.

The user-provided inputs are:

1. &beta;, the "flow rate" of individuals from susceptible to infected. In our model specifically, it represents the rate at which two individuals come into contact with each other.

2. &nu;, the "flow rate" at which the rate at which individuals recover

3. &#119873;, the initial population size (number of individuals)

4. The initial nubmer of infected (infectious) individuals

Note: our model treats one day as a single time step.

## Limitations

The model only shows the first 100 days worth of data. Our model is based on a simple SIR model; it does not take natural births or deaths, geograhy, differential susceptibility, latent periods, or any other cohort-specific factors. If you want to add any of these features, you are welcome and encouraged to download and alter this code.

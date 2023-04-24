# ===============================================================
# Seoul Bike Sharing Demand
# ===============================================================
dat <- read.csv("C:\\Users\\user\\Desktop\\SeoulBikeData.csv")
dat

# check data
str(dat)

# check missing data
sum(is.na(dat))

# select columns
dat <- dat[ ,2:11]; dat

# correaltion
cor(dat)

library(psych)
describe(dat)

# y = Rented_Bike_Count, x = each column except Rented_Bike_Count
par(mfrow = c(3,3))
plot(Rented_Bike_Count ~ ., data = dat)

# multiple linear regression
out <- lm(Rented_Bike_Count ~ ., data = dat); out
summary(out)

par(mfrow = c(2, 2))
plot(out)

# 다중공선성 확인
# 2보다 크면 다중공선성이 있는 것
car::vif(out)
sqrt(car::vif(out)) > 2
# -> True 제외(Temperature, Humidity, Dew_point_temperature)

# 전진 선택
# 상수항만 포함시킨 회귀모형
fit.con <- lm(Rented_Bike_Count~1, data = dat)
fit.forward <- step(fit.con, scope = list(lower = fit.con, upper = out),
                    direction = 'forward')
fit.forward

# 후진 소거
fit.backward <- step(out, scope = list(lower = fit.con, upper = out),
                     direction = 'backward')
summary(fit.backward)

# 단계별 선택법
fit.both <- step(fit.con, scope = list(lower = fit.con, upper = out),
                 direction = 'both')
fit.both
summary(fit.both)

# 변수의 상대적 중요도를 시각화
model_1 <- lm(Rented_Bike_Count ~ Temperature + Hour + Humidity + 
                Rainfall + Solar_Radiation + Visibility + Snowfall, data = dat)

plot(model_1)

relweights <-
  function(fit,...){                         
    R <- cor(fit$model)   
    nvar <- ncol(R)          
    rxx <- R[2:nvar, 2:nvar] 
    rxy <- R[2:nvar, 1]      
    svd <- eigen(rxx)        
    evec <- svd$vectors                           
    ev <- svd$values         
    delta <- diag(sqrt(ev))  
    lambda <- evec %*% delta %*% t(evec)        
    lambdasq <- lambda ^ 2   
    beta <- solve(lambda) %*% rxy           
    rsquare <- colSums(beta ^ 2)                   
    rawwgt <- lambdasq %*% beta ^ 2    
    import <- (rawwgt / rsquare) * 100 
    lbls <- names(fit$model[2:nvar])   
    rownames(import) <- lbls
    colnames(import) <- "Weights"
    barplot(t(import),names.arg=lbls,
            ylab="% of R-Square",
            xlab="Predictor Variables",
            main="Relative Importance of Predictor Variables", 
            sub=paste("R-Square=", round(rsquare, digits=3)),
            ...)  
    return(import)
  }

par(mfrow = c(1, 1))
result <- relweights(model_1, col = 'blue'); result

# ----------------------------------------------------------------
out <- lm(formula = Rented_Bike_Count ~ Temperature + Hour + Humidity + 
            Rainfall + Solar_Radiation + Visibility + Snowfall, data = dat)
summary(out)

# ----------------------------------------------------------------
library(shiny)

ui <- fluidPage(
  # add title of webpage
  titlePanel("서울 자전거 대여 수에 대한 회귀분석"), 
  
  # add webpage content UI
  # divide window by tab
  tabsetPanel(
    
    tabPanel('DataSet',
             dataTableOutput('dataset')),

    tabPanel('Information',
               mainPanel(
                 h4('str(data)'),
                 verbatimTextOutput('str'),
                 br(), h4('Missing Value'),
                 verbatimTextOutput('missing'),
                 br(), h4('Describe'),
                 verbatimTextOutput('describe')
               )
             ),
    tabPanel('Simple Linear Regression',
             sidebarPanel(selectInput('var_x', 'Select X', c('Hour'='Hour', 'Temperature'='Temperature',
                                                 'Humidity'='Humidity', 'Wind_speed'='Wind_speed',
                                                 'Visibility'='Visibility', 'Solar_Radiation'='Solar_Radiation','Rainfall'='Rainfall',
                                                 'Snowfall'='Snowfall'), selected = 'Hour'),
                          selectInput('var_y', 'Select Y', c('Rented_Bike_Count' = 'Rented_Bike_Count'))),
             mainPanel(
               h4('Scatter Plot'),
               plotOutput("scatterPlot"),
               
               h4('Correaltion Coefficient'),
               verbatimTextOutput('corr_coef'),
               
               h4('Simple Regression'),
               verbatimTextOutput('reg_fit')
             )),
    tabPanel('Multiple Linear Regression',
             sidebarLayout(
               sidebarPanel(
                 selectInput('met', "Method", c('전진선택법'='1', '후진제거법'='2', '변수선택법'='3', '다중공선성' = '4'))
               ),
               mainPanel(
                 verbatimTextOutput('result')
               )
             )),
    tabPanel('Test',
             verbatimTextOutput('out'),
             mainPanel(plotOutput('lmplot')))
)
)


server <- function(input, output){
  library(MASS)
  scatter <- dat[, c('Hour', 'Temperature',
                     'Humidity', 'Wind_speed',
                     'Visibility', 'Solar_Radiation','Rainfall',
                     'Snowfall', 'Rented_Bike_Count')]
  
  output$dataset <- renderDataTable(dat, options = list(pageLength = 5))
  
  output$str <- renderPrint(str(dat))
  output$missing <- renderPrint(sum(is.na(dat)))
  output$describe <- renderPrint(describe(dat))
  
  output$result <- renderPrint(
    if (input$met == '1')
      print(summary(fit.forward))
    else if (input$met == '2')
    print(summary(fit.backward))
    else if (input$met == '3')
      print(summary(fit.both))
    else if (input$met == '4')
      print(sqrt(car::vif(out)) > 2))
  
  output$out <- renderPrint(model_1)
  output$lmplot <- renderPlot({
    par(mfrow=c(2,2))
    plot(model_1)})
  
  output$scatterPlot <- renderPlot({
    var_name_x <- as.character(input$var_x)
    var_name_y <- as.character(input$var_y)
    
    plot(scatter[, input$var_x],
         scatter[, input$var_y],
         xlab = var_name_x,
         ylab = var_name_y,
         main = 'Scatter Plot')
    
    fit <- lm(scatter[, input$var_y] ~ scatter[, input$var_x])
    abline(fit, col = 'red', lwd = 2)
    
    output$corr_coef <- renderText({
      cor(scatter[, input$var_x],
          scatter[, input$var_y])
    })
    
    output$reg_fit <- renderPrint({
      fit <- lm(scatter[, input$var_y] ~ scatter[, input$var_x])
      names(fit$coefficients) <- c('Intercept', input$var_x)
      summary(fit)$coefficients
    })
  })
}

shinyApp(ui, server)

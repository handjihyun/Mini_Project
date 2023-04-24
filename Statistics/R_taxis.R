# load data
taxi <- read.csv("C:/Users/user/Desktop/taxi.csv"); taxi

taxi <- taxi[!(taxi$passengers == 0),]; taxi
taxi <- taxi[!(taxi$distance == 0),]; taxi
taxi <- taxi[!(taxi$tip == 0), ]; taxi

# check data
str(taxi)
describe(taxi)

# boxplot
boxplot(taxi$tip ~ taxi$dropoff_borough, col = 'lightblue', las = 2, xlab = '', ylab = 'tip')
boxplot(taxi$tip ~ taxi$passengers, col = 'lightblue', las = 1, xlab = '', ylab = 'tip')

# check missing data
sum(is.na(taxi))

# ------------------------------------------------------------
taxi$passengers <- as.character(taxi$passengers)
taxi %>% group_by(passengers) %>% summarise(mean_tip = mean(tip))

# One way ANOVA
summary(aov(taxi$tip ~ taxi$passengers))

# ------------------------------------------------------------
# scatter plot
plot(taxi$distance, taxi$tip, xlab = 'distance', ylab = 'tip',
     main = 'Distance and Tip of Taxis', col = 'darkblue')

# correlation analysis
cor(taxi$distance, taxi$tip)
cor.test(taxi$distance, taxi$tip)
cor.test(taxi$tip, taxi$distance)

# Linear regression Analysis
lm_fit <- lm(taxi$tip ~ taxi$distance)
summary(lm_fit)

abline(lm_fit, col = 'hotpink', lwd = 3)
# ------------------------------------------------------------
taxi <- taxi[!(taxi$dropoff_borough == ''),]
taxi %>% group_by(dropoff_borough) %>% summarise(max_tip = max(tip))

summary(aov(taxi$tip ~ taxi$dropoff_borough))
compare <- TukeyHSD(aov(taxi$tip ~ taxi$dropoff_borough))
plot(compare, col = 'darkblue', las = 2)
title(col.main = 1.5)


data<-read.csv("monthly_in_situ_co2_mlo.csv",skip=56,header=TRUE)
data<-data[,1:7]
names(data)<-c("year","mn","date.excel","Date","CO2","adjCO2","fit")

plot(data$year[data$mn==6],data$adjCO2[data$mn==6],type="l",xlab="Year",
     ylab="CO2")

# Copyright (c) Microsoft Corporation.  All rights reserved.

# Third Party Programs. This software enables you to obtain software applications from other sources. 
# Those applications are offered and distributed by third parties under their own license terms.
# Microsoft is not developing, distributing or licensing those applications to you, but instead, 
# as a convenience, enables you to use this software to obtain those applications directly from 
# the application providers.
# By using the software, you acknowledge and agree that you are obtaining the applications directly
# from the third party providers and under separate license terms, and that it is your responsibility to locate, 
# understand and comply with those license terms.
# Microsoft grants you no license rights for third-party software or applications that is obtained using this software.

#
# WARNINGS:   
#
# CREATION DATE: 24/7/2016
#
# LAST UPDATE: 18/01/2017
#
# VERSION: 1.0.0
#
# R VERSION TESTED: 3.3.1
# 
# AUTHOR: pbicvsupport@microsoft.com
#
# REFERENCES: https://en.wikipedia.org/wiki/Autoregressive_integrated_moving_average, https://www.otexts.org/fpp/8



Sys.setlocale("LC_ALL","English") # internationalization

#For DEBUG uses:
#save(list = ls(all.names = TRUE), file='c:/Users/boefraty/Temp/tempData.Rda')
load(file='c:/Users/boefraty/Temp/tempData.Rda')


############ User Parameters #########


##PBI_PARAM: Should warnings text be displayed?
#Type:logical, Default:TRUE, Range:NA, PossibleValues:NA, Remarks: NA
showWarnings = TRUE

##PBI_PARAM: Should additional info about the forcasting method be displayed?
#Type:logical, Default:TRUE, Range:NA, PossibleValues:NA, Remarks: NA
showInfo=TRUE
if(exists("settings_additional_params_show"))
  showInfo = settings_additional_params_show


infoCriteria = "none"
if(exists("settings_additional_params_infoCriteria"))
  infoCriteria = settings_additional_params_infoCriteria

##PBI_PARAM: Forecast length
#Type:integer, Default:NULL, Range:NA, PossibleValues:NA, Remarks: NULL means choose forecast length automatically
forecastLength=10
if(exists("settings_forecastPlot_params_forecastLength"))
{
  forecastLength = as.numeric(settings_forecastPlot_params_forecastLength)
  if(is.na(forecastLength))
    forecastLength = 10
  forecastLength = round(max(min(forecastLength,1e+6),1))
}

confInterval1 = 0.85
if(exists("settings_forecastPlot_params_confInterval1"))
{
  confInterval1 = as.numeric(settings_forecastPlot_params_confInterval1)
}
confInterval2 = 0.95
if(exists("settings_forecastPlot_params_confInterval2"))
{
  confInterval2 = as.numeric(settings_forecastPlot_params_confInterval2)
}
if(confInterval1 > confInterval2)
{#switch
  temp = confInterval1
  confInterval1 = confInterval2
  confInterval2 = temp
}


withSeasonality = TRUE 
if(exists("settings_seasonality_params_show"))
  withSeasonality = settings_seasonality_params_show


##PBI_PARAM target Season
#Type: string, Default:"Automatic", Range:NA, PossibleValues:"Automatic","Hour","Day","Week", ...
targetSeason = "automatic"
if(exists("settings_seasonality_params_targetSeason"))
  targetSeason = settings_seasonality_params_targetSeason

knownFrequency = 12
if(exists("settings_seasonality_params_knownFrequency")) 
  knownFrequency = min(1000000,max(2,settings_seasonality_params_knownFrequency))


maxp  = 3
if(exists("settings_model_params_maxp")) 
  maxp = as.numeric(settings_model_params_maxp)

maxq  = 3
if(exists("settings_model_params_maxq")) 
  maxq = as.numeric(settings_model_params_maxq)

maxd  = 2
if(exists("settings_model_params_maxd")) 
  maxd = as.numeric(settings_model_params_maxd)

maxP  = 3
if(exists("settings_model_params_maxP")) 
  maxP = as.numeric(settings_model_params_maxP)

maxQ  = 3
if(exists("settings_model_params_maxQ")) 
  maxQ = as.numeric(settings_model_params_maxQ)

maxD  = 2
if(exists("settings_model_params_maxD")) 
  maxD = as.numeric(settings_model_params_maxD)

allowDrift  = FALSE
if(exists("settings_model_params_allowDrift")) 
  allowDrift = (settings_model_params_allowDrift)

allowMean  = FALSE
if(exists("settings_model_params_allowMean")) 
  allowMean = settings_model_params_allowMean

fullEnumeration  = FALSE
if(exists("settings_model_params_fullEnumeration")) 
  fullEnumeration = settings_model_params_fullEnumeration


boxCoxTransform = "off"
if(exists("settings_model_params_boxCoxTransform")) 
  boxCoxTransform = settings_model_params_boxCoxTransform

lambda  = 0
if(exists("settings_model_params_lambda")) 
  lambda = max(-1,min(settings_model_params_lambda,2))

userModel  = FALSE
if(exists("settings_userModel_params_show")) 
  userModel = settings_userModel_params_show


p  = 3
if(exists("settings_userModel_params_p")) 
  p = as.numeric(settings_userModel_params_p)

q  = 3
if(exists("settings_userModel_params_q")) 
  q = as.numeric(settings_userModel_params_q)

d  = 2
if(exists("settings_userModel_params_d")) 
  d = as.numeric(settings_userModel_params_d)

P  = 3
if(exists("settings_userModel_params_P")) 
  P = as.numeric(settings_userModel_params_P)

Q  = 3
if(exists("settings_userModel_params_Q")) 
  Q = as.numeric(settings_userModel_params_Q)

D  = 2
if(exists("settings_userModel_params_D")) 
  D = as.numeric(settings_userModel_params_D)

lowerConfInterval = confInterval1
upperConfInterval = confInterval2

###############Library Declarations###############

libraryRequireInstall = function(packageName, ...)
{
  if(!require(packageName, character.only = TRUE)) 
    warning(paste("*** The package: '", packageName, "' was not installed ***",sep=""))
}


libraryRequireInstall("scales")
libraryRequireInstall("forecast")
libraryRequireInstall("zoo")

###############Internal parameters definitions#################

#PBI_PARAM Minimal number of points
#Type:integer, Default:10, Range:[0,], PossibleValues:NA, Remarks: NA
minPoints = 10

##PBI_PARAM Color of time series line
#Type:string, Default:"orange", Range:NA, PossibleValues:"orange","blue","green","black"
pointsCol = "blue"
if(exists("settings_graph_params_dataCol"))
  pointsCol = settings_graph_params_dataCol

##PBI_PARAM Color of forecast line
#Type:string, Default:"red", Range:NA, PossibleValues:"red","blue","green","black"
forecastCol = "orange"
if(exists("settings_graph_params_forecastCol"))
  forecastCol = settings_graph_params_forecastCol

#PBI_PARAM Transparency of scatterplot points
#Type:numeric, Default:0.4, Range:[0,1], PossibleValues:NA, Remarks: NA
transparency = 1
if(exists("settings_graph_params_percentile"))
  transparency = as.numeric(settings_graph_params_percentile)/100

#PBI_PARAM Shaded band for confidence interval
#Type:logical, Default:TRUE, Range:NA, PossibleValues:NA, Remarks: NA
fillConfidenceLevels=TRUE

#PBI_PARAM Size of points on the plot
#Type:numeric, Default: 1 , Range:[0.1,5], PossibleValues:NA, Remarks: NA
pointCex = 1
if(exists("settings_graph_params_weight"))
  pointCex = as.numeric(settings_graph_params_weight)/10

#PBI_PARAM Size of subtitle on the plot
#Type:numeric, Default: 0.75 , Range:[0.1,5], PossibleValues:NA, Remarks: NA
cexSub = 0.75
if(exists("settings_additional_params_textSize"))
  cexSub = as.numeric(settings_additional_params_textSize)/12


infoTextColor = "gray"
if(exists("settings_additional_params_textColor"))
  infoTextColor = settings_additional_params_textColor



###############Internal functions definitions#################

# tiny function to deal with verl long strings on plot
cutStr2Show = function(strText, strCex = 0.8, abbrTo = 100, isH = TRUE, maxChar = 3, partAvailable = 1)
{
  # partAvailable, wich portion of window is available, in [0,1]
  if(is.null(strText))
    return (NULL)
  
  SCL = 0.075*strCex/0.8
  pardin = par()$din
  gStand = partAvailable*(isH*pardin[1]+(1-isH)*pardin[2]) /SCL
  
  # if very very long abbreviate
  if(nchar(strText)>abbrTo && nchar(strText)> 1)
    strText = abbreviate(strText, abbrTo)
  
  # if looooooong convert to lo...
  if(nchar(strText)>round(gStand) && nchar(strText)> 1)
    strText = paste(substring(strText,1,floor(gStand)),"...",sep="")
  
  # if shorter than maxChar remove 
  if(gStand<=maxChar)
    strText = NULL
  
  return(strText) 
}


# Find number of ticks on X axis 
FindTicksNum = function(n,f)
{
  tn = 10 # default minimum
  D = 2 # tick/inch
  numCircles = n/f
  xSize = par()$din[1]
  tn = max(round(xSize*D),tn)
  return(tn) 
}

#format labels on X-axis automatically 
flexFormat = function(dates, orig_dates, freq = 1, myformat = NULL)
{
  
  days=(as.numeric(difftime(dates[length(dates)],dates[1]),units="days"))
  months = days/30
  years = days/365.25
  
  
  constHour = length(unique(orig_dates$hour))==1
  constMin = length(unique(orig_dates$min))==1
  constSec = length(unique(orig_dates$sec))==1
  constMon = length(unique(orig_dates$mon))==1
  
  timeChange = any(!constHour,!constMin,!constSec)
  
  if(is.null(myformat))
  {
    if(years > 10){
      if(constMon)
      {
        myformat = "%Y" #many years => only year :2001
      }else{
        myformat = "%m/%y" #many years + months :12/01
      }
    }else{
      if(years > 1 && N < 50){
        myformat = "%b %d, %Y" #several years, few samples:Jan 01, 2010
      }else{
        if(years > 1){
          myformat = "%m/%d/%y" #several years, many samples: 01/20/10
        }else{
          if(years <= 1 && !timeChange)
            myformat = "%b %d" #1 year,no time: Jan 01
        }  
      }
    }
  }
  if(is.null(myformat) && timeChange)
    if(years>1){
      myformat = "%m/%d/%y %H:%M" # 01/20/10 12:00
    }else{
      if(days>1){
        myformat = "%b %d, %H:%M" # Jan 01 12:00
      }else{
        if(days<=1){
          myformat = "%H:%M" # Jan 01 12:00
        }  
      }
    }
  if(!is.null(myformat)){
    if(myformat == "%Y,Q%q")
      dates = as.yearqtr(dates)
    dates1= format(dates,  myformat)
  }else{
    dates1 = as.character(1:length(dates)) # just id 
  }
  return(dates1)
}


# verify if "perSeason" is good for "frequency" parameter
freqSeason1 = function(seasons,perSeason)
{
  if((seasons > 5 && perSeason > 3) || (seasons > 2 && perSeason > 7))
    return (perSeason)
  
  return(1)
}


# find frequency using the dates, targetS is a "recommended" seasonality 
findFreqFromDates1 = function(dates, targetS = "Automatic")
{
  freq = 1
  N = length(dates)
  nnn = c("hour", "day", "week", "month", "quater", "year")
  seasons = rep(NaN,6)
  names(seasons) = nnn
  perSeason = seasons
  
  seasons["day"]=round(as.numeric(difftime(dates[length(dates)],dates[1]),units="days"))
  seasons["hour"]=round(as.numeric(difftime(dates[length(dates)],dates[1]),units="hours"))
  seasons["week"]=round(as.numeric(difftime(dates[length(dates)],dates[1]),units="weeks"))
  seasons["month"] = seasons["day"]/30
  seasons["year"] = seasons["day"]/365.25
  seasons["quater"] = seasons["year"]*4
  
  perSeason = N/seasons
  
  if(targetS!="automatic") # target 
    freq = perSeason[targetS]
  
  if(freq < 2) # if TRUE, target season factor is not good 
    freq = 1
  
  for( s in rev(nnn)) # check year --> Quater --> etc
    if(freq == 1 )
      freq = freqSeason1(seasons[s],perSeason[s])
  
  return(round(freq))
}

#get valid frequency parameter, based on input from user 
getFrequency1 = function(parsed_dates, values, tS, f)
{
  myFreq = f
  grp = c("automatic","none","manual")
  
  if(!(tS %in% c("autodetect from value","none","manual"))) #detect from date
  {  
    myFreq = findFreqFromDates1(parsed_dates, targetS = tS)
  }else{
    if(tS == "none")
    { myFreq = 1}
    else
    {# NOT YET IMPLEMENTED
      # if(tS == "autodetect from value")
      #   myFreq = freqFromValue1(values)
    }
  }
  numPeriods = floor(length(values)/myFreq)
  if(numPeriods< 2)
    myFreq = findFreqFromDates1(parsed_dates, targetS = "automatic")
  return(myFreq)
}

#format info string 
GetFitMethodString = function(fit,withSeasonality, infoCriteria = "none")
{
  
  arma = fit$arma
  
  resString = as.character(arimaorder(fit))
  
  skey = c("p","d","q","P","D","Q", "m")
  skey = skey[1:length(resString)]
  skey = paste(skey, collapse = ",")
  
  resString = paste("ARIMA: (",skey,") = (",paste(resString,collapse = ","),")",sep ="")
  # add more info 
  if(infoCriteria != "none")
  {
    if(infoCriteria == "AIC")
      resString = paste(resString, "; AIC = ", as.character(round(fit$aic,2)), sep ="")
    else
      if(infoCriteria == "AICc")
        resString = paste(resString, "; AICc = ", as.character(round(fit$aicc,2)), sep ="")
      else
        if(infoCriteria == "BIC")
          resString = paste(resString, "; BIC = ", as.character(round(fit$bic,2)), sep ="")
  }
  
  return(resString)
  
}

# find lambda for Box-Cox transform
FindBoxCoxLambda = function(timeSeries, boxCoxTransform, lambda = NULL,  mymethod = "loglik")
{
  if(boxCoxTransform == "off")
    return(NULL)
  if(boxCoxTransform == "manual")
    return(lambda)
  if(boxCoxTransform == "automatic")
    lambda=BoxCox.lambda(timeSeries, method = mymethod, lower = -1, upper = 2)
  return (lambda)
}



###############Upfront input correctness validations (where possible)#################
pbiWarning = NULL

if(!exists("Date") || !exists("Value"))
{
  dataset=data.frame()
  pbiWarning  = cutStr2Show("Both 'Date' and 'Value' fields are required.", strCex = 0.85)
  timeSeries=ts()
  showWarnings=TRUE
}else{
  dataset= cbind(Date,Value)
  dataset<-dataset[complete.cases(dataset),] #remove corrupted rows
  
  labTime = "Time"
  labValue=names(dataset)[ncol(dataset)]
  
  N=nrow(dataset)
  
  
  if(N==0 && exists("Date") && nrow(Date)>0 &&  exists("Value")){
    pbiWarning1  = cutStr2Show("Wrong date type. Only 'Date', 'Time', 'Date/Time' are allowed without hierarchy", strCex = 0.85)
    pbiWarning = paste(pbiWarning1, pbiWarning, sep ="\n")
    timeSeries=ts()
    showWarnings=TRUE
  }else {
    
    
    dataset = dataset[order(dataset[,1]),]
    parsed_dates=strptime(dataset[,1],"%Y-%m-%dT%H:%M:%S",tz="UTC")
    labTime = names(Date)[1]
    
    if((any(is.na(parsed_dates))))
    {
      pbiWarning1  = cutStr2Show("Wrong or corrupted 'Date'.", strCex = 0.85)
      pbiWarning2  = cutStr2Show("Only 'Date', 'Time', 'Date/Time' types are allowed without hierarchy", strCex = 0.85)
      pbiWarning = paste(pbiWarning1, pbiWarning2, pbiWarning, sep ="\n")
      timeSeries=ts()
      showWarnings=TRUE
    }
    else
    {
      interval = difftime(parsed_dates[length(parsed_dates)],parsed_dates[1])/(length(parsed_dates)-1) # force equal spacing 
      
      if(withSeasonality==FALSE)
        targetSeason = "none"
      
      myFreq = getFrequency1(parsed_dates, values = dataset[,2], tS = targetSeason, f = knownFrequency)
      
   
      if(myFreq < 2)
        withSeasonality = FALSE
      
      if(withSeasonality == FALSE)
      {
        maxP = maxQ = maxD = P = Q = D = 0 
      }
      
      
      timeSeries=ts(data = dataset[,2], start=1, frequency = round(myFreq))
    }
    
    
  }
}

##############Main Visualization script###########

pbiInfo = NULL

if(length(timeSeries)>=minPoints) {
  
  lambda = FindBoxCoxLambda(timeSeries, boxCoxTransform, lambda)
  
  fit = NULL
  #if user model fails do auto.arima
  if(userModel)
  {
    result <- tryCatch({
      fit = suppressWarnings(Arima(timeSeries, order = c(p,d,q), seasonal = c(P,D,Q), 
                                   include.mean=allowMean, include.drift=allowDrift, 
                                   method = "ML", lambda=lambda))
    }, warning = function(war) {
      
      # warning handler picks up where error was generated
      print(paste("MY_WARNING:  ",war))
      return("Arima_warning")
      
    }, error = function(err) {
      
      # error handler picks up where error was generated
      print(paste("MY_ERROR: ",err))
      return("Arima_error")
      
    }, finally = {
      
    }) # END tryCatch
    
  }
  
  if(is.null(fit))
    fit = auto.arima(timeSeries, max.p = maxp, max.q = maxq, max.d = maxd, 
                     max.P = maxP, max.Q = maxQ, max.D = maxD,
                     seasonal= withSeasonality,allowdrift=allowDrift, allowmean=allowMean, lambda=lambda,
                     max.order=4, parallel = FALSE, stepwise = !fullEnumeration)
  
  
  
  fit$method = GetFitMethodString(fit,withSeasonality, infoCriteria)
  if(lowerConfInterval==0)
    lowerConfInterval = NULL; 
  prediction = forecast(fit, level=c(lowerConfInterval,upperConfInterval), h=forecastLength)
  
  lastValue = tail(prediction$x,1)
  
  prediction$mean=ts(c(lastValue,prediction$mean), 
                     frequency = frequency(prediction$mean), 
                     end=end(prediction$mean))
  # 
  prediction$upper=rbind(c(lastValue,lastValue),prediction$upper)
  #
  prediction$lower=rbind(c(lastValue,lastValue),prediction$lower)
  
  if(showInfo)
  {
    pbiInfo=paste(pbiInfo,"", fit$method, sep="")
    pbiInfo = cutStr2Show(pbiInfo,strCex = cexSub, isH = TRUE, maxChar = 20)
  }
  
  labTime = cutStr2Show(labTime, strCex =1.1, isH = TRUE)
  labValue = cutStr2Show(labValue, strCex =1.1, isH = FALSE)
  
  plot.forecast(prediction, lwd=pointCex, col=alpha(pointsCol,transparency), fcol=alpha(forecastCol,transparency), flwd = pointCex, shaded=fillConfidenceLevels,
                main = "", sub = pbiInfo, col.sub = infoTextColor, cex.sub = cexSub, xlab = labTime, ylab = labValue, xaxt = "n")
  
  
  NpF = (length(parsed_dates))+forecastLength
  freq = frequency(timeSeries)
  
  #format  x_with_f
  numTicks = FindTicksNum(NpF,freq) # find based on plot size
  
  x_with_f = as.POSIXlt(seq(from=parsed_dates[1], to = (parsed_dates[1]+interval*(length(parsed_dates)+forecastLength)), length.out = numTicks))
  x_with_forcast_formatted = flexFormat(dates = x_with_f, orig_dates = parsed_dates, freq = freq)
  
  correction = (NpF-1)/(numTicks-1) # needed due to subsampling of ticks
  axis(1, at = 1+correction*((0:(numTicks-1))/freq), labels = x_with_forcast_formatted)
  
  
} else{ #empty plot
  plot.new()
  showWarnings = TRUE
  pbiWarning<-paste(pbiWarning, "Not enough data points", sep="\n")
}

#add warning as subtitle
if(showWarnings)
  title(main=NULL, sub=pbiWarning, outer=FALSE, col.sub = infoTextColor, cex.sub=cexSub)

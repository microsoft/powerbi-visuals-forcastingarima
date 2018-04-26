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
# LAST UPDATE: 25/04/2018
#
# VERSION: 1.2.1
#
# R VERSION TESTED: 3.4.1
# 
# AUTHOR: pbicvsupport@microsoft.com
#
# REFERENCES: https://en.wikipedia.org/wiki/Autoregressive_integrated_moving_average, https://www.otexts.org/fpp/8

source('./r_files/flatten_HTML.r')
<<<<<<< HEAD


#DEBUG in RStudio
<<<<<<< HEAD
fileRda = "C:/Users/boefraty/projects/PBI/R/tempData.Rda"
if(file.exists(dirname(fileRda)))
{
  if(Sys.getenv("RSTUDIO")!="")
    load(file= fileRda)
  else
    save(list = ls(all.names = TRUE), file=fileRda)
}


=======
# fileRda = "C:/Users/boefraty/projects/PBI/R/tempData.Rda"
# if(file.exists(dirname(fileRda)))
# {
#   if(Sys.getenv("RSTUDIO")!="")
#     load(file= fileRda)
#   else
#     save(list = ls(all.names = TRUE), file=fileRda)
# }



Sys.setlocale("LC_ALL","English") # internationalization
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
=======


#DEBUG in RStudio
# fileRda = "C:/Users/boefraty/projects/PBI/R/tempData.Rda"
# if(file.exists(dirname(fileRda)))
# {
#   if(Sys.getenv("RSTUDIO")!="")
#     load(file= fileRda)
#   else
#     save(list = ls(all.names = TRUE), file=fileRda)
# }
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5

Sys.setlocale("LC_ALL","English") # internationalization


Sys.setlocale("LC_ALL","English") # internationalization

<<<<<<< HEAD
=======

>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
############ User Parameters #########

##PBI_PARAM: Should additional info about the forcasting method be displayed?
#Type:logical, Default:TRUE, Range:NA, PossibleValues:NA, Remarks: NA
showInfo = TRUE
if(exists("settings_additional_params_show"))
  showInfo = settings_additional_params_show

##PBI_PARAM: Output information criteria
#Type:enum, Default:"none", Range:NA, PossibleValues:none, AIC,BIC,AICc, Remarks: NA
infoCriteria = "none"
if(exists("settings_additional_params_infoCriteria"))
  infoCriteria = settings_additional_params_infoCriteria

##PBI_PARAM: Forecast length
#Type:integer, Default:NULL, Range:NA, PossibleValues:NA, Remarks: NULL means choose forecast length automatically
forecastLength = 10
if(exists("settings_forecastPlot_params_forecastLength"))
{
  forecastLength = as.numeric(settings_forecastPlot_params_forecastLength)
  if(is.na(forecastLength))
    forecastLength = 10
  forecastLength = round(max(min(forecastLength, 1e+6), 1))
}

##PBI_PARAM: Confidence level
#Type:enum, Default:"0.85", Range:NA, PossibleValues:0, 0.5 etc, Remarks: NA
confInterval1 = 0.85
if(exists("settings_forecastPlot_params_confInterval1"))
{
  confInterval1 = as.numeric(settings_forecastPlot_params_confInterval1)
}


##PBI_PARAM: Confidence level
#Type:enum, Default:"0.95", Range:NA, PossibleValues:0, 0.5 etc, Remarks: NA
confInterval2 = 0.95
if(exists("settings_forecastPlot_params_confInterval2"))
{
  confInterval2 = as.numeric(settings_forecastPlot_params_confInterval2)
}


##PBI_PARAM: Does the model assume seasonality? 
#Type:logical, Default:TRUE, Range:NA, PossibleValues:NA, Remarks: NA
withSeasonality = TRUE 
if(exists("settings_seasonality_params_show"))
  withSeasonality = settings_seasonality_params_show


##PBI_PARAM target Season
#Type: string, Default:"automatic", Range:NA, PossibleValues:"automatic","hour","day","week", ...
targetSeason = "automatic"
if(exists("settings_seasonality_params_targetSeason"))
  targetSeason = settings_seasonality_params_targetSeason

##PBI_PARAM target frequency (samples per period)
#Type: numeric, Default:12 , Range:[2,10^6], PossibleValues:NA
knownFrequency = 12
if(exists("settings_seasonality_params_knownFrequency")) 
  knownFrequency = min(1000000, max(2, settings_seasonality_params_knownFrequency))


##PBI_PARAM The maximal order of the  autoregressive component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
maxp  = 3
if(exists("settings_model_params_maxp")) 
  maxp = as.numeric(settings_model_params_maxp)

##PBI_PARAM The maximal order of the  moving average component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
maxq  = 3
if(exists("settings_model_params_maxq")) 
  maxq = as.numeric(settings_model_params_maxq)

##PBI_PARAM The maximal degree of the differentiation
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2"
maxd  = 2
if(exists("settings_model_params_maxd")) 
  maxd = as.numeric(settings_model_params_maxd)

##PBI_PARAM The maximal order of the seasonal autoregressive component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
maxP  = 2 
if(exists("settings_model_params_maxP")) 
  maxP = as.numeric(settings_model_params_maxP)

##PBI_PARAM The maximal order of the seasonal moving average component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
maxQ  = 2
if(exists("settings_model_params_maxQ")) 
  maxQ = as.numeric(settings_model_params_maxQ)

##PBI_PARAM The maximal degree of the seasonal differentiation
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2"
maxD  = 1
if(exists("settings_model_params_maxD")) 
  maxD = as.numeric(settings_model_params_maxD)

##PBI_PARAM: Should the ARIMA model include a linear drift term?
#Type:logical, Default:FALSE, Range:NA, PossibleValues:NA, Remarks: NA
allowDrift  = TRUE
if(exists("settings_model_params_allowDrift")) 
  allowDrift = (settings_model_params_allowDrift)

##PBI_PARAM: Should the ARIMA model include a mean term?
#Type:logical, Default:FALSE, Range:NA, PossibleValues:NA, Remarks: NA
allowMean  = FALSE
if(exists("settings_model_params_allowMean")) 
  allowMean = settings_model_params_allowMean

##PBI_PARAM: If TRUE, will do stepwise selection (faster). Otherwise, it searches over all models (can be very slow).
#Type:logical, Default:TRUE, Range:NA, PossibleValues:NA, Remarks: NA
stepwiseSelection  = TRUE
if(exists("settings_model_params_stepwiseSelection")) 
  stepwiseSelection = settings_model_params_stepwiseSelection

##PBI_PARAM Box-Cox transformation
#Type: enum/string, Default:"off", Range:NA, PossibleValues:"off","manual","automatic"
boxCoxTransform = "off"
if(exists("settings_model_params_boxCoxTransform")) 
  boxCoxTransform = settings_model_params_boxCoxTransform

##PBI_PARAM Box-Cox transformation parameter
#Type: numeric, Default:0, Range:[-1,2], PossibleValues:NA
lambda  = 0
if(exists("settings_model_params_lambda")) 
  lambda = max(-0.5,min(settings_model_params_lambda,1.5))

##PBI_PARAM: User model? 
#Type:logical, Default:TRUE, Range:NA, PossibleValues:NA, Remarks: NA
userModel  = FALSE
if(exists("settings_userModel_params_show")) 
  userModel = settings_userModel_params_show

##PBI_PARAM The order of the autoregressive component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
p  = 1
if(exists("settings_userModel_params_p")) 
  p = as.numeric(settings_userModel_params_p)

##PBI_PARAM The maximal order of the moving average component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
q  = 1
if(exists("settings_userModel_params_q")) 
  q = as.numeric(settings_userModel_params_q)

##PBI_PARAM The degree of the differencing
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
d  = 1
if(exists("settings_userModel_params_d")) 
  d = as.numeric(settings_userModel_params_d)

##PBI_PARAM The  order of the seasonal autoregressive component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
P  = 1
if(exists("settings_userModel_params_P")) 
  P = as.numeric(settings_userModel_params_P)

##PBI_PARAM The maximal order of the seasonal moving average component
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
Q  = 1
if(exists("settings_userModel_params_Q")) 
  Q = as.numeric(settings_userModel_params_Q)

##PBI_PARAM The degree of the differencing
#Type: enum/string, Default:"2", Range:NA, PossibleValues:"0","1","2","3"
D  = 0
if(exists("settings_userModel_params_D")) 
  D = as.numeric(settings_userModel_params_D)

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
  transparency = as.numeric(settings_graph_params_percentile) / 100
<<<<<<< HEAD
<<<<<<< HEAD

##PBI_PARAM: export out data to HTML?
#Type:logical, Default:FALSE, Range:NA, PossibleValues:NA, Remarks: NA
keepOutData = FALSE
if(exists("settings_export_params_show"))
  keepOutData = settings_export_params_show 

##PBI_PARAM: method of export interface
#Type: string , Default:"copy",  Range:NA, PossibleValues:"copy", "download",  Remarks: NA
exportMethod = "copy"
if(exists("settings_export_params_method"))
  exportMethod = settings_export_params_method 

##PBI_PARAM: limit the out table exported
#Type: string , Default:1000,  Range:NA, PossibleValues:"1000", "10000", Inf,  Remarks: NA
limitExportSize = 1000
if(exists("settings_export_params_limitExportSize"))
  limitExportSize = as.numeric(settings_export_params_limitExportSize)

=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5


###############Library Declarations###############

libraryRequireInstall = function(packageName, ...)
{
  if(!require(packageName, character.only = TRUE)) 
    warning(paste("*** The package: '", packageName, "' was not installed ***", sep = ""))
}


libraryRequireInstall("scales")
libraryRequireInstall("forecast")
libraryRequireInstall("zoo")
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly")
<<<<<<< HEAD
<<<<<<< HEAD
libraryRequireInstall("caTools")
=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5

###############Internal parameters definitions#################

#PBI_PARAM Minimal number of points
#Type:integer, Default:10, Range:[0,], PossibleValues:NA, Remarks: NA
minPoints = 10

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
cexSub = 1
if(exists("settings_additional_params_textSize"))
  cexSub = as.numeric(settings_additional_params_textSize)/12

#PBI_PARAM Color for the text string of info 
#Type:string, Default: "brown" , Range:NA, PossibleValues:NA, Remarks: NA
infoTextColor = "brown"
if(exists("settings_additional_params_textColor"))
  infoTextColor = settings_additional_params_textColor

if(confInterval1 > confInterval2)
{#switch places
  temp = confInterval1
  confInterval1 = confInterval2
  confInterval2 = temp
}

lowerConfInterval = confInterval1
upperConfInterval = confInterval2


#PBI_PARAM Size of labels on axes
#Type:numeric , Default:12, Range:NA, PossibleValues:[1,50], Remarks: NA
sizeLabel = 12

#PBI_PARAM Size of warnings font
#Type:numeric , Default:cexSub*10, Range:NA, PossibleValues:[1,50], Remarks: NA
sizeWarn = cexSub*8

#PBI_PARAM Size of ticks on axes 
sizeTicks = 8

#PBI_PARAM opacity of conf interval color
transparencyConfInterval = 0.3 

##PBI_PARAM: Should warnings text be displayed?
#Type:logical, Default:FALSE, Range:NA, PossibleValues:NA, Remarks: NA
showWarnings = FALSE #changed in 1.0.2 (HTML-based) to be FALSE by default 

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
FindTicksNum = function(n,f, flag_ggplot = TRUE)
{
  factorGG = (if(flag_ggplot) 0.525 else 1)
  
  tn = 10* factorGG # default minimum
  mtn = 20 * factorGG # default max
  
  D = 2 # tick/inch
  numCircles = n/f
  xSize = par()$din[1]
  tn = min(max(round(xSize*D*factorGG),tn),mtn)
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
    if(years > 1){
      myformat = "%m/%d/%y %H:%M" # 01/20/10 12:00
    }else{
      if(days > 1){
        myformat = "%b %d, %H:%M" # Jan 01 12:00
      }else{
        if(days <= 1){
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
freqSeason1 = function(seasons, perSeason)
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
  nnn = c("hour", "day", "week", "month", "quarter", "year")
  seasons = rep(NaN, 6)
  names(seasons) = nnn
  perSeason = seasons
  
  seasons["day"]=round(as.numeric(difftime(dates[length(dates)],dates[1]),units="days"))
  seasons["hour"]=round(as.numeric(difftime(dates[length(dates)],dates[1]),units="hours"))
  seasons["week"]=round(as.numeric(difftime(dates[length(dates)],dates[1]),units="weeks"))
  seasons["month"] = seasons["day"]/30
  seasons["year"] = seasons["day"]/365.25
  seasons["quarter"] = seasons["year"]*4
  
  perSeason = N/seasons
  
  if(targetS!="automatic") # target 
    freq = perSeason[targetS]
  
  if(freq < 2) # if TRUE, target season factor is not good 
    freq = 1
  
  for( s in rev(nnn)) # check year --> quarter --> etc
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
  
  skey = c("p","d","q","P","D","Q","m")
  skey = skey[1:length(resString)]
  skey = paste(skey, collapse = ",")
  
  resString = paste("ARIMA: (",skey,") = (",paste(resString,collapse = ","),")",sep = "")
  # add more info 
  if(infoCriteria != "none")
  {
    if(infoCriteria == "AIC")
      resString = paste(resString, "; AIC = ", as.character(round(fit$aic,2)), sep = "")
    else
      if(infoCriteria == "AICc")
        resString = paste(resString, "; AICc = ", as.character(round(fit$aicc,2)), sep = "")
      else
        if(infoCriteria == "BIC")
          resString = paste(resString, "; BIC = ", as.character(round(fit$bic,2)), sep = "")
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


getAngleXlabels = function(mylabels)
{
  NL = length(mylabels)
  NC = nchar(mylabels[1]) * 1.1
  
  lenPerTick = par()$din[1] / (NL * NC)
  
  #lot of space -> 0 
  if(lenPerTick > 0.15)
    return(0)
  
  # no space --> -90
  if(lenPerTick < 0.070)
    return(90)
  
  # few space --> - 45
  return(45)
  
}

<<<<<<< HEAD
<<<<<<< HEAD
ConvertDF64encoding = function (df, withoutEncoding = FALSE)
{
  header_row <- paste(names(df), collapse=", ")
  tab <- apply(df, 1, function(x)paste(x, collapse=", "))
  
  if(withoutEncoding){
    text <- paste(c(header_row, tab), collapse="\n")
    x <- text
  }
  else
  {
    text <- paste(c(header_row, tab), collapse="\n")
    x <- caTools::base64encode(text)
  }
  return(x)
}


KeepOutDataInHTML = function(df, htmlFile = 'out.html', exportMethod = "copy", limitExportSize = 1000)
{
  if(nrow(df)>limitExportSize)
    df = df[1:limitExportSize,]
  
  outDataString64 = ConvertDF64encoding(df)
  
  linkElem = '\n<a href=""  download="data.csv"  style="position: absolute; top:0px; left: 0px; z-index: 20000;" id = "mydataURL">export</a>\n'
  updateLinkElem = paste('<script>\n link_element = document.getElementById("mydataURL");link_element.href = outDataString64href;', '\n</script> ', sep =' ')
  var64 = paste('<script> outDataString64 ="', outDataString64, '"; </script>', sep ="")
  var64href = paste('<script> outDataString64href ="data:;base64,', outDataString64, '"; </script>', sep ="")
  
  buttonElem = '<button style="position: absolute; top:0px; left: 0px; z-index: 20000;"  onclick="myFunctionCopy(1)">copy to clipboard</button>'
  funcScript = '<script> 
  function myFunctionCopy(is64) 
  {
  const el = document.createElement("textarea");
  if(is64)
  {
  el.value = atob(outDataString64);
  }
  else
  {
  el.value = outDataStringPlane;
  }
  document.body.appendChild(el);
  el.select();
  document.execCommand("copy");
  document.body.removeChild(el);};	
  </script>'
  
  if(exportMethod == "copy")
    endOfBody = paste(var64,funcScript, buttonElem,'\n</body>',sep ="")
  else#"download"
    endOfBody = paste(linkElem,var64, var64href,updateLinkElem,'\n</body>',sep ="")
  
  ReadFullFileReplaceString('out.html', 'out.html', '</body>', endOfBody)
  
}

=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5

###############Upfront input correctness validations (where possible)#################
pbiWarning = NULL

if(!exists("Date") || !exists("Value"))
{
  dataset=data.frame()
  pbiWarning  = cutStr2Show("Both 'Date' and 'Value' fields are required.", strCex = 1.55, partAvailable = 0.95)
  timeSeries=ts()
  showWarnings=TRUE
}else{
  dataset= cbind(Date,Value)
  dataset<-dataset[complete.cases(dataset),] #remove corrupted rows
  
  labTime = "Time"
  labValue=names(dataset)[ncol(dataset)]
  
  N=nrow(dataset)
  
  
  if(N==0 && exists("Date") && nrow(Date)>0 &&  exists("Value")){
    
    pbiWarning1  = cutStr2Show("Wrong date type.", strCex = sizeWarn/6, partAvailable = 0.85)
    pbiWarning2 = cutStr2Show("Only 'Date', 'Time', 'Date/Time' are allowed without hierarchy. ", strCex = sizeWarn/6, partAvailable = 0.85)
    pbiWarning = paste(pbiWarning1, pbiWarning2, pbiWarning, sep ="<br>")
    
    timeSeries=ts()
    showWarnings=TRUE
  }else {
    if(N < minPoints)
    {
      timeSeries=ts()
      showWarnings=TRUE
    }
    else
    {
      dataset = dataset[order(dataset[,1]),]
      parsed_dates=strptime(dataset[,1],"%Y-%m-%dT%H:%M:%S",tz="UTC")
      labTime = names(Date)[1]
      
      if((any(is.na(parsed_dates))))
      {
        pbiWarning1  = cutStr2Show("Wrong or corrupted 'Date'.", strCex = sizeWarn/6, partAvailable = 0.85)
        pbiWarning2  = cutStr2Show("Only 'Date', 'Time', 'Date/Time' types are allowed without hierarchy", strCex = sizeWarn/6, partAvailable = 0.85)
        pbiWarning = paste(pbiWarning1, pbiWarning2, pbiWarning, sep ="<br>")
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
                     max.order=4, parallel = FALSE, stepwise = stepwiseSelection)
  
  
  
  fit$method = GetFitMethodString(fit,withSeasonality, infoCriteria)
  
  if(lowerConfInterval <= 0.1)
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
    #pbiInfo = cutStr2Show(pbiInfo,strCex = cexSub, isH = TRUE, maxChar = 20)
    pbiInfo= cutStr2Show(pbiInfo, strCex = sizeWarn / 6, isH = TRUE, partAvailable = 0.9, maxChar = 20)
  }
  
  
  labTime = cutStr2Show(labTime, strCex = sizeLabel/6, isH = TRUE, partAvailable = 0.8)
  labValue = cutStr2Show(labValue, strCex = sizeLabel/6, isH = FALSE, partAvailable = 0.8)
  
  NpF = (length(parsed_dates))+forecastLength
  freq = frequency(timeSeries)
  
  #format  x_with_f
  numTicks = FindTicksNum(NpF,freq) # find based on plot size
  
  x_with_f = as.POSIXlt(seq(from=parsed_dates[1], to = (parsed_dates[1]+interval*(length(parsed_dates)+forecastLength)), length.out = numTicks))
  x_with_forcast_formatted = flexFormat(dates = x_with_f, orig_dates = parsed_dates, freq = freq)
  
  
  x_full = as.POSIXlt(seq(from=parsed_dates[1], to = tail(parsed_dates,1), length.out = length(parsed_dates)))
  f_full = as.POSIXlt(seq(from=tail(parsed_dates,1), to = (tail(parsed_dates,1)+interval*(forecastLength)), length.out = forecastLength+1))
  
  # correction = (NpF-1)/(numTicks-1) # needed due to subsampling of ticks
  
  if(!showWarnings)
  {
    
    #HTML
    #historical data
    x1 = seq(1,length(prediction$x))
    y1 = as.numeric(prediction$x)
    
    p1a<-ggplot(data=NULL,aes(x=x1,y=y1) )
    p1a<-p1a+geom_line(col=alpha(pointsCol,transparency), lwd = pointCex)
    
    #forecast
    x2 = seq(length(prediction$x),length.out = length(prediction$mean))
    y2 = as.numeric(prediction$mean)
    
    
    p1a <- p1a + geom_line(inherit.aes = FALSE ,data = NULL, mapping = aes(x = x2, y = y2), col=alpha(forecastCol,transparency), lwd = pointCex)
    
    #conf intervals
    
    if(!is.null(lowerConfInterval))
    {
      lower2 = lower1 = as.numeric(prediction$lower[,1])
      upper2 = upper1 = as.numeric(prediction$upper[,1])
      id = x2
      
      names(lower2) = names(upper2) = names(lower1) = names(upper1)=  names(f_full) = id   
      cf_full = as.character(f_full)
      
      p1a <- p1a + geom_ribbon( inherit.aes = FALSE , mapping = aes(x = id, ymin = lower1 , ymax = upper1), fill = "blue4", alpha = 0.25)
    }
    
    if(upperConfInterval>0.01)
    {
      if(!is.null(lowerConfInterval))
      {  
        lower2 = as.numeric(prediction$lower[,2])
        upper2 = as.numeric(prediction$upper[,2])
      }
      else
      {  
        lower1 = lower2 = as.numeric(prediction$lower[,1])
        upper1 =upper2 = as.numeric(prediction$upper[,1])
      } 
      
      
      id = x2
      
      names(lower2) = names(upper2) = names(lower1) = names(upper1)=  names(f_full) = id 
      cf_full = as.character(f_full)
      
      
      p1a <- p1a + geom_ribbon( inherit.aes = FALSE , mapping = aes(x = id, ymin = lower2, ymax = upper2), fill = "gray50", alpha = 0.25)
    }
    # if(upperConfInterval>0.01)
    # {
    #   lower1 = as.numeric(prediction$lower[,1])
    #   upper1 = as.numeric(prediction$upper[,1])
    #   lower2 = as.numeric(prediction$lower[,2])
    #   upper2 = as.numeric(prediction$upper[,2])
    #   id = x2
    #   
    #   names(lower1) = names(lower2) = names(upper1)= names(upper2) = names(f_full) = id   
    #   cf_full = as.character(f_full)
    #   
    #   p1a <- p1a + geom_ribbon( inherit.aes = FALSE , mapping = aes(x = id, ymin = lower1 , ymax = upper1), fill = "blue4", alpha = 0.25)
    #   p1a <- p1a + geom_ribbon( inherit.aes = FALSE , mapping = aes(x = id, ymin = lower2, ymax = upper2), fill = "gray50", alpha = 0.25)
    # }
    
    #design 
    p1a <- p1a + labs (title = pbiInfo, caption = NULL) + theme_bw() 
    p1a <- p1a + xlab(labTime) + ylab(labValue) 
    p1a <- p1a + scale_x_continuous(breaks = seq(1,length(prediction$x) + length(prediction$mean)-1, length.out = numTicks), labels = x_with_forcast_formatted) 
    p1a <- p1a +  theme(axis.text.x  = element_text(angle = getAngleXlabels(x_with_forcast_formatted), 
                                                    hjust=1, size = sizeTicks, colour = "gray60"),
                        axis.text.y  = element_text(vjust = 0.5, size = sizeTicks, colour = "gray60"),
                        plot.title  = element_text(hjust = 0.5, size = sizeWarn, colour = infoTextColor), 
                        axis.title=element_text(size =  sizeLabel),
                        axis.text=element_text(size =  sizeTicks),
                        panel.border = element_blank())
    
    
    
  }
  
  
  
}else{ 
  #empty plot
  showWarnings = TRUE
  pbiWarning1  = cutStr2Show("Not enough data points", strCex = sizeWarn/6, partAvailable = 0.85)
  pbiWarning<-paste(pbiWarning, pbiWarning1 , sep="<br>")
}

#add warning as subtitle (or upper title since plotly has bug)
if(showWarnings && !is.null(pbiWarning))
{
  p1a = ggplot() + labs (title = pbiWarning, caption = NULL) + theme_bw() +
    theme(plot.title  = element_text(hjust = 0.5, size = sizeWarn), 
          axis.title=element_text(size =  sizeLabel),
          axis.text=element_text(size =  sizeTicks),
          panel.border = element_blank())
  ggp <- plotly_build(p1a)
}else{
  
  # massage some plot atributes to make transition from ggplot to plotly smooth 
  ggp <- plotly_build(p1a)
  ggp$x$data[[1]]$text = paste(labTime, ": ", x_full, "<br>", labValue, ": ", round(y1,2) , sep ="" ) 
  ggp$x$data[[2]]$text = paste(labTime, ": ", f_full, "<br>", labValue, ": ", round(y2,2) , sep ="" ) 
  
  if(length(ggp$x$data)>=3)
  {
    iii =  as.character(ggp$x$data[[3]]$x)
    ggp$x$data[[3]]$text = paste(labTime, ": ", cf_full[iii], "<br> lower: ", lower1[iii],"<br> upper: ", upper1[iii], sep ="" ) 
  }
  
  if(length(ggp$x$data)>=4)
  {
    iii =  as.character(ggp$x$data[[4]]$x)
    ggp$x$data[[4]]$text = paste(labTime, ": ", cf_full[iii], "<br> lower: ", lower2[iii],"<br> upper: ", upper2[iii], sep ="" ) 
  }
  
  
  
  ggp$x$layout$margin$l = ggp$x$layout$margin$l+10
  
  if(ggp$x$layout$xaxis$tickangle < -40)
    ggp$x$layout$margin$b = ggp$x$layout$margin$b+40
  
}

############# Create and save widget ###############

p <- ggp

disabledButtonsList <- list('toImage', 'sendDataToCloud', 'zoom2d', 'pan', 'pan2d', 'select2d', 'lasso2d', 'hoverClosestCartesian', 'hoverCompareCartesian')
p$x$config$modeBarButtonsToRemove = disabledButtonsList

p <- config(p, staticPlot = FALSE, editable = FALSE, sendData = FALSE, showLink = FALSE,
            displaylogo = FALSE,  collaborate = FALSE, cloud=FALSE)

internalSaveWidget(p, 'out.html')

<<<<<<< HEAD
<<<<<<< HEAD


# resolve bug in plotly (margin of 40 px)
ReadFullFileReplaceString('out.html', 'out.html', ',"padding":40,', ',"padding":0,')

if(keepOutData)
{
  padNA1 = rep(NA,length(x_full))
  padNA2 = rep(NA,length(f_full))
  if(!exists("lower1"))
    lower1 = lower2 = upper1 = upper2 = padNA2;
  
  
  lower1 = c(padNA1,lower1)
  lower2 = c(padNA1,lower2)
  upper1 = c(padNA1,upper1)
  upper2 = c(padNA1,upper2)
  
  exportDF = data.frame(Date = as.character(c(x_full,f_full)),Value = c(y1,y2),
                        lower1 = lower1,
                        lower2 = lower2,
                        upper1 = upper1,
                        upper2 = upper2)
  colnames(exportDF)[c(1,2)] = c(labTime,labValue)
  
  KeepOutDataInHTML(df = exportDF, htmlFile = 'out.html', exportMethod = exportMethod, limitExportSize = limitExportSize)
}



####################################################
#display in R studio
#DEBUG
if(Sys.getenv("RSTUDIO")!="")
  print(p)
=======
=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
####################################################
#display in R studio
# if(Sys.getenv("RSTUDIO")!="")
#   print(p)
<<<<<<< HEAD
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5
=======
>>>>>>> 55f6e110d21b469e720425590dd050b9372c4ca5

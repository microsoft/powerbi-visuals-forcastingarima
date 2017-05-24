# powerbi-visuals-forcastingarima
An R-powered custom visual implementing Auto-regressive Integrated Moving Average (ARIMA) modeling for the forecasting. Time series forecasting is the use of a model to predict future values based on previously observed values.

![Forcastingarima screenshot](https://az158878.vo.msecnd.net/marketing/Partner_21474836617/Product_42949680843/Asset_6f782105-4545-45bc-a8d0-8134edae8251/ForecastingARIMAscreenshot3.png)
# Overview
Use forecasting today to optimize for tomorrow! Time series forecasting is the use of a model to predict future values based on previously observed values.

It is one of the prime tools of any buisness analyst used to predict demand and inventory, budgeting, sales quotas, marketing campaigns and procurement. Accurate forecasts lead to better decisions. Current visual implements well known Autoregressive Integrated Moving Average (ARIMA) method for the forecasting. ARIMA models are general class of models for forecasting a time series which can be made to be “stationary”. While exponential smoothing models are based on a description of trend and seasonality in the data, ARIMA models aim to describe the autocorrelations in the data. Both seasonal and non-seasonal modeling is supported. You can control the algorithm parameters and the visual attributes to suit your needs.

Highlighted features:
* The underlying algorithm requires the input data to be equally spaced time series
* Seasonal factor can be found automatically or set by user
* By default, algorithm will optimize for all the parameters of the model based on certain information criteria
* Advanced user can control all the inner parameters of the model

R package dependencies(auto-installed): proto, zoo

Supports R versions: R 3.3.1, R 3.3.0, MRO 3.3.1, MRO 3.3.0, MRO 3.2.2

See also [Forecasting with ARIMA at Microsoft Office store](https://store.office.com/en-us/app.aspx?assetid=WA104380888&sourcecorrid=6259fbcf-da18-4836-b71f-ca54063847df&searchapppos=0&ui=en-US&rs=en-US&ad=US&appredirect=false)
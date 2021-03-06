% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_anomaly.R, R/get_anomaly_n2kGlmerPoisson.R,
%   R/get_anomaly_n2kInlaNbinomial.R, R/get_anomaly_n2kModel.R
\docType{methods}
\name{get_anomaly}
\alias{get_anomaly}
\alias{get_anomaly,n2kGlmerPoisson-method}
\alias{get_anomaly,n2kGlmerPoisson-methods}
\alias{get_anomaly,n2kInlaNbinomial-method}
\alias{get_anomaly,n2kInlaNbinomial-methods}
\alias{get_anomaly,n2kModel-method}
\title{Get the anomalies from a model}
\usage{
get_anomaly(analysis, ...)

\S4method{get_anomaly}{n2kGlmerPoisson}(analysis, n = 20,
  log.expected.ratio = log(5), log.expected.absent = log(5),
  random.treshold = log(5), verbose = TRUE, ...)

\S4method{get_anomaly}{n2kInlaNbinomial}(analysis, n = 20,
  log.expected.ratio = log(5), log.expected.absent = log(5),
  random.treshold = log(1.05), verbose = TRUE, ...)

\S4method{get_anomaly}{n2kModel}(analysis, verbose = TRUE, ...)
}
\arguments{
\item{analysis}{The model to add}

\item{...}{Extra options. See details}

\item{n}{the maximum number of anomalies per type of anomalies}

\item{log.expected.ratio}{observations that have a abs(log(observed/fitted)) above this ratio are potential anomalies. Defaults to log(5), which implies that observed values that are 5 times higher of lower than the fitted values are potential anomalies.}

\item{log.expected.absent}{Zero observations with log(fitted) larger than this treshold are potential anomalies.}

\item{random.treshold}{random effects with a absolute value above this treshold are potential anomalies}

\item{verbose}{Print extra information on the screen}
}
\description{
Get the anomalies from a model
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/n2k_composite.R
\docType{methods}
\name{n2k_composite}
\alias{n2k_composite}
\alias{n2k_composite,data.frame-method}
\alias{n2k_composite,n2kComposite-methods}
\title{Create a n2kComposite object}
\usage{
n2k_composite(parent.status, ...)

\S4method{n2k_composite}{data.frame}(parent.status, ...)
}
\arguments{
\item{parent.status}{the file fingerprint of the parents}

\item{...}{other arguments. See below}
}
\description{
Create a n2kComposite object

A new n2kComposite model is created when \code{parent} is a data.frame
}
\details{
\describe{
   \item{\code{status}}{a single character indicating the status of the model. Defaults to 'waiting' when \code{parent} is a character.}
   \item{\code{scheme.id}}{a single integer holding the id of the scheme.}
   \item{\code{species.group.id}}{a single integer identifing the species group}
   \item{\code{location.group.id}}{a single integer identifing the location group}
   \item{\code{formula}}{a single character identifying the comparison}
   \item{\code{first.imported.year}}{Oldest year considered in the data}
   \item{\code{last.imported.year}}{Most recent year considered in the data}
   \item{\code{duration}}{The width of the moving window. Defaults to the last.imported.year - first.imported.year + 1}
   \item{\code{last.analysed.year}}{Most recent year in the window. Defaults to \code{last.imported.year}}
   \item{\code{analysis.date}}{A POSIXct date indicating the date that the dataset was imported}
   \item{\code{seed}}{a single integer used as a seed for all calculations. A random seed will be inserted when missing.}
   \item{\code{extractor}}{a function to extract the relevant parameters from the model}
  }
}

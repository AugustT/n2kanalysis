#' Create a n2kInlaNbinomial object
#' @inheritParams n2k_glmer_poisson
#' @details
#'   \describe{
#'    \item{\code{scheme.id}}{a single integer holding the id of the scheme.}
#'    \item{\code{species.group.id}}{a single integer identifing the species group}
#'    \item{\code{location.group.id}}{a single integer identifing the location group}
#'    \item{\code{model.type}}{a single character identifying the type of model to fit to the data}
#'    \item{\code{formula}}{a single character holding the model formula}
#'    \item{\code{first.imported.year}}{Oldest year considered in the data}
#'    \item{\code{last.imported.year}}{Most recent year considered in the data}
#'    \item{\code{duration}}{The width of the moving window. Defaults to the last.imported.year - first.imported.year + 1}
#'    \item{\code{last.analysed.year}}{Most recent year in the window. Defaults to \code{last.imported.year}}
#'    \item{\code{analysis.date}}{A POSIXct date indicating the date that the dataset was imported}
#'    \item{\code{seed}}{a single integer used as a seed for all calculations. A random seed will be inserted when missing.}
#'    \item{\code{lin.comb}}{A model matrix to calculate linear combinations}
#'    \item{\code{replicate.name}}{A list with the names of replicates. Defaults to an empty list. Used in case of \code{f(X, ..., replicate = Z)}}. Should be a named list like e.g. \code{list(X = c("a", "b", "c")).}
#'    \item{\code{imputation.size}}{The required number of imputations defaults to 0.}
#'   }
#' @name n2k_inla_nbinomial
#' @rdname n2k_inla_nbinomial
#' @exportMethod n2k_inla_nbinomial
#' @docType methods
#' @importFrom methods setGeneric
setGeneric(
  name = "n2k_inla_nbinomial",
  def = function(
    data, ..., model.fit
  ){
    standardGeneric("n2k_inla_nbinomial") # nocov
  }
)

#' @description A new n2kInlaNbinomial model is created when \code{data} is a data.frame.
#' @rdname n2k_inla_nbinomial
#' @aliases n2k_inla_nbinomial,n2kInlaNbinomial-methods
#' @importFrom methods setMethod new
#' @importFrom assertthat assert_that is.count is.string is.time
#' @importFrom digest sha1
#' @importFrom stats as.formula
#' @importFrom utils sessionInfo
#' @include n2kInlaNbinomial_class.R
setMethod(
  f = "n2k_inla_nbinomial",
  signature = signature(data = "data.frame"),
  definition = function(
    data, ..., model.fit
  ){
    dots <- list(...)
    #set the defaults for missing arguments in dots
    if (is.null(dots$status)) {
      dots$status <- "new"
    }
    if (is.null(dots$minimum)) {
      dots$minimum <- ""
    }
    if (is.null(dots$seed)) {
      dots$seed <- sample(.Machine$integer.max, 1)
    } else {
      assert_that(is.count(dots$seed))
      dots$seed <- as.integer(dots$seed)
    }
    if (is.null(dots$imputation.size)) {
      dots$imputation.size <- 0L
    } else {
      if (!is.integer(dots$imputation.size)) {
        if (
          abs(as.integer(dots$imputation.size) - dots$imputation.size) > 1e-8
        ) {
          "imputation.size must be integer"
        } else {
          dots$imputation.size <- as.integer(dots$imputation.size)
        }
      }
      assert_that(dots$imputation.size >= 0)
    }
    assert_that(is.string(dots$result.datasource.id))
    assert_that(is.string(dots$scheme.id))
    assert_that(is.string(dots$species.group.id))
    assert_that(is.string(dots$location.group.id))
    assert_that(is.string(dots$model.type))
    assert_that(is.string(dots$formula))
    assert_that(is.count(dots$first.imported.year))
    dots$first.imported.year <- as.integer(dots$first.imported.year)
    assert_that(is.count(dots$last.imported.year))
    dots$last.imported.year <- as.integer(dots$last.imported.year)
    if (is.null(dots$duration)) {
      dots$duration <- dots$last.imported.year - dots$first.imported.year + 1L
    } else {
      assert_that(is.count(dots$duration))
      dots$duration <- as.integer(dots$duration)
    }
    if (is.null(dots$last.analysed.year)) {
      dots$last.analysed.year <- dots$last.imported.year
    } else {
      assert_that(is.count(dots$last.analysed.year))
      dots$last.analysed.year <- as.integer(dots$last.analysed.year)
    }
    assert_that(is.time(dots$analysis.date))
    if (is.null(dots$parent)) {
      dots$parent <- character(0)
    }
    if (!is.null(dots$lin.comb)) {
      assert_that(
        inherits(dots$lin.comb, "matrix") |
          inherits(dots$lin.comb, "list")
      )
    }
    if (is.null(dots$replicate.name)) {
      dots$replicate.name <- list()
    }
    assert_that(is.list(dots$replicate.name))
    if (length(dots$replicate.name) > 0) {
      if (is.null(names(dots$replicate.name))) {
        stop("replicate.name must have names")
      }
    }
    file.fingerprint <- sha1(
      list(
        data, dots$result.datasource.id, dots$scheme.id, dots$species.group.id,
        dots$location.group.id,
        dots$model.type, dots$formula, dots$first.imported.year,
        dots$last.imported.year, dots$duration, dots$last.analysed.year,
        format(dots$analysis.date, tz = "UTC"),
        dots$seed, dots$parent, dots$replicate.name,
        dots$lin.comb, dots$imputation.size, dots$minimum
      )
    )

    if (length(dots$parent) == 0) {
      analysis.relation <- data.frame(
        Analysis = character(0),
        ParentAnalysis = character(0),
        ParentStatusFingerprint = character(0),
        ParentStatus = character(0),
        stringsAsFactors = FALSE
      )
    } else {
      assert_that(is.string(dots$parent))
      if (is.null(dots$parent.status.fingerprint)) {
        if (is.null(dots$parent.status)) {
          dots$parent.status <- "converged"
        }
        dots$parent.statusfingerprint <- sha1(dots$parent.status)
      } else {
        if (is.null(dots[["parent.status"]])) {
          stop(
"'parent.status' is required when 'parent.status.fingerprint' is provided"
          )
        }
      }
      analysis.relation <- data.frame(
        Analysis = file.fingerprint,
        ParentAnalysis = dots$parent,
        ParentStatusFingerprint = dots$parent.statusfingerprint,
        ParentStatus = dots$parent.status,
        stringsAsFactors = FALSE
      )
    }
    version <- get_analysis_version(sessionInfo())
    status.fingerprint <- sha1(
      list(
        file.fingerprint, dots$status, NULL,
        version@AnalysisVersion$Fingerprint, version@AnalysisVersion,
        version@RPackage,  version@AnalysisVersionRPackage, analysis.relation,
        NULL
      ),
      digits = 6L
    )

    new(
      "n2kInlaNbinomial",
      AnalysisVersion = version@AnalysisVersion,
      RPackage = version@RPackage,
      AnalysisVersionRPackage = version@AnalysisVersionRPackage,
      AnalysisMetadata = data.frame(
        ResultDatasourceID = dots$result.datasource.id,
        SchemeID = dots$scheme.id,
        SpeciesGroupID = dots$species.group.id,
        LocationGroupID = dots$location.group.id,
        ModelType = dots$model.type,
        Formula = dots$formula,
        FirstImportedYear = dots$first.imported.year,
        LastImportedYear = dots$last.imported.year,
        Duration = dots$duration,
        LastAnalysedYear = dots$last.analysed.year,
        AnalysisDate = dots$analysis.date,
        Seed = dots$seed,
        Status = dots$status,
        AnalysisVersion = version@AnalysisVersion$Fingerprint,
        FileFingerprint = file.fingerprint,
        StatusFingerprint = status.fingerprint,
        stringsAsFactors = FALSE
      ),
      AnalysisFormula = list(as.formula(dots$formula)),
      AnalysisRelation = analysis.relation,
      Data = data,
      ReplicateName = dots$replicate.name,
      LinearCombination = dots$lin.comb,
      Model = NULL,
      ImputationSize = dots$imputation.size,
      Minimum = dots$minimum,
      RawImputed = NULL
    )
  }
)

#' @description In case \code{data} a n2kInlaNbinomial object is, then only the model and status are updated. All other slots are unaffected.
#' @rdname n2k_inla_nbinomial
#' @aliases n2k_inla_nbinomial,n2kInlaNbinomial-methods
#' @importFrom methods setMethod validObject new
#' @importFrom digest sha1
#' @importFrom utils sessionInfo
#' @include n2kInlaNbinomial_class.R
setMethod(
  f = "n2k_inla_nbinomial",
  signature = signature(data = "n2kInlaNbinomial", model.fit = "inla"),
  definition = function(
    data, ..., model.fit
  ){
    dots <- list(...)
    data@Model <- model.fit
    data@AnalysisMetadata$Status <- dots$status
    version <- get_analysis_version(sessionInfo())
    new.version <- union(data, version)
    data@AnalysisVersion <- new.version$Union@AnalysisVersion
    data@RPackage <- new.version$Union@RPackage
    data@AnalysisVersionRPackage <- new.version$Union@AnalysisVersionRPackage
    data@AnalysisMetadata$AnalysisVersion <- new.version$UnionFingerprint
    data@RawImputed <- dots$raw.imputed
    data@AnalysisMetadata$StatusFingerprint <- sha1(
      list(
        data@AnalysisMetadata$FileFingerprint, data@AnalysisMetadata$Status,
        data@Model, data@AnalysisMetadata$AnalysisVersion,
        data@AnalysisVersion, data@RPackage, data@AnalysisVersionRPackage,
        data@AnalysisRelation, data@RawImputed
      ),
      digits = 6L
    )

    validObject(data)
    return(data)
  }
)

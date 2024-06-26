#' @export
makeRLearner.regr.tuneRanger = function() {
  makeRLearnerRegr(
    cl = "regr.tuneRanger",
    package = "tuneRanger",
    par.set = makeParamSet(
      makeUntypedLearnerParam(id = "measure", default = mmce),
      makeIntegerLearnerParam(id = "iters", lower = 1L, default = 70L),
      makeIntegerLearnerParam(id = "iters.warmup", lower = 1L, default = 30L),
      makeNumericLearnerParam(id = "time.budget", lower = 1L),
      makeIntegerLearnerParam(id = "num.threads", lower = 1L, when = "both", tunable = FALSE),
      makeIntegerLearnerParam(id = "num.trees", lower = 1L, default = 500L),
      makeUntypedLearnerParam(id = "tune.parameters", default = c("mtry", "min.node.size", "sample.fraction")),
      makeUntypedLearnerParam(id = "parameters", default = list(replace = FALSE, respect.unordered.factors = "order"))
    ),
    properties = c("numerics", "factors", "ordered"),
    name = "Random Forests",
    short.name = "tuneRanger",
    note = "By default, internal parallelization is switched off (`num.threads = 1`), `verbose` output is disabled, `respect.unordered.factors` is set to `order`. All settings are changeable."
  )
}

#' @export
trainLearner.regr.tuneRanger = function(.learner, .task, .subset, .weights = NULL, ...) {
  tuneRanger::tuneRanger(task = subsetTask(.task, .subset), build.final.model = TRUE, ...)$model
}

#' @export
predictLearner.regr.tuneRanger = function(.learner, .model, .newdata, ...) {
  model = .model$learner.model$learner.model
  p = predict(object = model, data = .newdata, type = "response", ...)
  return(p$predictions)
}


Q = require "q"

seq = (fns...) ->
  fns.reduceRight((acc, fn) ->
    ->
      Q.try ->
        fn.apply(this, arguments)
      .then acc
  , (x) -> x)()

module.exports = seq

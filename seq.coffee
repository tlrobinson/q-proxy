seq = (fns...) ->
  fns.reduceRight((acc, fn) ->
    -> fn.apply(this, arguments).then acc
  , (x) -> x)()
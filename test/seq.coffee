
Q = require "q"
seq = require "../seq"

seq(
  (x) -> Q.delay(1000).then -> console.log "1#{x}"; "x"
  (x) -> Q.delay(1000).then -> console.log "2#{x}"; "y"
  (x) -> Q.delay(1000).then -> console.log "3#{x}"; "z"
).then (x) ->
  console.log x
.done()
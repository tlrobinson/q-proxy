
Q = require "q"
QProxy = require "../index.coffee"

p = Q.delay(1000).then ->
  foo: ->
    console.log "foo"
    bar: ->
      console.log "bar"
      Q.delay(1000).then ->
        console.log "baz0"
        baz: ->
          console.log "baz"
          1234

QProxy(p).foo().delay(1000).bar().delay(2000).baz().delay(3000).then (result) ->
  console.log result

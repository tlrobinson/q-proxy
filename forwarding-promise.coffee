Q = require "q"

Proxy = require "node-proxy"
ForwardingHandler = require "./forwarding-handler"

makeForwardingPromise = (target) ->
  forwarder = new ForwardingHandler(target)
  forwarder.get = (rcvr, name) ->
    if typeof @target[name] is "function" or @target[name] is undefined
      =>
        args = arguments
        makeForwardingPromise target.then (result) =>
          (@target[name] or result[name]).apply(@target, args)
    else
      @target[name]
  Proxy.create(forwarder, Object.getPrototypeOf(target))

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

p = makeForwardingPromise(p)

p.foo().delay(1000).bar().delay(2000).baz().delay(3000).then (result) ->
  console.log result

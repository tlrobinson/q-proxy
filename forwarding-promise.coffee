Q = require "q"

Proxy = require "node-proxy"
ForwardingHandler = require "./forwarding-handler"

makeForwardingPromise = (target) ->
  forwarder = new ForwardingHandler(target)
  forwarder.get = (rcvr, name) ->
    if typeof @target[name] is "function" or @target[name] is undefined
      =>
        args = arguments
        if typeof @target[name] is "function"
          console.log "name1", name
          makeForwardingPromise target.then (result) =>
            @target[name].apply(@target, args)
        else
          console.log "name2", name
          makeForwardingPromise target.then (result) =>
            result[name].apply(result, args)
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

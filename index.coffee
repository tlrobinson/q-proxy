Q = require "q"

Proxy = require "node-proxy"
ForwardingHandler = require "./forwarding-handler"

QProxy = (target) ->
  forwarder = new ForwardingHandler(target)
  forwarder.get = (rcvr, name) ->
    if typeof target[name] is "function" or target[name] is undefined
      =>
        args = arguments
        if target[name]
          result = target[name].apply(target, args)
        else
          result = target.post(name, args)
        if result? and typeof result is "object"
          QProxy result
        else
          result
    else
      @target[name]
  Proxy.create(forwarder, Object.getPrototypeOf(target))

module.exports = QProxy

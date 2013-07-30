Q = require "q"

Proxy = require "node-proxy"
ForwardingHandler = require "./forwarding-handler"

QProxy = (target) ->
  forwarder = new ForwardingHandler(target)
  forwarder.get = (rcvr, name) ->
    if typeof @target[name] is "function" or @target[name] is undefined
      =>
        args = arguments
        if @target[name]
          QProxy Q.when @target, => @target[name].apply(@target, args)
        else
          QProxy target.post(name, args)
    else
      @target[name]
  Proxy.create(forwarder, Object.getPrototypeOf(target))

module.exports = QProxy

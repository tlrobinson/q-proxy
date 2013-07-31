require("mocha-as-promised")()
chai = require "chai"
chai.should()
chai.use require "chai-as-promised"
{ expect } = chai

Q = require "q"
QProxy = require "../index"

LEVELS = 4

makeObject = (child) ->
  object =
    self: -> object
    value: -> "ok"
    child: -> child
    delay: -> Q.delay(0).then -> child
    error: -> throw new Error()

mapping =
  s: "self"
  v: "value"
  c: "child"
  d: "delay"
  e: "error"

codes = [""].concat Object.keys(mapping)

generateCases = (depth) ->
  return [""] if depth is 0
  cases = {}
  for prefix in codes
    for suffix in generateCases(depth - 1)
      id = "#{prefix}#{suffix}"
      cases[id] = true if id
  Object.keys cases

fnForMethods = (object, methods) ->
  ->
    result = object
    result = result[method]() for method in methods
    result

describe "QProxy", ->
  original = makeObject(makeObject(makeObject(makeObject("ok"))))
  proxy = QProxy(original)

  for c in generateCases(LEVELS) when c.match(/^[^v]*[ve]$/) # value or error at end
    do (c) ->
      components = c.split("")
      methods = components.map (c) -> mapping[c]
      identifier = "proxy." + methods.join("().") + "()"
      # no error, delay, error
      if c.match(/^[^e]*d.*e.*$/)
        it "#{identifier} should be rejected", ->
          fnForMethods(proxy, methods)().should.be.rejected
      # no error or value, delay, no error
      else if c.match(/^[^e]*d[^e]*$/)
        it "#{identifier} should resolve to 'ok'", ->
          fnForMethods(proxy, methods)().should.eventually.equal("ok")
      # no delay or value, error
      else if c.match(/^[^d]*e/)
        it "#{identifier} should throw", ->
          fnForMethods(proxy, methods).should.throw()
      else
        it "#{identifier} should be equal 'ok'", ->
          fnForMethods(proxy, methods)().should.equal("ok")

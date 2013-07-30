# WebDriver

wd = require "wd"
Q = require "q"
QProxy = require "../index.coffee"
QStep = require "q-step"

browser = QProxy(wd.promiseRemote("localhost", 4444))

loginFacebook = (credentials) ->
  QStep(
    -> browser.init(browserName: "firefox")
    -> browser.get("https://www.facebook.com/")
    -> browser.elementById("email").type(credentials.email)
    -> browser.elementById("pass").type(credentials.password)
    -> browser.elementById("u_0_b").click()
  )

# Without QProxy:
#
#   QStep(
#     -> browser.init(browserName: "firefox")
#     -> browser.get("https://www.facebook.com/")
#     -> browser.elementById("email")
#     (e) -> e.type(credentials.email)
#     -> browser.elementById("pass")
#     (e) -> e.type(credentials.password)
#     -> browser.elementById("u_0_b")
#     (e) -> e.click()
#   )
#
# Or:
#
#   QStep(
#     -> browser.init(browserName: "firefox")
#     -> browser.get("https://www.facebook.com/")
#     -> browser.elementById("email").then (e) -> e.type(credentials.email)
#     -> browser.elementById("pass").then (e) -> e.type(credentials.password)
#     -> browser.elementById("u_0_b").then (e) -> e.click()
#   )

credentials =
  email: "EMAIL"
  password: "PASSWORD"

loginFacebook(credentials).then ->
  console.log "ok!"
.fin ->
  browser.quit()
.done()

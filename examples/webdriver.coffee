# WebDriver

wd = require "wd"
Q = require "q"
QQ = require "../forwarding-promise"
seq = require "../seq"

browser = QQ(wd.promiseRemote("localhost", 4444))

loginFacebook = (credentials) ->
  seq(
    -> browser.init(browserName: "firefox")
    -> browser.get("https://www.facebook.com/")
    -> browser.elementById("email").type(credentials.email)
    -> browser.elementById("pass").type(credentials.password)
    -> browser.elementById("u_0_b").click()
  )

credentials =
  email: "EMAIL"
  password: "PASSWORD"

loginFacebook(credentials).then ->
  console.log "ok!"
.fin ->
  browser.quit()
.done()

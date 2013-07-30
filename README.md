# QProxy

QProxy wraps JavaScript promises (Promises/A spec, e.x. Q) to allow you to chain arbitrary method calls before proxy is resolved.

For example, normally with the `wd` WebDriver library you would need to do the following:

    browser.elementById("email").then(function(element) {
      element.type("tlrobinson@gmail.com");
    });

With QProxy you can do the following:

    QProxy(browser).elementById("email").type("tlrobinson@gmail.com")

Once the result of `elementById` is resolved the `type` method will actually be called with the correct arguments. The whole expression returns a promise which is resolved after both the `elementById` and subsequent `type` invocations are resolved.

With a sequential helper library such as [QStep](http://github.com/tlrobinson/q-step) you could do the following (CoffeeScript):

    browser = QProxy(wd.promiseRemote("localhost", 4444))
    QStep(
      -> browser.init(browserName: "firefox")
      -> browser.get("https://www.facebook.com/")
      -> browser.elementById("email").type(credentials.email)
      -> browser.elementById("pass").type(credentials.password)
      -> browser.elementById("u_0_b").click()
    )

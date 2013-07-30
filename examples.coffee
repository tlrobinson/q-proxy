# WebDriver

browser = QQ(@browser)

login = (credentials) ->
  seq(
    -> browser.get("https://website.com/")
    -> browser.elementByXPath(@EMAIL_XPATH).type(credentials.email)
    -> browser.elementByXPath(@PASSWORD_XPATH).type(credentials.password)
    -> browser.elementByXPath(@SUBMIT_XPATH).click()
  )
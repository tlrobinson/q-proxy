build: index.js

watch:
	node_modules/.bin/coffee -w -c index.coffee

%.js: %.coffee
	node_modules/.bin/coffee -c $^

test:
	node_modules/.bin/mocha --compilers coffee:coffee-script test

.PHONY: watch test

superglue = require 'super-glue'

devDataUrl = "http://localhost:3009/dev/data/"
app = new superglue(devDataUrl)

module.exports = app

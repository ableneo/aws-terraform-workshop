const express = require('express')
const app = express()

app.get('/', function (req, res) {
    res.send('Hello from backend!')
})

app.listen(8080)

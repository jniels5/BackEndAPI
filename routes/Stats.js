var express = require('express');
var router = express.Router();

// Pull in route files
var Filter = require("./Stats/Filter.js");
var Modal = require("./Stats/Modal.js");
var Search = require("./Stats/Search.js");

// Specify Paths
router.use('/filter/', Filter);
router.use('/Modal/', Modal);
router.use('/search/', Search);

module.exports = router
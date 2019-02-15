'use strict';

var express = require('express');
var router = express.Router();

router.get('/', function (req, res, next) {
  var file = [];
  var folder = [];
  file.push({
    name: 'lsusb'
  });
  file.push({
    name: 'ifconfig'
  });
  file.push({
    name: 'systemctl'
  });
  folder.push({
    dirname: 'udev/rules.d/',
    file: [
      { name: '49-orbbec.rules' },
      { name: '60-rplidar.rules' }
    ]
  })
  res.render('index', { file, folder });
});



module.exports = router;

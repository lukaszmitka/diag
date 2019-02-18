'use strict';

var express = require('express');
var router = express.Router();
var fs = require('fs');

router.get('/', function (req, res, next) {
  var filetab = [];
  var file = [];
  var folder = [];
  var folder_files = [];

  const testFolder = './data/';

  var options = {
    encoding: 'utf8',
    withFileTypes: true
  }
  fs.readdirSync(testFolder, options).forEach(fileDirEnt => {
    if (fileDirEnt.isFile()) {
      file.push({
        name: fileDirEnt.name
      });
      filetab.push({
        name: fileDirEnt.name,
        content: 'Lorem ipsum'
      })
    } else if (fileDirEnt.isDirectory()) {
      folder_files = [];
      fs.readdirSync(testFolder + fileDirEnt.name, options).forEach(indirfilename => {
        if (indirfilename.isFile()) {
          folder_files.push({
            name: indirfilename.name
          })
          filetab.push({
            name: indirfilename.name,
            content: 'Lorem ipsum dolor sit amet'
          })
        }
      });
      folder.push({
        dirname: fileDirEnt.name,
        file: folder_files
      }
      );
    }
  });
  res.render('index', { file, folder, filetab });
});



module.exports = router;

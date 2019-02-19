'use strict';

var express = require('express');
var router = express.Router();
var fs = require('fs');

router.get('/', function (req, res, next) {
  var filetab = [];
  var file = [];
  var folder = [];
  var folder_files = [];
  var file_content = '';
  var lines_splitted = '';
  var lines = [];
  var i = 0;
  const testFolder = './data/';

  var options = {
    encoding: 'utf8',
    withFileTypes: true
  }

  var file_read_options = {
    encoding: 'utf8',
    flag: 'r'
  }

  fs.readdirSync(testFolder, options).forEach(fileDirEnt => {
    if (fileDirEnt.isFile()) {
      file.push({
        name: fileDirEnt.name
      });

      file_content = fs.readFileSync(testFolder + fileDirEnt.name, file_read_options);
      lines_splitted = file_content.split('\n');
      lines = [];
      for (i = 0; i < lines_splitted.length; i++) {
        lines.push({
          content: lines_splitted[i]
        })
      }
      filetab.push({
        name: fileDirEnt.name,
        line: lines
      });
    } else if (fileDirEnt.isDirectory()) {
      folder_files = [];
      fs.readdirSync(testFolder + fileDirEnt.name, options).forEach(indirfilename => {
        if (indirfilename.isFile()) {
          folder_files.push({
            name: indirfilename.name
          })
          file_content = fs.readFileSync(testFolder + fileDirEnt.name + '/' + indirfilename.name, file_read_options);
          lines_splitted = file_content.split('\n');
          lines = [];
          for (i = 0; i < lines_splitted.length; i++) {
            lines.push({
              content: lines_splitted[i]
            })
          }
          filetab.push({
            name: indirfilename.name,
            line: lines
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

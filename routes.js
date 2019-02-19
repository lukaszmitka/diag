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

  var metadata = JSON.parse(fs.readFileSync(testFolder + 'config.json', 'utf8'));
  file = metadata.file;
  file.forEach(fileEntry => {
    file_content = fs.readFileSync(fileEntry.name, file_read_options);
    lines_splitted = file_content.split('\n');
    lines = [];
    for (i = 0; i < lines_splitted.length; i++) {
      lines.push({
        content: lines_splitted[i]
      })
    }
    filetab.push({
      id: fileEntry.id,
      line: lines
    });
  });

  folder = metadata.folder;
  folder.forEach(folderEntry => {
    folderEntry.file.forEach(folderFile => {
      console.log(folderFile.name);
      file_content = fs.readFileSync(folderFile.name, file_read_options);
      lines_splitted = file_content.split('\n');
      lines = [];
      for (i = 0; i < lines_splitted.length; i++) {
        lines.push({
          content: lines_splitted[i]
        })
      }
      filetab.push({
        id: folderFile.id,
        line: lines
      });
    });
  });
  res.render('index', { file, folder, filetab });
});

module.exports = router;

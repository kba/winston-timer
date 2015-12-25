'use strict';
var winston = require('winston');
require('..')(winston)
winston.level = 'silly'

winston.start_log('test-timer-1', 'debug');
setTimeout(function() {
  winston.stop_log('test-timer-1');
  winston.start('test-timer-2', 'error', 'Starting ', ' now');
  setTimeout(function() {
    var diff = winston.stop('test-timer-2');
    winston.log('debug', 'Executing "test-timer-2" took ' + diff[0] + " second and " + diff[1] + " nanoseconds.");
    winston.start('test-timer-3');
    setTimeout(function() {
      var diff_ms = winston.stop_ms('test-timer-3');
      winston.log('debug', 'Executing "test-timer-3" took ' + diff_ms + " ms");
    }, 1000);
  }, 1000);
}, 1000);

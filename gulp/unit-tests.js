'use strict';

var gulp = require('gulp');

var $ = require('gulp-load-plugins')();

var wiredep = require('wiredep');

gulp.task('test', ['coffee'], function() {
  var bowerDeps = wiredep({
    directory: 'src/bower_components',
    exclude: ['bootstrap-sass-official'],
    dependencies: true,
    devDependencies: true
  });

  var testFiles = bowerDeps.js.concat([
    '{src,tmp}/!(bower_components)/**/*.js',
    '!**/*.e2e.js'
  ]);

  return gulp.src(testFiles)
    //.pipe($.filelog()); a
    .pipe($.karma({
      configFile: 'test/karma.conf.js',
      action: 'run'
    }))
    .on('error', function(err) {
      // Make sure failed tests cause gulp to exit non-zero
      throw err;
    });
});

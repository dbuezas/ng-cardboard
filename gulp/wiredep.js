'use strict';

var gulp = require('gulp');

// inject bower components
gulp.task('wiredep', function () {
  var wiredep = require('wiredep').stream;

  gulp.src('src/*.html')
    .pipe(wiredep({
      directory: 'src/bower_components',
      exclude: ['/bootstrap/'] 
    }))
    .pipe(gulp.dest('src'));
});

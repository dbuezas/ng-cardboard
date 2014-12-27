'use strict';

var gulp = require('gulp');
var inject = require('gulp-inject');

gulp.task('injectOwnScriptsAndStyles', ['coffee', 'styles'], function () {
  return gulp.src('src/index.html')
	.pipe(inject(gulp.src(['{src,tmp}/**/*.js','!**/*{e2e,test,partial}.js','!**/bower_components/**']), {
      read: false,
      starttag: '<!-- inject:scripts -->',
      addRootSlash: false,
      ignorePath: ['tmp','src']
    }))
    .pipe(inject(gulp.src(['{tmp,src}/**/*.css','!**/bower_components/**']), {
      read: false,
      starttag: '<!-- inject:styles -->',
      addRootSlash: false,
      ignorePath: ['tmp','src']
    }))
    .pipe(gulp.dest('src'));
});
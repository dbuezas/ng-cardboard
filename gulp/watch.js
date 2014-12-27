'use strict';

var gulp = require('gulp');

gulp.task('watch', ['injectOwnScriptsAndStyles', 'wiredep'], function () {
  gulp.watch('src/{app,components,services}/**/*.less', ['styles']);
  gulp.watch('src/{app,components,services}/**/*.coffee', ['coffee']);
  // todo: only inject Components for NEW files
  // use gulp-watch instead of gulp.watch as it doesn't watch for new files
  // gulp.watch('tmp/{app,components}/**/*.js', ['injectComponents']);
  // gulp.watch('tmp/components/**/*.css', ['injectStyles']);
  gulp.watch('src/assets/images/**/*', ['images']);
  gulp.watch('bower.json', ['wiredep']);
});

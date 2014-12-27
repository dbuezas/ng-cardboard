'use strict';

var gulp = require('gulp');

var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license']
});

gulp.task('obj2json', function(){
	if (!$.util.env.n || $.util.env.n == '') {
		$.util.log($.util.colors.red('Please give a name with -n'));
		process.exit(1);
	}
	var threeOBJ = require("three-obj")()
	var file = $.util.env.n;
	threeOBJ.convert( file, file+'.json'/*, callback*/ )


})


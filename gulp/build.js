'use strict';

var gulp = require('gulp');

var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license']
});

var cssRebaseUrls = require('css-rebase-urls');

function handleError(err) {
  console.error(err.toString());
  $.util.beep();
  this.emit('end');
}

gulp.task('styles', function () {
  return gulp.src(['src/**/*.less', '!**/bower_components/**'])
    .pipe($.changed('tmp', {
      extension: '.css'
    }))
    .pipe($.less({
      paths: [
        'src'
      ]
    }))
    .on('error', handleError)
    .pipe($.autoprefixer('last 1 version'))
    .pipe(gulp.dest('tmp'))
    .pipe($.size());
});

gulp.task('coffee', function () {
  return gulp.src(['src/**/*.coffee'])
    .pipe($.changed('tmp', {
      extension: '.js'
    }))
    .pipe($.coffee({sourceMap: false}))
    .on('error', handleError)
    .pipe(gulp.dest('tmp'))
    .pipe($.size());
});

gulp.task('partials', function () {
  return gulp.src(['src/**/*.html', '!**/bower_components/**', ])
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe($.ngHtml2js({
      moduleName: 'ngCardboard'
    }))
    .pipe($.rename({suffix: '.partial'}))
    .pipe(gulp.dest('tmp'))
    .pipe($.size());
});

gulp.task('html', ['wiredep', 'partials', 'injectOwnScriptsAndStyles'], function () {
  var htmlFilter = $.filter('*.html');
  var jsFilter = $.filter('**/*.js');
  var cssFilter = $.filter('**/*.css');
  var assets;
  return gulp.src('src/index.html')
    .pipe($.inject(gulp.src(['tmp/**/*.partial.js']), {
      read: false,
      starttag: '<!-- inject:partials -->',
      addRootSlash: false,
      addPrefix: '../'
    }))
    .pipe(assets = $.useref.assets({
      preprocess: {
        css: cssRebaseUrls
      }
    }))
    .pipe($.rev())
    .pipe(jsFilter)
    .pipe($.ngAnnotate())
    .pipe($.uglify({preserveComments: $.uglifySaveLicense}))
    .pipe(jsFilter.restore())
    .pipe(cssFilter)
    .pipe($.replace('bower_components/bootstrap/fonts','fonts'))
    // .pipe($.csso())
    .pipe($.minifyCss())
    .pipe(cssFilter.restore())
    .pipe(assets.restore())
    .pipe($.useref())
    .pipe($.revReplace())
    .pipe(htmlFilter)
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe(htmlFilter.restore())
    .pipe(gulp.dest('dist'))
    .pipe($.size());
});

gulp.task('images', function () {
  return gulp.src(['src/**/*.{png,jpg}', '!src/bower_components/**'])
    .pipe($.imagemin({
      optimizationLevel: 3,
      progressive: true,
      interlaced: true
    })) //cache brakes the stream (!?)
    .pipe(gulp.dest('dist'))
    .pipe($.size());
});

gulp.task('copy', function () {
  return gulp.src(['src/**/*.{mp3,svg}'])
    .pipe(gulp.dest('dist'))
    .pipe($.size());
});

gulp.task('fonts', function () {
  return gulp.src($.mainBowerFiles())
    .pipe($.filter('**/*.{eot,svg,ttf,woff}'))
    .pipe($.flatten())
    .pipe(gulp.dest('dist/fonts'))
    .pipe($.size());
});

gulp.task('clean', function () {
  return gulp.src(['tmp1', 'tmp', 'dist'], { read: false }).pipe($.rimraf());
});


gulp.task('build', ['html', 'images', 'copy', 'fonts'], function(){
  gulp.src(['dist/**'])
  .pipe($.manifest({
      hash: true,
      preferOnline: true,
      network: [
        'http://*',
        'https://*',
        '*',
      ],
      filename: 'cache.manifest',
      exclude: 'cache.manifest',
      timestamp: true
    }))
  .pipe(gulp.dest('dist'));
});

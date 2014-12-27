'use strict';

var gulp = require('gulp');

require('require-dir')('./gulp');

gulp.task('default', ['clean'], function () {
    gulp.start('build');
});

// GULP DEPENDENCY DIAGRAM: http://yuml.me/edit/8b11e3c5
// [build]->[html]
// [build]->[images]
// [build]->[fonts]


// [html]->[scripts]
// [html]->[partials]
// [html]->[injectComponents]
// [html]->[injectStyles]
// [html]->[wiredep]

// [watch]->[injectComponents]
// [watch]->[injectStyles]
// [watch]->[wiredep]


// [serve]->[watch]

// [serve:dist]->[build]
// [injectComponents]->[coffee]
// [injectStyles]->[styles]

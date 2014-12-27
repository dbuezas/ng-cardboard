var gulp = require('gulp'),
    pjson = require('../package.json'),
    $ = require('gulp-load-plugins')();

gulp.task('add:controller', function(){
	if (!$.util.env.n || $.util.env.n == '') {
		$.util.log($.util.colors.red('Please give a name with -n'));
		process.exit(1);
	}

	var name = $.util.env.n;
    var destPath = './src/app/' + name + '/'
    var cameledName = name.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase() });

    gulp.src('templates/controller/template.controller.coffee')
    	.pipe($.template({
            appName: pjson.name,
            name: cameledName + "Ctrl"
        }))
    	.pipe($.rename(name + ".controller.coffee"))
    	.pipe(gulp.dest(destPath));

    gulp.src('templates/controller/template.html')
    	.pipe($.template({name: cameledName + "Ctrl"}))
    	.pipe($.rename(name + ".html"))
    	.pipe(gulp.dest(destPath));

   	gulp.src('templates/controller/template.less')
    	.pipe($.rename(name + ".less"))
    	.pipe(gulp.dest(destPath));

    gulp.src('templates/controller/template.e2e.coffee')
    	.pipe($.template({name: cameledName}))
    	.pipe($.rename(name + ".e2e.coffee"))
    	.pipe(gulp.dest(destPath));

    gulp.src('templates/controller/template.test.coffee')
        .pipe($.template({appName: pjson.name}))
    	.pipe($.rename(name + ".test.coffee"))
    	.pipe(gulp.dest(destPath));
});

gulp.task('add:directive', function(){
	if (!$.util.env.n || $.util.env.n == '') {
		$.util.log($.util.colors.red('Please give a name with -n'));
		process.exit(1);
	}

	var name = $.util.env.n;
    var destPath = './src/components/' + name + '/'
    var cameledName = name.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase() });

    gulp.src('templates/directive/template.directive.coffee')
    	.pipe($.template({
            appName: pjson.name,
    		name: name,
    		cameledName: cameledName
    	}))
    	.pipe($.rename(name + ".directive.coffee"))
    	.pipe(gulp.dest(destPath));

    gulp.src('templates/directive/template.html')
    	.pipe($.template({name: name}))
    	.pipe($.rename(name + ".html"))
    	.pipe(gulp.dest(destPath));

   	gulp.src('templates/directive/template.less')
    	.pipe($.rename(name + ".less"))
    	.pipe(gulp.dest(destPath));
});

gulp.task('add:factory', function(){
	if (!$.util.env.n || $.util.env.n == '') {
		$.util.log($.util.colors.red('Please give a name with -n'));
		process.exit(1);
	}
	var name = $.util.env.n;
    var destPath = './src/services/' + name + '/'
    var cameledName = name.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase() });

    gulp.src('templates/factory/template.factory.coffee')
    	.pipe($.template({
            appName: pjson.name,
    		cameledName: cameledName
    	}))
    	.pipe($.rename(name + ".factory.coffee"))
    	.pipe(gulp.dest(destPath));
});

gulp.task('add:provider', function(){
	if (!$.util.env.n || $.util.env.n == '') {
		$.util.log($.util.colors.red('Please give a name with -n'));
		process.exit(1);
	}
	var name = $.util.env.n;
    var destPath = './src/components/' + name + '/'
    var cameledName = name.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase() });

    gulp.src('templates/provider/template.provider.coffee')
    	.pipe($.template({
            appName: pjson.name,
    		cameledName: cameledName
    	}))
    	.pipe($.rename(name + ".provider.coffee"))
    	.pipe(gulp.dest(destPath));
});

gulp.task('add:service', function(){
	if (!$.util.env.n || $.util.env.n == '') {
		$.util.log($.util.colors.red('Please give a name with -n'));
		process.exit(1);
	}
	var name = $.util.env.n;
    var destPath = './src/services/' + name + '/'
    var cameledName = name.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase() });

    gulp.src('templates/service/template.service.coffee')
    	.pipe($.template({
            appName: pjson.name,
    		cameledName: cameledName
    	}))
    	.pipe($.rename(name + ".service.coffee"))
    	.pipe(gulp.dest(destPath));
});

gulp.task('add:filter', function(){
	if (!$.util.env.n || $.util.env.n == '') {
		$.util.log($.util.colors.red('Please give a name with -n'));
		process.exit(1);
	}

	var name = $.util.env.n;
    var destPath = './src/services/' + name + '/'
    var cameledName = name.replace(/-([a-z])/g, function (g) { return g[1].toUpperCase() });

    gulp.src('templates/filter/template.filter.coffee')
    	.pipe($.template({
            appName: pjson.name,
    		cameledName: cameledName
    	}))
    	.pipe($.rename(name + ".filter.coffee"))
    	.pipe(gulp.dest(destPath));
});


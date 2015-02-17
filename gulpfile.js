var gulp         = require('gulp'),
  bower          = require('gulp-bower'),
  mainBowerFiles = require('main-bower-files'),
  concat         = require('gulp-concat'),
  jsoncombine    = require('gulp-jsoncombine'),
  less           = require('gulp-less'),
  plumber        = require('gulp-plumber'),
  sourcemaps     = require('gulp-sourcemaps'),
  coffee         = require('gulp-coffee'),
  clean          = require('gulp-clean'),
  webserver      = require('gulp-webserver'),
  _              = require('lodash');

gulp.task('bower', function() {
  bower('./public/lib');
});

gulp.task('bower:concat', ['bower'], function(){
  return gulp.src(mainBowerFiles({filter: /\.js$/}))
    .pipe(plumber())
    .pipe(sourcemaps.init())
      .pipe(concat('dependencies.js'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./public/assets/dist/'));
});


gulp.task('coffee:clean', function(){
  return gulp.src(['./app/compiled'], {read: false})
    .pipe(clean())
})

gulp.task('coffee:compile', ['coffee:clean'], function(){
  return gulp.src(['./public/app/**/*.coffee'])
    .pipe(plumber())
      .pipe(coffee())
      .pipe(concat('application.js'))
      .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('./public/assets/dist/'));
});

gulp.task('webserver', function(){
  return gulp.src('./public')
    .pipe(webserver({
      port: 8888,
      livereload: true,
      directoryListing: false,
      open: false
    }));
})

gulp.task('default', ['bower:concat', 'coffee:compile'], function() {});

gulp.task('watch', ['default', 'webserver'], function() {
  gulp.watch(['./bower.json'], ['bower']);
  gulp.watch(['./public/app/**/*.js', './public/app/*.js'], ['javascript:concat']);
  gulp.watch(['./public/app/**/*.coffee', './public/app/*.coffee'], ['coffee:compile']);
});

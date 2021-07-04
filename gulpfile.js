var gulp, tap, livescript, gulpLivescript, gulpRename, gulpYaml, replace, gutil, fs, wait, z;
gulp = require('gulp');
tap = require('gulp-tap');
livescript = require('livescript');
gulpLivescript = require('gulp-livescript');
gulpRename = require('gulp-rename');
gulpYaml = require('gulp-yaml');
replace = require('gulp-replace');
gutil = require('gulp-util');
fs = require('fs');
wait = function(t, f){
  return setTimeout(f, t);
};
z = console.log;
gulp.task('default', function(done){
  var ls;
  gulp.src("./src/package.yaml").pipe(gulpYaml({
    schema: 'DEFAULT_FULL_SCHEMA',
    space: 2
  })).on('error', function(it){
    throw it;
  }).pipe(gulp.dest("."));
  gulp.src("./src/gulpfile.ls").pipe(gulpLivescript({
    bare: true
  })).on('error', gutil.log).on('error', function(it){
    throw it;
  }).pipe(gulp.dest("."));
  gulp.src("./src/main.ls").pipe(gulpLivescript({
    bare: true
  })).on('error', gutil.log).on('error', function(it){
    throw it;
  }).pipe(gulp.dest("./dist"));
  ls = gulp.src("./src/*/*.ls").pipe(gulpLivescript({
    bare: true
  })).on('error', gutil.log).on('error', function(it){
    throw it;
  }).pipe(gulp.dest("./dist"));
  ls.on('end', function(){
    var rawJson, version_number;
    rawJson = JSON.parse(fs.readFileSync('./package.json').toString());
    version_number = rawJson.version;
    return gulp.src("./dist/utils/main.js").pipe(replace('__VERSION__', version_number)).pipe(gulp.dest("./dist/utils/"));
  });
  gulp.src("./test/*/*.ls").pipe(gulpLivescript({
    bare: true
  })).on('error', gutil.log).on('error', function(it){
    throw it;
  }).pipe(gulp.dest("./test"));
  return done();
});
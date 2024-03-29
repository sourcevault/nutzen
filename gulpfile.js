var gulp, tap, gulpLivescript, gulpRename, gulpYaml, replace, gutil, fs, cp, z, wait, def;
gulp = require('gulp');
tap = require('gulp-tap');
gulpLivescript = require('gulp-livescript');
gulpRename = require('gulp-rename');
gulpYaml = require('gulp-yaml');
replace = require('gulp-replace');
gutil = require('gulp-util');
fs = require('fs');
cp = require('child_process');
z = console.log;
wait = function(t, f){
  return setTimeout(f, t);
};
def = function(done){
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
  ls = gulp.src("./src/*/*.ls").pipe(gulpLivescript({
    bare: true
  })).on('error', gutil.log).on('error', function(it){
    throw it;
  }).pipe(gulp.dest("./dist"));
  ls.on('end', function(){
    var rawJson, version_number, T;
    rawJson = JSON.parse(fs.readFileSync('./package.json').toString());
    version_number = rawJson.version;
    return T = gulp.src("./dist/internal/main.js").pipe(replace('__VERSION__', version_number)).pipe(gulp.dest("./dist/internal/")).on('done', function(){});
  });
  return gulp.src("./test/*/*.ls").pipe(gulpLivescript({
    bare: true
  })).on('error', gutil.log).on('error', function(it){
    throw it;
  }).pipe(gulp.dest("./test"));
};
gulp.task('default', def);
gulp.task('watch', function(){
  return gulp.watch(["./src", "./test/*/*.ls"], gulp.series('default', function(done){
    return done();
  }));
});
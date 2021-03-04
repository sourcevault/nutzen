var gulp, tap, livescript, gulpLivescript, gulpRename, gulpYaml, z;
gulp = require('gulp');
tap = require('gulp-tap');
livescript = require('livescript');
gulpLivescript = require('gulp-livescript');
gulpRename = require('gulp-rename');
gulpYaml = require('gulp-yaml');
z = console.log;
gulp.task('compile', function(done){
  gulp.src("./src/package.yaml").pipe(gulpYaml({
    schema: 'DEFAULT_SAFE_SCHEMA'
  })).pipe(gulp.dest("."));
  gulp.src("./src/gulpfile.ls").pipe(gulpLivescript({
    bare: true
  })).pipe(gulp.dest("."));
  gulp.src("./src/*/*.ls").pipe(gulpLivescript({
    bare: true
  })).pipe(gulp.dest("./dist"));
  gulp.src("./test/*/*.ls").pipe(gulpLivescript({
    bare: true
  })).pipe(gulp.dest("./test"));
  return done();
});
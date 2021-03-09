gulp            = require \gulp

tap             = require \gulp-tap

livescript      = require \livescript

gulp-livescript = require \gulp-livescript

gulp-rename     = require \gulp-rename

gulp-yaml       = require \gulp-yaml

z = console.log

gulp.task \compile, (done) ->

  gulp.src "./src/package.yaml"

  .pipe gulp-yaml({schema:\DEFAULT_SAFE_SCHEMA})

  .pipe gulp.dest "."

  # ------------------------------

  gulp.src "./src/gulpfile.ls"

  .pipe gulp-livescript bare:true

  .pipe gulp.dest "."

  # ------------------------------

  gulp.src "./src/main.ls"

  .pipe gulp-livescript bare:true

  .pipe gulp.dest "./dist"

  # ------------------------------

  gulp.src "./src/*/*.ls"

  .pipe gulp-livescript bare:true

  .pipe gulp.dest "./dist"

  # ------------------------------

  gulp.src "./test/*/*.ls"

  .pipe gulp-livescript bare:true

  .pipe gulp.dest "./test"

  done!
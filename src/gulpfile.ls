gulp            = require \gulp

tap             = require \gulp-tap

livescript      = require \livescript

gulp-livescript = require \gulp-livescript

gulp-rename     = require \gulp-rename

gulp-yaml       = require \gulp-yaml

replace         = require \gulp-replace

fs              = require \fs

wait = (t,f)-> setTimeout f,t

z = console.log

gulp.task \default,(done) ->

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

  ls = gulp.src "./src/*/*.ls"

  .pipe gulp-livescript bare:true

  .pipe gulp.dest "./dist"

  do

    <- ls.on \end

    raw-json = JSON.parse (fs.readFileSync \./package.json).toString!

    version_number = raw-json.version

    gulp.src "./dist/types/print.common.js"

    .pipe replace \__VERSION__,version_number

    .pipe gulp.dest "./dist/types/"


  # ------------------------------

  gulp.src "./test/*/*.ls"

  .pipe gulp-livescript bare:true

  .pipe gulp.dest "./test"

  done!
gulp            = require \gulp

tap             = require \gulp-tap

livescript      = require \livescript

gulp-livescript = require \gulp-livescript

gulp-rename     = require \gulp-rename

gulp-yaml       = require \gulp-yaml

replace         = require \gulp-replace

gutil           = require \gulp-util

gulp_changed    = require \gulp-changed

fs              = require \fs

wait = (t,f)-> setTimeout f,t

gulp.task \default,(done) ->

  gulp.src "./src/package.yaml"

  # .pipe gulp_changed ".",(extension:'.json')

  .pipe gulp-yaml({schema:\DEFAULT_FULL_SCHEMA,space:2})

  .on \error -> throw it

  .pipe gulp.dest "."

  ## ------------------------------

  gulp.src "./src/gulpfile.ls"

  # .pipe gulp_changed ".",(extension:'.js')

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "."

  ## ------------------------------

  gulp.src "./src/main.ls"

  # .pipe gulp_changed "./dist",(extension:'.js')

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "./dist"

  ## ------------------------------

  ls = gulp.src "./src/*/*.ls"

  # .pipe gulp_changed "./dist",(extension:'.js')

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "./dist"

  do

    <- ls.on \end

    raw-json = JSON.parse (fs.readFileSync \./package.json).toString!

    version_number = raw-json.version

    gulp.src "./dist/utils/main.js"

    .pipe replace \__VERSION__,version_number

    .pipe gulp.dest "./dist/utils/"

  ## ------------------------------

  gulp.src "./test/*/*.ls"

  # .pipe gulp_changed "./test",(extension:'.js')

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "./test"

  done!

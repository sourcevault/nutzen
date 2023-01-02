gulp            = require \gulp

tap             = require \gulp-tap

gulp-livescript = require \gulp-livescript

gulp-rename     = require \gulp-rename

gulp-yaml       = require \gulp-yaml

replace         = require \gulp-replace

gutil           = require \gulp-util

fs              = require \fs

cp              = require \child_process

z               = console.log

wait = (t,f)-> setTimeout f,t

def = (done) ->

  gulp.src "./src/package.yaml"

  .pipe gulp-yaml({schema:\DEFAULT_FULL_SCHEMA,space:2})

  .on \error -> throw it

  .pipe gulp.dest "."

  ## ------------------------------

  gulp.src "./src/gulpfile.ls"

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "."

  ## ------------------------------

  gulp.src "./src/main.ls"

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "./dist"

  ## ------------------------------

  ls = gulp.src "./src/*/*.ls"

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "./dist"

  do

    <- ls.on \end

    raw-json = JSON.parse (fs.readFileSync \./package.json).toString!

    version_number = raw-json.version

    T = gulp.src "./dist/utils/main.js"

    .pipe replace \__VERSION__,version_number

    .pipe gulp.dest "./dist/utils/"

    .on \done, ->

  ## ------------------------------

  gulp.src "./test/*/*.ls"

  .pipe gulp-livescript bare:true

  .on \error,gutil.log

  .on \error -> throw it

  .pipe gulp.dest "./test"


gulp.task \default, def

gulp.task \watch,->

  gulp.watch do
    ["./src","./test/*.ls"]
    gulp.series \default,(done)->

      ta = cp.execSync "node ./test/types/test10.js || exit 1"
      process.stdout.write ta.toString!

      done!











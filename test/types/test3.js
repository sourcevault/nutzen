var ref$, utils, types, z, l, R, j, print_fail, be, p, SA, main, ret, e;
ref$ = require('../../dist/main'), utils = ref$.utils, types = ref$.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
p = print_fail("test/types/test3.js");
SA = be.str.or(be.arr.or(be.num));
main = be.obj.on("chokidar", be.obj.on("path", SA));
ret = main.auth({
  chokidar: {}
});
try {
  if (!(ret.path.join(".") === "chokidar.path")) {
    p(".path is mangled");
  }
} catch (e$) {
  e = e$;
  p("something has gone wrong with .path");
}
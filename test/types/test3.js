var pkg, utils, types, z, l, R, j, print_fail, be, p, inner, SA, main, ret, e;
pkg = require('../../dist/types/main');
utils = pkg.utils, types = pkg.types;
z = utils.z, l = utils.l, R = utils.R, j = utils.j, print_fail = utils.print_fail;
be = types;
p = print_fail("test/types/test3.js");
inner = be.arr.or(be.num);
SA = be.str.or(inner);
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